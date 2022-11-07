//
//  User.swift
//  UserProfile
//
//  Created by 백소망 on 2022/11/02.
//

import Foundation

struct UserResponse: Codable {
    var results: [User]
}

struct User: Codable {
    let name: Name
    let email: String
    let picture: Picture
    
    struct Name: Codable {
        let title: String
        let first: String
        let last: String
        
        var full: String {
            return "\(title.capitalized). \(first.capitalized) \(last.capitalized)"
        }
    }
    
    struct Picture: Codable {
        let large: String
        let medium: String
        let thumbnail: String
    }
}
