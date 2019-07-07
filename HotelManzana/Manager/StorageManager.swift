//
//  StorageManager.swift
//  HotelManzana
//
//  Created by Alexander on 07/07/2019.
//  Copyright © 2019 Alexander Shigin. All rights reserved.
//

import Foundation

class StorageManager {
    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let archiveURL: URL
    
    init() {
        archiveURL = documentDirectory.appendingPathComponent("contacts").appendingPathExtension("plist")
    }
    
    func save(contacts: [Registration]) {
        let encoder = PropertyListEncoder()
        guard let encodedContacts = try? encoder.encode(contacts) else { return }
        try? encodedContacts.write(to: archiveURL, options: .noFileProtection)
    }

    func load() -> [Registration]? {
        guard let data = try? Data(contentsOf: archiveURL) else { return nil }
        let decoder = PropertyListDecoder()
        return try? decoder.decode([Registration].self, from: data)
    }
}
