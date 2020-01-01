//
//  AllSongsSelectorTableViewController.swift
//  GuitSet
//
//  Created by Graeme Zinck on 2019-12-06.
//  Copyright © 2019 Graeme Zinck. All rights reserved.
//

import UIKit

/**
 View controller for selecting which songs are a part of a performance set.
 It results in a set of selected song IDs.
 */
class AllSongsSelectorTableViewController: UITableViewController {
    /// The songs which we are able to select
    var songs: [Song] = SongController.finishedSongList
    /// The IDs of all the songs selected
    var selectedIDs: Set<Int> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        songs = SongController.finishedSongList
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return songs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let genericCell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath)
        guard let cell = genericCell as? SongTableViewCell else { return genericCell }
        guard indexPath.row < songs.count else { return genericCell }
        cell.setSong(songs[indexPath.row])
        if(selectedIDs.contains(songs[indexPath.row].id)) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let id = songs[indexPath.row].id
        if(selectedIDs.contains(id)) {
            selectedIDs.remove(id)
        } else {
            selectedIDs.insert(id)
        }
        tableView.reloadData()
    }
}
