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
class SongListTableViewController: UITableViewController {
    
    /// The index of the performance set full of songs we want to use.
    var setIndex: Int? {
        didSet {
            guard let index = setIndex else { return }
            self.title = PerformanceSetController.getPerformanceSet(index: index)?.name
        }
    }
    
    /// The songs in the performance set
    var songs: [Song] {
        guard let index = setIndex,
            let set = PerformanceSetController.getPerformanceSet(index: index) else { return [] }
        return SongController.getSongs(set.songIDs)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
            return songs.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // If no index for the set, then we have a problem.
        guard let setIndex = setIndex else {
            return tableView.dequeueReusableCell(withIdentifier: "PerformanceInfo", for: indexPath)
        }
        
        // Configure the set information cells
        if(indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PerformanceInfo", for: indexPath)
            switch(indexPath.row) {
            case 0:
                // Location cell
                cell.detailTextLabel?.text = "Location"
                cell.textLabel?.text = PerformanceSetController.performanceSets[setIndex].performanceLocation
            case 1:
                // Date cell
                cell.detailTextLabel?.text = "Date"
                if let performanceSetDate = PerformanceSetController.performanceSets[setIndex].performanceDate {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .medium
                    cell.textLabel?.text = dateFormatter.string(from: performanceSetDate)
                } else {
                    cell.textLabel?.text = nil
                }
            case 2:
                // Instrument cell
                var instruments = ""
                for instrument in PerformanceSetController.performanceSets[setIndex].instruments ?? [] {
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
            // For displaying a song in the list
            let genericCell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath)
            guard let cell = genericCell as? SongTableViewCell else { return genericCell }
            guard indexPath.row < songs.count else { return genericCell }
            cell.setSong(songs[indexPath.row])
            return cell
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
            
        }
    }
    
    // MARK: - Navigation

    // When a performance set is to be edited, go to a different view controller
    // and pass the set to edit
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditPerformanceSet" {
            guard let navigationController = segue.destination as? UINavigationController else { return }
            guard let addPerformanceSetTableViewController = navigationController.viewControllers.first as? AddPerformanceSetTableViewController else { return }
            guard let index = setIndex else { return }
            let performanceSet = PerformanceSetController.performanceSets[index]
            addPerformanceSetTableViewController.performanceSet = performanceSet
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
                let performanceSet = addPerformanceSetTableViewController.performanceSet,
                let setIndex = setIndex
                else { return }
            
            PerformanceSetController.performanceSets[setIndex] = performanceSet
            
            // Reload data
            tableView.reloadData()
            self.title = PerformanceSetController.performanceSets[setIndex].name
        }
    }

}
