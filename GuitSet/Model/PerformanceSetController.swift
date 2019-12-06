//
//  PerformanceSetController.swift
//  GuitSet
//
//  Created by Graeme Zinck on 2019-09-02.
//  Copyright © 2019 Graeme Zinck. All rights reserved.
//

import Foundation

/**
 The controller that keeps track of all data in the application. It cannot be instantiated, it is only used for accessing its
 static variable: performanceSets. This variable keeps all of the performance sets in the application. Whenever it changes,
 the changes are saved to disk. Upon opening the application, all of the performance sets are loaded from file.
 */
class PerformanceSetController {
    /// The initialization of a PerformanceSetController is not allowed.
    private init() {}
    
    /// The performance sets for the application.
    static var performanceSets: [PerformanceSet] = [] {
        didSet {
            PerformanceSet.saveToFile(performanceSets)
        }
    }
    
    /**
     Gets a performance set, given its index.
     
     - parameter index: The index of the performance set to get.
     - returns: The corresponding performance set, or nil if it does not exist.
     */
    static func getPerformanceSet(index: Int) -> PerformanceSet? {
        if(index < performanceSets.count) {
            return performanceSets[index]
        }
        return nil
    }
    
    /// Initializes the performance sets by loading from file.
    static func initializePerformanceSets() {
        guard performanceSets.count == 0 else { return }
        if let performanceSets = PerformanceSet.loadFromFile() {
            self.performanceSets = performanceSets
        } else {
            self.performanceSets = getPlaceholderPerformanceSets()
        }
    }
    
    /// Sets up dummy performance sets in the application.
    static func getPlaceholderPerformanceSets() -> [PerformanceSet] {
        var sets = [
            PerformanceSet(name: "My First Set", at: "The Bathroom", on: Date(), with: [.piano], image: nil),
            PerformanceSet(name: "My Second Set", at: "The Laundry Room", on: Date(), with: [.piano], image: nil),
            PerformanceSet(name: "My Third Set", at: "Mars", on: Date(), with: [.piano], image: nil)
        ]
        sets[0].songIDs = [1]
        return sets
    }
}
