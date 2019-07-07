//
//  Registration.swift
//  HotelManzana
//
//  Created by Alexander on 01/07/2019.
//  Copyright © 2019 Alexander Shigin. All rights reserved.
//

import Foundation

struct Registration : Codable {
    var firstName: String
    var lastName: String
    var emailAddress: String
    
    var checkInDate: Date
    var checkOutDate: Date
    
    var numberOfAdults: Int
    var numberOfChildren: Int
    
    var roomType: RoomType
    var wifi: Bool
}

extension Registration {
    init() {
        firstName = ""
        lastName = ""
        emailAddress = ""
        checkInDate = Date()
        checkOutDate = Date()
        numberOfAdults = 0
        numberOfChildren = 0
        roomType = RoomType(id: 0, name: "", shortName: "", price: 0)
        wifi = false
    }
}
