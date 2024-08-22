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
