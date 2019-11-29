//
//  PerformanceSet.swift
//  GuitSet
//
//  Created by Graeme Zinck on 2019-09-02.
//  Copyright © 2019 Graeme Zinck. All rights reserved.
//

import Foundation

struct PerformanceSet: Codable {
    static var documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static var archiveURL = documentsDirectory.appendingPathComponent("performancesets").appendingPathExtension("plist")
    
    var name: String?
    var performanceLocation: String?
    var performanceDate: Date?
    var instruments: [Instrument]?
    var image: Data?
    var songs: [Song]
    
    init() {
        self.songs = []
    }
    
    init(name: String?, at performanceLocation: String?, on performanceDate: Date?, with instruments: [Instrument]?, image: Data?) {
        self.name = name
        self.performanceLocation = performanceLocation
        self.performanceDate = performanceDate
        self.instruments = instruments
        self.image = image
        self.songs = []
    }
    
    static func saveToFile(_ performanceSets: [PerformanceSet]) {
        let encoder = PropertyListEncoder()
        let encodedPerformanceSets = try? encoder.encode(performanceSets)
        try? encodedPerformanceSets?.write(to: archiveURL, options: .noFileProtection)
    }
    
    static func loadFromFile() -> [PerformanceSet]? {
        let decoder = PropertyListDecoder()
        
        if let data = try? Data(contentsOf: archiveURL), let decodedPerformanceSets = try? decoder.decode(Array<PerformanceSet>.self, from: data) {
            return decodedPerformanceSets
        }
        return nil
    }
}

enum Instrument: String, CaseIterable, Codable {
    case piano = "Piano"
    case guitar = "Guitar"
    case ukelele = "Ukelele"
    case other = "Other"
    static let all = [piano, guitar, ukelele, other]
}

struct Song: Codable {
    var name: String
    var artist: String
    var capo: Int
    var key: Key
}

enum Key: String, Codable {
    case ab = "Ab"
    case a = "A"
    case bb = "Bb"
    case b = "B"
    case c = "C"
    case db = "Db"
    case d = "D"
    case eb = "Eb"
    case e = "E"
    case f = "F"
    case gb = "Gb"
    case g = "G"
}
