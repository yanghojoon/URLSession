//
//  Image.swift
//  URLSession+CollectionView
//
//  Created by 양호준 on 2023/10/18.
//

import Foundation

struct Image: Decodable, Hashable {
    let id: String
    let createdAt: String
    let description: String
    let urls: ImageURL
    let likes: Int
    
    enum CodingKeys: String, CodingKey {
        case urls, likes, id
        case description = "alt_description"
        case createdAt = "created_at"
    }
    
    static func == (lhs: Image, rhs: Image) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
            return hasher.combine(id)
        }
}

struct ImageURL: Decodable {
    let regular: String
    let small: String
}
