//
//  GFError.swift
//  GHFollowers
//
//  Created by Janvi Arora on 15/08/24.
//

import Foundation

enum GFError: String, Error {
    case invalidUsername = "This username created an invalid request. Please try again with some differnt & valid username"
    case incompleteRequest = "Unable to complete the request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server is invalid. Please try again."
    case parsingError = "Failed to parse the data. Please try again."
}
