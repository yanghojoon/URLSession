//
//  JSONParser.swift
//  KakaoBankAppStoreSearch
//
//  Created by 양호준 on 2023/09/17.
//

import Foundation

enum JSONParserError: LocalizedError {
    case decodingFail
    
    var errorDescription: String? {
        switch self {
        case .decodingFail:
            return "디코딩에 실패했습니다."
        }
    }
}

struct JSONParser<Item: Decodable> {
    func decode(from json: Data?) -> Item? {
        guard let data = json else {
            return nil
        }

        let decoder = JSONDecoder()

        guard let decodedData = try? decoder.decode(Item.self, from: data) else {
            return nil
        }

        return decodedData
    }
}
