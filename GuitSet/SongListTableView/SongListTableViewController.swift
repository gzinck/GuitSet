//
//  SongListTableViewController.swift
//  GuitSet
//
//  Created by Graeme Zinck on 2019-09-26.
//  Copyright © 2019 Graeme Zinck. All rights reserved.
//

import UIKit

class SongListTableViewController: UITableViewController {
    
    var setIndex: Int? {
        didSet {
            guard let index = setIndex else { return }
            self.title = DataController.performanceSets[index].name
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0:
            return 3
        case 1:
            guard let setIndex = setIndex else { return 0 }
            return DataController.performanceSets[setIndex].songs.count
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
                cell.detailTextLabel?.text = "Location"
                cell.textLabel?.text = DataController.performanceSets[setIndex].performanceLocation
            case 1:
                cell.detailTextLabel?.text = "Date"
                if let performanceSetDate = DataController.performanceSets[setIndex].performanceDate {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .medium
                    cell.textLabel?.text = dateFormatter.string(from: performanceSetDate)
                } else {
                    cell.textLabel?.text = nil
                }
            case 2:
                var instruments = ""
                for instrument in DataController.performanceSets[setIndex].instruments ?? [] {
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
        }
        // Configure the set song list
        return tableView.dequeueReusableCell(withIdentifier: "PerformanceInfo", for: indexPath)
    }
    
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "EditPerformanceSet" {
            guard let navigationController = segue.destination as? UINavigationController else { return }
            guard let addPerformanceSetTableViewController = navigationController.viewControllers.first as? AddPerformanceSetTableViewController else { return }
            guard let index = setIndex else { return }
            let performanceSet = DataController.performanceSets[index]
            addPerformanceSetTableViewController.performanceSet = performanceSet
        }
        // Deselect what was selected, if anything
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    @IBAction func unwindAddPerformanceSet(for unwindSegue: UIStoryboardSegue) {
        if unwindSegue.identifier == "AddPerformanceSet" {
            guard let addPerformanceSetTableViewController = unwindSegue.source as? AddPerformanceSetTableViewController, let performanceSet = addPerformanceSetTableViewController.performanceSet, let setIndex = setIndex else { return }
            
            DataController.performanceSets[setIndex] = performanceSet
            
            // Reload data
            tableView.reloadData()
            self.title = DataController.performanceSets[setIndex].name
        }
    }

}
