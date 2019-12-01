//
//  InstrumentTableViewController.swift
//  GuitSet
//
//  Created by Graeme Zinck on 2019-09-03.
//  Copyright © 2019 Graeme Zinck. All rights reserved.
//

import UIKit

/**
 View controller that allows a user to choose which instruments are part of a performance set. It is given a set of instruments,
 and when the screen is about to be dismissed, it calls a function 'updateInstruments' on the previous view controller.
 
 The view controller that asks this one for a list of instruments must implement the InstrumentSelectorDelegate protocol.
 */
class InstrumentTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    /// List of instruments selected so far.
    var selectedInstruments: [Instrument] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
    }

    // MARK: - Table view data source

    // Only one section for showing all instruments.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Have one row for every instrument that is possible.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Instrument.all.count
    }

    // Each cell should have an instrument which is either checked or not.
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
    
    // When selecting a row, see if we should select or deselect.
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
    
    // When navigate to the parent, update the instrument list.
    // Parent MUST implement the InstrumentSelectorDelegate protocol.
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let instrumentSelectorDelegate = navigationController.topViewController as? InstrumentSelectorDelegate {
            instrumentSelectorDelegate.updateInstruments(selectedInstruments)
        }
    }
}
