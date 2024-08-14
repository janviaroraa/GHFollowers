//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Janvi Arora on 13/08/24.
//

import Foundation

class NetworkManager {

    static let shared = NetworkManager()

    let baseURL = "https://api.github.com/users/"
    let perPageFollowersCount = 100

    private init() { }

    func getFollowers(for username: String, pageNumber: Int, completion: @escaping ([Follower]?, String?) -> Void) {
        let endpoint = baseURL + "\(username)/followers?per_page=\(perPageFollowersCount)&page=\(pageNumber)"

        guard let url = URL(string: endpoint) else {
            completion(nil, "This username created an invalid request. Please try again with some differnt & valid username")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(nil,  "Unable to complete the request. Please check your internet connection.")
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(nil, "Invalid response from the server. Please try again.")
                return
            }

            guard let data else {
                completion(nil, "The data received from the server is invalid. Please try again.")
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completion(followers, nil)
            } catch {
                completion(nil, "Failed to parse the data. Please try again.")
            }

        }.resume()
    }
}
