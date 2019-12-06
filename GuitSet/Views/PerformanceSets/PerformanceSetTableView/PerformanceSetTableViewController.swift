//
//  PerformanceSetTableViewController.swift
//  GuitSet
//
//  Created by Graeme Zinck on 2019-09-02.
//  Copyright © 2019 Graeme Zinck. All rights reserved.
//

import UIKit

/**
 Root view controller for the application, with a global view of all performance sets and options to
 enter, edit, delete, and add more sets.
 */
class PerformanceSetTableViewController: UITableViewController {

    // On load, we bring performance sets into memory and set up the table view.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Allow editing of the sets.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.allowsSelectionDuringEditing = true
    }
    
    // Every time the view appears, we want to reload the data. This is because
    // it might change without a proper unwind (e.g., by pressing back button).
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // There is only one section.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Set the number of rows to be the number of performance sets.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PerformanceSetController.performanceSets.count
    }

    // Create a cell for a given row and populate it.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PerformanceSet", for: indexPath) as! PerformanceSetTableViewCell
        
        // Sets the cell up with the corresponding performance set
        let performanceSet = PerformanceSetController.performanceSets[indexPath.row]
        cell.setPerformanceSet(performanceSet: performanceSet)

        return cell
    }
    
    // Make sure each row has the same height as its respective image.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            PerformanceSetController.performanceSets.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // When selecting an item, we either segue to show the performance set or
    // edit the set's details.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            performSegue(withIdentifier: "EditPerformanceSet", sender: self)
        } else {
            performSegue(withIdentifier: "ShowPerformanceSet", sender: self)
        }
    }

    // MARK: - Navigation

    // When showing or editing a set, we pass along the performance set information
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If we're editing the set...
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
            let performanceSet = PerformanceSetController.performanceSets[index]
            addPerformanceSetTableViewController.performanceSet = performanceSet
        }
        // Otherwise, if we're showing the set...
        else if segue.identifier == "ShowPerformanceSet" {
            // If we're now showing the song list for the performance...
            guard let index = tableView.indexPathForSelectedRow?.row else { return }
            guard let songListTableViewController = segue.destination as? SongListTableViewController else { return }
            
            songListTableViewController.setIndex = index
        }
    }
    
    /**
     Unwinds from the 'Add Performance Set' screen and adds the set to the list. It performs a check if the
     set is new or if it is just editing a previously present set.
     
     - Parameter unwindSegue: The segue that is leading us to this point. The source of the segue
     should be the 'Add Performance Set' screen (for editing or adding sets).
     */
    @IBAction func unwindAddPerformanceSet(for unwindSegue: UIStoryboardSegue) {
        if unwindSegue.identifier == "AddPerformanceSet" {
            guard let addPerformanceSetTableViewController = unwindSegue.source as? AddPerformanceSetTableViewController, let performanceSet = addPerformanceSetTableViewController.performanceSet else { return }
            
            // First, check if it's an add or an edit
            if let indexPath = tableView.indexPathForSelectedRow {
                PerformanceSetController.performanceSets[indexPath.row] = performanceSet
                tableView.deselectRow(at: indexPath, animated: true)
            } else {
                PerformanceSetController.performanceSets.append(performanceSet)
            }
        }
        tableView.reloadData()
    }

}
