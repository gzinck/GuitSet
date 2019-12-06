//
//  AllSongsSelectorTableViewController.swift
//  GuitSet
//
//  Created by Graeme Zinck on 2019-12-06.
//  Copyright © 2019 Graeme Zinck. All rights reserved.
//

import UIKit

class AllSongsSelectorTableViewController: UITableViewController {
    
    var songs: [Song] = SongController.songList
    var selectedIDs: Set<Int> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        songs = SongController.songList
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

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
