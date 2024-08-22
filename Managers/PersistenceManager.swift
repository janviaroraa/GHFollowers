//
//  PersistenceManager.swift
//  GHFollowers
//
//  Created by Janvi Arora on 19/08/24.
//

import UIKit

enum PersistenceAction {
    case add
    case remove
}

// We are making it enum because of just a minor difference, i.e. you can not initialize an empty enum
enum PersistenceManager {

    enum Keys {
        static let favourites = "favourites"
    }

    static private let defaults = UserDefaults.standard

    static func retrieveFavourites(completion: @escaping (Result<[Follower], GFError>) -> Void) {

        // Imp: Swift knows that there could be an object in UserDefaults, but doesn't know which kind of object is it. So, we have it cast to the apt type (Data here).
        guard let favouritesData = defaults.object(forKey: Keys.favourites) as? Data else {
            completion(.success([]))
            return
        }

        do {
            let favourites = try JSONDecoder().decode([Follower].self, from: favouritesData)
            completion(.success(favourites))
        } catch {
            completion(.failure(.unableToFavourite))
        }
    }

    // This is returning a GFError, because when we are saving it, then we are encoding it into `Data` & just like the above func `retrieveFavourites` it has the possiblity of failing & throwing an error in the encoding process.
    // GFError is made optional because it could be nil - success case
    static func save(favourites: [Follower]) -> GFError? {
        do {
            let encodedFavourites = try JSONEncoder().encode(favourites)
            defaults.set(encodedFavourites, forKey: Keys.favourites)
            return nil
        } catch {
            return .unableToFavourite
        }
    }

    static func update(_ favourite: Follower, actionType: PersistenceAction, completion: @escaping (GFError?) -> Void) {
        retrieveFavourites { result in
            switch result {
            case .success(var favourites):
                switch actionType {
                case .add:
                    guard !favourites.contains(favourite) else {
                        completion(.alreadyInFavourites)
                        return
                    }
                    favourites.append(favourite)
                case .remove:
                    favourites.removeAll { $0.login == favourite.login }
                }

                completion(save(favourites: favourites))
            case .failure(let error):
                completion(error)
            }
        }
    }
}
