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
    private static var performanceSets: [PerformanceSet] = [] {
        didSet {
            PerformanceSet.saveToFile(performanceSets)
        }
    }
    
    /// The number of performance sets
    static var numPerformanceSets: Int {
        return performanceSets.count
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
    
    /**
     Gets a copy of a performance set, given its index.
     
     - parameter index: The index of the performance set to get.
     - returns: The corresponding performance set copy, or nil if it does not exist.
     */
    static func getPerformanceSetCopy(index: Int) -> PerformanceSet? {
        if(index < performanceSets.count) {
            return performanceSets[index].copy() as? PerformanceSet
        }
        return nil
    }
    
    /**
     Gets the index of a given set in the performance set list.
     
     - parameter set: The set to find.
     - returns: The index of the performance set.
     */
    static func indexOf(_ set: PerformanceSet) -> Int? {
        return performanceSets.firstIndex { (currSet) -> Bool in
            return currSet === set // Gets the set that is identical
        }
    }
    
    /**
     Replaces a set with a newer version.
     
     - parameters:
        - originalSet: The original version of the set which needs to be replaced.
        - newSet: The new version of the set.
     */
    static func replace(_ originalSet: PerformanceSet, with newSet: PerformanceSet) {
        guard let index = indexOf(originalSet) else { return }
        replacePerformanceSet(index: index, set: newSet)
    }
    
    /**
     Removes the performance set at the given index.
     
     - parameter index: The index of the performance set to remove.
     */
    static func removePerformanceSet(index: Int) {
        performanceSets.remove(at: index)
    }
    
    /**
     Adds a performance set to the controller.
     
     - parameter set: The performance set to add.
     */
    static func addPerformanceSet(_ set: PerformanceSet) {
        performanceSets.append(set)
    }
    
    /**
     Replaces a performance set at the index desired.
     
     - parameters:
        - index: The index of the performance set to replace.
        - set: The performance set which is to be used.
     */
    static func replacePerformanceSet(index: Int, set: PerformanceSet) {
        performanceSets[index] = set
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
        let sets = [
            PerformanceSet(name: "My First Set", at: "The Bathroom", on: Date(), with: [.piano], image: nil),
            PerformanceSet(name: "My Second Set", at: "The Laundry Room", on: Date(), with: [.piano], image: nil),
            PerformanceSet(name: "My Third Set", at: "Mars", on: Date(), with: [.piano], image: nil)
        ]
        sets[0].songIDs = [1]
        return sets
    }
}
