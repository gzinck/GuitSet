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
    
    /// Any class that needs to be notified of song changes should be a delegate
    private static var delegates: [SongControllerDelegate] = []
    
    /// The song dictionary for the application, taking IDs and giving the Song objects.
    private static var songDict: [Int:Song] = [:] {
        didSet {
            // Save it
            songsUpdated()
        }
    }
    /// The highest ID of a song in the dictionary.
    private static var highestID = 0
    
    /// The song list for the application. This is read-only.
    static var songList: [Song] {
        get {
            return Array(songDict.values).sorted { (s1, s2) -> Bool in
                if(s1.title < s2.title) { return true }
                if(s1.title > s2.title) { return false }
                if(s1.artist < s2.artist) { return true }
                if(s1.artist > s2.artist) { return false }
                if(!s1.draft && s2.draft) { return true }
                if(s1.draft && !s2.draft) { return false }
                return s1.id < s2.id
            }
        }
    }
    
    /// The song list with only songs which have been completed.
    static var finishedSongList: [Song] {
        get {
            let songs = songDict.values.filter({!$0.draft})
            return songs.sorted { (s1, s2) -> Bool in
                if(s1.title < s2.title) { return true }
                if(s1.title > s2.title) { return false }
                if(s1.artist < s2.artist) { return true }
                if(s1.artist > s2.artist) { return false }
                return s1.id < s2.id
            }
        }
    }
    
    /// The song list with only songs which have not been completed.
    static var draftSongList: [Song] {
        get {
            let songs = songDict.values.filter({$0.draft})
            return songs.sorted { (s1, s2) -> Bool in
                if(s1.title < s2.title) { return true }
                if(s1.title > s2.title) { return false }
                if(s1.artist < s2.artist) { return true }
                if(s1.artist > s2.artist) { return false }
                return s1.id < s2.id
            }
        }
    }
    
    /// The number of songs.
    static var numSongs: Int {
        get {
            return songDict.count
        }
    }
    
    /**
     Adds a delegate which will be told whenever the song dictionary changes.
     
     - parameter delegate: A listener for the song controller.
     */
    static func addDelegate(_ delegate: SongControllerDelegate) {
        delegates.append(delegate)
    }
    
    /**
     Removes a delegate.
     
     - parameter delegate: The delegate to remove
     */
    static func removeDelegate(_ delegate: SongControllerDelegate) {
        delegates.removeAll { (aDelegate) -> Bool in
            return aDelegate === delegate
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
     Creates a song and adds it  to the song dictionary.
     
     - returns: The song which was just added
     */
    static func createSong() -> Song {
        highestID += 1
        let song = Song(id: highestID)
        songDict[highestID] = song
        return song
    }
    
    /**
     Gets a song using its ID.
     
     - parameter id: The ID of the song to get.
     */
    static func getSong(_ id: Int) -> Song? {
        return songDict[id]
    }
    
    /**
     Gets all songs with the IDs listed as input. If a song is not in the dictionary,
     then it is not included.
     
     - parameter ids: The IDs of songs to get.
     */
    static func getSongs(_ ids: [Int]) -> [Song] {
        var songs: [Song] = []
        for id in ids {
            if let song = songDict[id] {
                songs.append(song)
            }
        }
        return songs
    }
    
    /**
     Notifies delegates that the songs have been updated.
     */
    static func songsUpdated() {
        for delegate in delegates {
            delegate.songsWereUpdated()
        }
        Song.saveToFile(songDict)
    }
    
    /**
     Removes a song using its ID.
     
     - parameter id: The ID of the song to remove.
     - returns: Whether the song was successfully removed or not.
     */
    @discardableResult
    static func removeSong(_ id: Int) -> Bool {
        if(songDict.removeValue(forKey: id) != nil) {
            return true
        }
        return false
    }
    
    /**
     Removes a given song from the song controller.
     
     - parameter song: The song to remove.
     - returns: Whether the song was successfully removed or not.
     */
    @discardableResult
    static func removeSong(_ song: Song) -> Bool {
        return removeSong(song.id)
    }

    /**
     Gets a song dictionary with placeholders (for testing purposes only).
     
     - returns: Dictionary of sample songs.
     */
    static func getPlaceholderSongs() -> [Int:Song] {
        return [
            1: Song("My Bonnie Lies Over the Ocean", by: "Somebody", capo: 0, chords: "These are the chords", id: 1),
            2: Song("Bill Nye the Science Guy", by: "Bill Nye", capo: 0, chords: "N/A", id: 2)
        ]
    }
}
