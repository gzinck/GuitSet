//
//  Song.swift
//  GuitSet
//
//  Created by Graeme Zinck on 2019-12-02.
//  Copyright © 2019 Graeme Zinck. All rights reserved.
//

import Foundation

/// The metadata for a song. Note that songs should *never* be instantiated directly;
/// they should only be instantiated by the SongController.
class Song: Codable {
    /// The directory for document storage.
    static var documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    /// The specific directory for storing the songs.
    static var archiveURL = documentsDirectory.appendingPathComponent("songdictionary").appendingPathExtension("plist")
    
    /// The title of the song.
    var title: String
    /// The artist of the song.
    var artist: String
    /// The capo for the song.
    var capo: Int
    /// The chords and lyrics for the song.
    var chords: String
    /// Whether the song is a draft or not
    var draft: Bool
    /// The ID for the song
    var id: Int
    /// Whether the song is empty or not
    var isEmpty: Bool {
        if(title == "" && artist == "" && capo == 0 && chords == "" && draft == true) {
            return true
        }
        return false
    }
    
    /**
     Creates a new, empty song. This should only ever be called by the SongController, which assigns
     unique IDs to every song.
     
     - parameter id: The ID of the song created.
     */
    init(id: Int) {
        self.title = ""
        self.artist = ""
        self.capo = 0
        self.chords = ""
        self.draft = true
        self.id = id
    }
    
    /**
     Creates a new Song from the provided data.
     
     - parameters:
        - title: The title of the song.
        - artist: The name of the artist of the song.
        - capo: The number of frets for the capo.
        - chords: The chords and lyrics for the song.
        - id: The unique ID of the song.
     */
    init(_ title: String, by artist: String, capo: Int, chords: String, id: Int) {
        self.title = title
        self.artist = artist
        self.capo = capo
        self.chords = chords
        self.draft = false
        self.id = id
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
