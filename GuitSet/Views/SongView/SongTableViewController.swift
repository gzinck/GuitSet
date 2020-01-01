//
//  SongTableViewController.swift
//  GuitSet
//
//  Created by Graeme Zinck on 2020-01-01.
//  Copyright © 2020 Graeme Zinck. All rights reserved.
//

import UIKit

/**
 View for seeing a single song's information and lyrics.
 */
class SongTableViewController: UITableViewController, SongControllerDelegate {
    
    /// The label with the artist's name
    @IBOutlet var artistLabel: UILabel!
    /// The label with the capo
    @IBOutlet var capoLabel: UILabel!
    /// The label with the song chords
    @IBOutlet var songChordsLabel: UILabel!
    
    
    /// The song to be displayed
    var songId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Make sure it updates with the SongController
    override func viewWillAppear(_ animated: Bool) {
        SongController.addDelegate(self)
        songsWereUpdated()
    }
    
    // Stop listening when it disappears
    override func viewWillDisappear(_ animated: Bool) {
        SongController.removeDelegate(self)
    }
    
    /// When songs are updated, this updates the view.
    func songsWereUpdated() {
        if let songId = songId, let song = SongController.getSong(songId) {
            self.title = (song.title == "") ? "Draft Song" : song.title
            self.artistLabel.text = song.artist
            self.capoLabel.text = "\(song.capo)"
            self.songChordsLabel.text = song.chords
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ShowEditSong") {
            guard let songId = songId, let navigationController = segue.destination as? InterceptableNavigationController, let createSongView = navigationController.viewControllers.first as? CreateSongTableViewController else { return }
            createSongView.song = SongController.getSong(songId)
        }
    }

}
