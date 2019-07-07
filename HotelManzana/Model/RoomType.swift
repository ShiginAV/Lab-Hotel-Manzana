//
//  RoomType.swift
//  HotelManzana
//
//  Created by Alexander on 01/07/2019.
//  Copyright © 2019 Alexander Shigin. All rights reserved.
//

import Foundation

struct RoomType : Codable {
    var id: Int
    var name: String
    var shortName: String
    var price: Int
}

extension RoomType : Equatable {
    static func == (left: RoomType, right: RoomType) -> Bool {
        return left.id == right.id
    }
}

extension RoomType {
    static var all: [RoomType] {
        return [
            RoomType(id: 0, name: "Two Queens", shortName: "2Q", price: 179),
            RoomType(id: 1, name: "One King", shortName: "K", price: 209),
            RoomType(id: 2, name: "Penthouse Suit", shortName: "PHS", price: 309)
        ]
    }
}
