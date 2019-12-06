//
//  PerformanceSet.swift
//  GuitSet
//
//  Created by Graeme Zinck on 2019-09-02.
//  Copyright © 2019 Graeme Zinck. All rights reserved.
//

import Foundation

/// The structure for a performance set (including set liists, etc).
class PerformanceSet: Codable, NSCopying {
    /// The directory for documents to be stored in the FileManager.
    static var documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    /// The specific directory for storing the performance sets.
    static var archiveURL = documentsDirectory.appendingPathComponent("performancesets").appendingPathExtension("plist")
    
    /// The name of the performance set.
    var name: String?
    /// The location of the performance.
    var performanceLocation: String?
    /// The data of the performance.
    var performanceDate: Date?
    /// The instruments which are used for a performance.
    var instruments: [Instrument]?
    /// An image representing the performance (JPG).
    var image: Data?
    /// A list of song IDs for the performance set.
    var songIDs: [Int]
    
    /**
     Creates a new, empty performance set.
     */
    init() {
        self.instruments = []
        self.songIDs = []
    }
    
    /**
     Creates a new performance set.
     
     - parameters:
        - name: Name of the performance set to be created.
        - performanceLocation: Address of the place to perform.
        - performanceDate: The date of the planned/past performance.
        - instruments: The instruments used in the set.
        - image: An image representing the performance.
     */
    init(name: String?, at performanceLocation: String?, on performanceDate: Date?, with instruments: [Instrument]?, image: Data?, songIDs: [Int] = []) {
        self.name = name
        self.performanceLocation = performanceLocation
        self.performanceDate = performanceDate
        self.instruments = instruments
        self.image = image
        self.songIDs = songIDs
    }
    
    /**
     Saves an array of performance sets to file for retrieval later on.
     
     - parameter performanceSets: The performance sets to save to file.
     */
    static func saveToFile(_ performanceSets: [PerformanceSet]) {
        let encoder = PropertyListEncoder()
        let encodedPerformanceSets = try? encoder.encode(performanceSets)
        try? encodedPerformanceSets?.write(to: archiveURL, options: .noFileProtection)
    }
    
    /**
     Loads performance sets from file.
     */
    static func loadFromFile() -> [PerformanceSet]? {
        let decoder = PropertyListDecoder()
        
        if let data = try? Data(contentsOf: archiveURL), let decodedPerformanceSets = try? decoder.decode(Array<PerformanceSet>.self, from: data) {
            return decodedPerformanceSets
        }
        return nil
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let newInstruments = instruments
        let newSongIDs = songIDs
        return PerformanceSet(name: name, at: performanceLocation, on: performanceDate, with: newInstruments, image: image, songIDs: newSongIDs)
    }
}

/// Types of instruments which are available in the application for selection.
enum Instrument: String, CaseIterable, Codable {
    case piano = "Piano"
    case guitar = "Guitar"
    case ukelele = "Ukelele"
    case other = "Other"
    static let all = [piano, guitar, ukelele, other]
}
