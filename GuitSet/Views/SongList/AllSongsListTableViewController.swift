//
//  AllSongsListTableViewController.swift
//  GuitSet
//
//  Created by Graeme Zinck on 2019-12-05.
//  Copyright © 2019 Graeme Zinck. All rights reserved.
//

import UIKit

/**
 View controller that lists all the songs. This is one of the main views of the application, allowing
 viewing and deleting songs.
 */
class AllSongsListTableViewController: UITableViewController, SongControllerDelegate {
    
    /// Array with all finished songs to display.
    var finishedSongs: [Song] = SongController.finishedSongList
    
    /// Array with all unfinished songs to display.
    var draftSongs: [Song] = SongController.draftSongList

    /// ID for the song being editd, if any
    var editedSongId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        finishedSongs = SongController.finishedSongList
        draftSongs = SongController.draftSongList
    }
    
    /// It should listen to the SongController for when there are changes.
    override func viewWillAppear(_ animated: Bool) {
        songsWereUpdated()
        SongController.addDelegate(self)
    }
    
    /// It stops listening to changes in the song list when it disappears.
    override func viewDidDisappear(_ animated: Bool) {
        SongController.removeDelegate(self)
    }
    
    func songsWereUpdated() {
        finishedSongs = SongController.finishedSongList
        draftSongs = SongController.draftSongList
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return finishedSongs.count
        } else if section == 1 {
            return draftSongs.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Finished Songs"
        } else if section == 1 {
            return "Draft Songs"
        }
        return ""
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let genericCell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath)
        
        guard let cell = genericCell as? SongTableViewCell else { return genericCell }
        
        if indexPath.section == 0 {
            if(indexPath.row < finishedSongs.count) {
                cell.setSong(finishedSongs[indexPath.row])
            }
        } else if indexPath.section == 1 {
            if(indexPath.row < draftSongs.count) {
                cell.setSong(draftSongs[indexPath.row])
            }
        }

        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let songId = (indexPath.section == 0) ? finishedSongs[indexPath.row].id : draftSongs[indexPath.row].id
            // Delete the row from the data source
            SongController.removeSong(songId)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if(indexPath.row < finishedSongs.count) {
                editedSongId = finishedSongs[indexPath.row].id
            }
        } else if indexPath.section == 1 {
            if(indexPath.row < draftSongs.count) {
                editedSongId = draftSongs[indexPath.row].id
            }
        }
        performSegue(withIdentifier: "ShowSong", sender: self)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // When showing an individual song, set the songId
        if(segue.identifier == "ShowSong") {
            guard let songView = segue.destination as? SongTableViewController, let editedSongId = editedSongId else { return }
            songView.songId = editedSongId
        }
    }

}
