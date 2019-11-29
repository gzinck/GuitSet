//
//  InstrumentTableViewController.swift
//  GuitSet
//
//  Created by Graeme Zinck on 2019-09-03.
//  Copyright © 2019 Graeme Zinck. All rights reserved.
//

import UIKit

class InstrumentTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    var selectedInstruments: [Instrument] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Instrument.all.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InstrumentCell", for: indexPath)

        let instrument = Instrument.all[indexPath.row]
        cell.textLabel?.text = instrument.rawValue
        if selectedInstruments.contains(instrument) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let instrument = Instrument.all[indexPath.row]
        if let index = selectedInstruments.firstIndex(of: instrument) {
            selectedInstruments.remove(at: index)
        } else {
            selectedInstruments.append(instrument)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    // When navigate to the parent, update the instrument list
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let addPerformanceSetTableViewController = navigationController.topViewController as? AddPerformanceSetTableViewController {
            addPerformanceSetTableViewController.updateInstruments(selectedInstruments)
        }
    }
}
