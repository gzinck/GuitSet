//
//  Song.swift
//  GuitSet
//
//  Created by Graeme Zinck on 2019-12-02.
//  Copyright © 2019 Graeme Zinck. All rights reserved.
//

import Foundation

/// The metadata for a song.
struct Song: Codable {
    /// The directory for document storage.
    static var documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    /// The specific directory for storing the songs.
    static var archiveURL = documentsDirectory.appendingPathComponent("songdictionary").appendingPathExtension("plist")
    
    /// The name of the song.
    var name: String
    /// The artist of the song.
    var artist: String
    /// The capo for the song.
    var capo: Int
    /// The chords and lyrics for the song.
    var chords: String
    /// Whether the song is a draft or not
    var draft: Bool
    
    /// Creates a new, empty song
    init() {
        self.name = ""
        self.artist = ""
        self.capo = 0
        self.chords = ""
        self.draft = true
    }
    
    /**
     Creates a new Song from the provided data.
     
     - parameters:
        - name: The name of the song.
        - artist: The name of the artist of the song.
        - capo: The number of frets for the capo.
        - chords: The chords and lyrics for the song.
     */
    init(_ name: String, by artist: String, capo: Int, chords: String) {
        self.name = name
        self.artist = artist
        self.capo = capo
        self.chords = chords
        self.draft = false
    }
    
    /**
     Saves a dictionary of songs (ID -> Song) to file for retrieval later on.
     
     - parameter songDict: A dictionary of song IDs and their corresponding song objects to save to file.
     */
    static func saveToFile(_ songDict: [Int:Song]) {
        let encoder = PropertyListEncoder()
        let encodedSongDict = try? encoder.encode(songDict)
        try? encodedSongDict?.write(to: archiveURL, options: .noFileProtection)
    }
    
    /**
     Loads songs from file
     */
    static func loadFromFile() -> [Int:Song]? {
        let decoder = PropertyListDecoder()
        
        if let data = try? Data(contentsOf: archiveURL), let decodedSongDict = try? decoder.decode(Dictionary<Int,Song>.self, from: data) {
            return decodedSongDict
        }
        return nil
    }
}
