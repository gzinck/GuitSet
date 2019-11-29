//
//  InstrumentSelectorDelegate.swift
//  GuitSet
//
//  Created by Graeme Zinck on 2019-11-29.
//  Copyright © 2019 Graeme Zinck. All rights reserved.
//

/**
 Protocol that allows an InstrumentTableViewController to pass the instruments selected to the previous view
 after pressing the back button.
 */
protocol InstrumentSelectorDelegate {
    /**
    Updates the instruments for the performance set.
    
    This is typically called by a child view for selecting instruments.
    
    - parameter selectedInstruments: List of instruments which were selected.
    */
    func updateInstruments(_ selectedInstruments: [Instrument])
}
