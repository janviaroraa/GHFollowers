//
//  User.swift
//  GHFollowers
//
//  Created by Janvi Arora on 13/08/24.
//

import Foundation

struct User: Codable {
    let login: String?
    let avatarUrl: String?
    let name: String?
    let location: String?
    let bio: String?
    let publicRepos: Int?
    let publicGists: Int?
    let htmlUrl: String?
    let followers: Int?
    let following: Int?
    let followersUrl: String?
    let createdAt: String?
}
