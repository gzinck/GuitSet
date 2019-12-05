//
//  SongController.swift
//  GuitSet
//
//  Created by Graeme Zinck on 2019-12-02.
//  Copyright © 2019 Graeme Zinck. All rights reserved.
//

import Foundation

/**
 The controller that keeps track of all songs that are stored in the application.
 */
class SongController {
    /// The initialization of a SongController is not allowed
    private init() {}
    
    /// The song dictionary for the application, taking IDs and giving the Song objects.
    private static var songDict: [Int:Song] = [:] {
        didSet {
            // Save it
            Song.saveToFile(songDict)
        }
    }
    /// The highest ID of a song in the dictionary.
    private static var highestID = 0
    
    /// The song list for the application. This is read-only.
    static var songList: [Song] {
        get {
            return Array(songDict.values)
        }
    }
    
    /**
     Initializes the song dictionary in memory by loading from file, if applicable, or just getting placeholders.
     This function should be called before using the song dictionary.
     */
    static func initializeSongDict() {
        guard songDict.count == 0 else { return }
        if let songs = Song.loadFromFile() {
            self.songDict = songs
        } else {
            self.songDict = getPlaceholderSongs()
        }
        for (k, _) in songDict {
            if(k > highestID) {
                highestID = k
            }
        }
    }
    
    /**
     Adds a song to the song dictionary.
     
     - parameter song: The song to add to the dictionary.
     */
    static func addSong(_ song: Song) {
        highestID += 1
        songDict[highestID] = song
    }
    
    /**
     Gets a song using its ID.
     
     - parameter id: The ID of the song to get.
     */
    static func getSong(_ id: Int) -> Song? {
        return songDict[id]
    }
    
    /**
     Removes a song using its ID.
     
     - parameter id: The ID of the song to remove.
     - returns: Whether the song was successfully removed or not.
     */
    static func removeSong(_ id: Int) -> Bool {
        if(songDict.removeValue(forKey: id) != nil) {
            return true
        }
        return false
    }

    /**
     Gets a song dictionary with placeholders (for testing purposes only).
     
     - returns: Dictionary of sample songs.
     */
    static func getPlaceholderSongs() -> [Int:Song] {
        return [
            1: Song("My Bonnie Lies Over the Ocean", by: "Somebody", capo: 0, chords: "These are the chords"),
            2: Song("Bill Nye the Science Guy", by: "Bill Nye", capo: 0, chords: "N/A")
        ]
    }
}
