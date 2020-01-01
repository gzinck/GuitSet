//
//  SongListTableViewController.swift
//  GuitSet
//
//  Created by Graeme Zinck on 2019-09-26.
//  Copyright © 2019 Graeme Zinck. All rights reserved.
//

import UIKit

/**
 View controller that displays all songs for a given performance set, indicated by the set's index stored in the
 DataController.
 */
class SongListTableViewController: UITableViewController, SongControllerDelegate {
    
    /// The performance set with all songs we want to perform
    var performanceSet: PerformanceSet? {
        didSet {
            guard let performanceSet = performanceSet else { return }
            self.title = performanceSet.name
        }
    }
    
    /// The songs in the performance set
    var songs: [Song] {
        guard let performanceSet = performanceSet else { return [] }
        return SongController.getSongs(performanceSet.songIDs)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Allow editing of the sets.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.allowsSelectionDuringEditing = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SongController.addDelegate(self)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SongController.removeDelegate(self)
    }
    
    func songsWereUpdated() {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    // Should only have two sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    // For the first section, it should have 3 rows.
    // The second section has as many rows as songs to display.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0:
            return 3
        case 1:
            return songs.count + 1 // Extra one for the add button
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // If no index for the set, then we have a problem.
        guard let performanceSet = performanceSet else {
            return tableView.dequeueReusableCell(withIdentifier: "PerformanceInfo", for: indexPath)
        }
        
        // Configure the set information cells
        if(indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PerformanceInfo", for: indexPath)
            switch(indexPath.row) {
            case 0:
                // Location cell
                cell.detailTextLabel?.text = "Location"
                cell.textLabel?.text = performanceSet.performanceLocation
            case 1:
                // Date cell
                cell.detailTextLabel?.text = "Date"
                if let performanceSetDate = performanceSet.performanceDate {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .medium
                    cell.textLabel?.text = dateFormatter.string(from: performanceSetDate)
                } else {
                    cell.textLabel?.text = nil
                }
            case 2:
                // Instrument cell
                var instruments = ""
                for instrument in performanceSet.instruments ?? [] {
                    instruments += ", " + instrument.rawValue
                }
                if instruments.count > 2 {
                    instruments.removeFirst(2) // Remove first two characters
                }
                cell.detailTextLabel?.text = "Instruments"
                cell.textLabel?.text = instruments
            default:
                cell.textLabel?.text = ""
            }
            return cell
        } else {
            if(indexPath.row < songs.count) {
                // For displaying a song in the list
                let genericCell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath)
                guard let cell = genericCell as? SongTableViewCell else { return genericCell }
                cell.setSong(songs[indexPath.row])
                return cell
            } else {
                return tableView.dequeueReusableCell(withIdentifier: "AddSongsCell", for: indexPath)
            }
        }
    }
    
    // The headers for each section show what data is contained
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0:
            return "Set Information"
        case 1:
            return "Set List"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Set information section
        if(indexPath.section == 0) {
            // Edit it... this is done on the Storyboard (for now)
        } else if(indexPath.row < songs.count) {
            // Open the song
        } else {
            // Segue to add songs
            performSegue(withIdentifier: "SelectSongs", sender: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        guard let performanceSet = performanceSet else { return false }
        if(indexPath.section == 1 && indexPath.row < performanceSet.songIDs.count) { return true }
        return false
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        guard let performanceSet = performanceSet else { return .none }
        if(indexPath.section == 1 && indexPath.row < performanceSet.songIDs.count) { return .delete }
        else { return .none }
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        if(indexPath.section == 1) { return true }
        return false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(indexPath.section == 1 && indexPath.row < songs.count && editingStyle == .delete) {
            performanceSet?.songIDs.remove(at: indexPath.row)
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if(sourceIndexPath.section == 1 && destinationIndexPath.section == 1) {
            guard let performanceSet = performanceSet else { return }
            if destinationIndexPath.row >= performanceSet.songIDs.count {
                let id = performanceSet.songIDs.remove(at: sourceIndexPath.row)
                performanceSet.songIDs.append(id)
                tableView.reloadData()
            } else {
                let id = performanceSet.songIDs.remove(at: sourceIndexPath.row)
                performanceSet.songIDs.insert(id, at: destinationIndexPath.row)
            }
        }
    }
    
    // MARK: - Navigation

    // When THIS performance set is to be edited, go to a different view controller
    // and pass the set to edit
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If we're editing the set...
        if segue.identifier == "EditPerformanceSet" {
            guard let navigationController = segue.destination as? UINavigationController else { return }
            guard let addPerformanceSetTableViewController = navigationController.viewControllers.first as? AddPerformanceSetTableViewController else { return }
            guard let performanceSet = performanceSet else { return }
            addPerformanceSetTableViewController.performanceSet = performanceSet.copy() as? PerformanceSet
        }
        // If we're selecting songs for the set...
        else if segue.identifier == "SelectSongs" {
            guard let navigationController = segue.destination as? UINavigationController else { return }
            guard let selectSongsController = navigationController.viewControllers.first as? AllSongsSelectorTableViewController else { return }
            guard let performanceSet = performanceSet else { return }
            selectSongsController.selectedIDs = Set(performanceSet.songIDs)
        }
        // If we're looking at the song...
        else if segue.identifier == "ShowSong" {
            guard let songView = segue.destination as? SongTableViewController, let indexPath = tableView.indexPathForSelectedRow else { return }
            guard let performanceSet = performanceSet else { return }
            songView.songId = performanceSet.songIDs[indexPath.row]
        }
        // Deselect what was selected, if anything
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    /// When returning from editing a performance set, we should update the information in the model and
    /// update what's displayed on this page.
    @IBAction func unwindAddPerformanceSet(for unwindSegue: UIStoryboardSegue) {
        if unwindSegue.identifier == "AddPerformanceSet" {
            guard let addPerformanceSetTableViewController = unwindSegue.source as? AddPerformanceSetTableViewController,
                let newSet = addPerformanceSetTableViewController.performanceSet,
                let oldSet = performanceSet
                else { return }
            
            PerformanceSetController.replace(oldSet, with: newSet)
            performanceSet = newSet
            // Reload data
            tableView.reloadData()
            self.title = newSet.name
        }
    }
    
    
    @IBAction func unwindEditSongList(for unwindSegue: UIStoryboardSegue) {
        if unwindSegue.identifier == "SelectSongs" {
            guard let allSongsSelector = unwindSegue.source as? AllSongsSelectorTableViewController, let performanceSet = performanceSet else { return }
            
            var selected = allSongsSelector.selectedIDs
            var newSongIDs: [Int] = []
            
            // Go through the songs in the array, add the ones that are already there and selected
            for songID in performanceSet.songIDs {
                if(selected.contains(songID)) {
                    newSongIDs.append(songID)
                    selected.remove(songID)
                }
            }
            // Append any newly added songs
            for songID in selected {
                newSongIDs.append(songID)
            }
            
            performanceSet.songIDs = newSongIDs
        }
        tableView.reloadData()
    }

}
