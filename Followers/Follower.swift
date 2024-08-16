//
//  Follower.swift
//  GHFollowers
//
//  Created by Janvi Arora on 13/08/24.
//

import Foundation

struct Follower: Codable, Hashable {
    let login: String?
    let avatarUrl: String?

    // Making both login & avatarUrl hashable or we can just conform to Hashable in this case because login and avatarUrl both are hashable by default since they are String type

    // If we want to make only login as hashabl, write below code

//    func hash(into hasher: inout Hasher) {
//        hasher.combine(login)
//    }
    
}
