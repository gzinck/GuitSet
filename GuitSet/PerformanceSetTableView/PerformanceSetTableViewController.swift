//
//  PerformanceSetTableViewController.swift
//  GuitSet
//
//  Created by Graeme Zinck on 2019-09-02.
//  Copyright © 2019 Graeme Zinck. All rights reserved.
//

import UIKit

class PerformanceSetTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the performance sets from memory
        DataController.initializePerformanceSets()

        // Allow editing of the sets
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.allowsSelectionDuringEditing = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataController.performanceSets.count
    }

    // Create the cell when it needs to be displayed
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PerformanceSet", for: indexPath) as! PerformanceSetTableViewCell
        
        let performanceSet = DataController.performanceSets[indexPath.row]
        cell.setPerformanceSet(performanceSet: performanceSet)

        return cell
    }
    
    
    // Make sure each row has the same height as its respective image
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            DataController.performanceSets.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // Override to support editing each item.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            performSegue(withIdentifier: "EditPerformanceSet", sender: self)
        } else {
            performSegue(withIdentifier: "ShowPerformanceSet", sender: self)
        }
    }

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

    // Pass along the item to edit
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "EditPerformanceSet" {
            guard let navigationController = segue.destination as? UINavigationController else {
                return
            }
            guard let addPerformanceSetTableViewController = navigationController.viewControllers.first as? AddPerformanceSetTableViewController else {
                return
            }
            guard let index = tableView.indexPathForSelectedRow?.row else {
                return
            }
            let performanceSet = DataController.performanceSets[index]
            addPerformanceSetTableViewController.performanceSet = performanceSet
        } else if segue.identifier == "ShowPerformanceSet" {
            // If we're now showing the song list for the performance...
            guard let index = tableView.indexPathForSelectedRow?.row else { return }
            guard let songListTableViewController = segue.destination as? SongListTableViewController else { return }
            
            songListTableViewController.setIndex = index
        }
    }
    
    
    @IBAction func unwindAddPerformanceSet(for unwindSegue: UIStoryboardSegue) {
        if unwindSegue.identifier == "AddPerformanceSet" {
            guard let addPerformanceSetTableViewController = unwindSegue.source as? AddPerformanceSetTableViewController, let performanceSet = addPerformanceSetTableViewController.performanceSet else { return }
            
            // First, check if it's an add or an edit
            if let indexPath = tableView.indexPathForSelectedRow {
                DataController.performanceSets[indexPath.row] = performanceSet
                tableView.deselectRow(at: indexPath, animated: true)
            } else {
                DataController.performanceSets.append(performanceSet)
            }
        }
        tableView.reloadData()
    }

}
