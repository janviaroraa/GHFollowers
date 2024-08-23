//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Janvi Arora on 13/08/24.
//

import UIKit

class NetworkManager {

    static let shared = NetworkManager()

    let baseURL = "https://api.github.com/users/"
    let perPageFollowersCount = 99
    var cache = NSCache<NSString, UIImage>()

    private init() { }

    func getFollowers(for username: String, pageNumber: Int, completion: @escaping (Result<[Follower], GFError>) -> Void) {
        // Ways to form endpointURL

        // Approach 1
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = "/users/\(username)/followers"
        components.queryItems = [
            URLQueryItem(name: "per_page", value: String(perPageFollowersCount)),
            URLQueryItem(name: "page", value: String(pageNumber))
        ]

        print(components.url ?? "")

        // Approach 2
        let endpoint = baseURL + "\(username)/followers?per_page=\(perPageFollowersCount)&page=\(pageNumber)"

        print(endpoint)

        // Both components.url & endpoint will print out same url

        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidUsername))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.incompleteRequest))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }

            guard let data else {
                completion(.failure(.invalidData))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completion(.success(followers))
            } catch {
                completion(.failure(.parsingError))
            }
        }.resume()
    }

    func getUserInfo(for username: String, completion: @escaping (Result<User, GFError>) -> Void) {
        let endpoint = baseURL + "\(username)"

        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidUsername))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.incompleteRequest))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }

            guard let data else {
                completion(.failure(.invalidData))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                // Standard = .iso8601
                // "yyyy-MM-dd'T'HH:mm:ssZ"
                
                // This does same things as our custom func convertToDate()
                // & now in order to use below instead of custom extension, we have to make out relative argument of type `Date` i.e `createdAt` attibute.
                decoder.dateDecodingStrategy = .iso8601

                let user = try decoder.decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(.parsingError))
            }
        }.resume()
    }
}

// Refactored Code (iOS 15.0)
class UpdatedNetworkManager {

    static let shared = UpdatedNetworkManager()

    private let baseURL = "https://api.github.com/users/"
    private let perPageFollowersCount = 99
    var cache = NSCache<NSString, UIImage>()
    private let decoder = JSONDecoder()

    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }

    func getFollowers(for username: String, pageNumber: Int) async throws -> [Follower] {
        let endpoint = baseURL + "\(username)/followers?per_page=\(perPageFollowersCount)&page=\(pageNumber)"

        guard let url = URL(string: endpoint) else {
            throw GFError.invalidUsername
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GFError.invalidResponse
        }

        do {
            let followers = try decoder.decode([Follower].self, from: data)
            return followers
        } catch {
            throw GFError.parsingError
        }
    }

    func getUserInfo(for username: String) async throws -> User {
        let endpoint = baseURL + "\(username)"
        guard let url = URL(string: endpoint) else { throw GFError.invalidUsername }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw GFError.invalidResponse }

        do {
            return try decoder.decode(User.self, from: data)
        } catch {
            throw GFError.parsingError
        }
    }

    // We are not marking it throws because w edon't care about errors here, if the network call fails, we'll just show the placeholder image
    func downloadImage(from urlString: String) async -> UIImage? {
        let cacheKey = NSString(string: urlString)

        if let image = cache.object(forKey: cacheKey) {
            return image
        }

        guard let url = URL(string: urlString) else { return nil }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            cache.setObject(image, forKey: cacheKey)
            return image
        } catch {
            return nil
        }
    }
}

// Usage
class Random: UIViewController {

    func getFollowers() {

        // Approach 1
        Task {
            do {
                let followers = try await UpdatedNetworkManager.shared.getFollowers(for: "janviaroraa", pageNumber: 1)
                print(followers)
            } catch {
                // handle errors
                // We can get 2 types of errors here: GFError & Error
                // GFError: from guard statements
                // Error: from - try await URLSession.shared.data(from: url)

                if let gfError = error as? GFError {
                    // We don't have to go on main thread now
                    presentAlert(title: "", message: gfError.rawValue, buttonTitle: "")
                } else {
                    // Or make some default error alert
                    print(error.localizedDescription)
                }
            }
        }

        // Approach 2
        Task {
            guard let followers = try? await UpdatedNetworkManager.shared.getFollowers(for: "janviaroraa", pageNumber: 1) else {
                presentAlert(title: "", message: "", buttonTitle: "")
                return
            }
            print(followers)
        }
    }
}
