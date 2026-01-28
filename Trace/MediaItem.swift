//
//  MediaItem.swift
//  Trace
//
//  Created by Bryce Albertazzi on 1/26/26.
//

import Foundation

struct MediaItem: Identifiable, Codable {
    let id: UUID
    var fileName: String
    var date: Date

    init(id: UUID = UUID(), fileName: String, date: Date) {
        self.id = id
        self.fileName = fileName
        self.date = date
    }
}
