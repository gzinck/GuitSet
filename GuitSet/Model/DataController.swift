//
//  DataController.swift
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
class DataController {
    /// The initialization of a DataController is not allowed.
    private init() {}
    
    /// The performance sets for the application.
    static var performanceSets: [PerformanceSet] = [] {
        didSet {
            PerformanceSet.saveToFile(performanceSets)
            print("performanceSets edited")
        }
    }
    
    /// Initializes the performance sets by loading from file.
    static func initializePerformanceSets() {
        if let performanceSets = PerformanceSet.loadFromFile() {
            self.performanceSets = performanceSets
        } else {
            self.performanceSets = getPlaceholderPerformanceSets()
        }
    }
    
    /// Sets up dummy performance sets in the application.
    static func getPlaceholderPerformanceSets() -> [PerformanceSet] {
        return [
            PerformanceSet(name: "My First Set", at: "The Bathroom", on: Date(), with: [.piano], image: nil),
            PerformanceSet(name: "My Second Set", at: "The Laundry Room", on: Date(), with: [.piano], image: nil),
            PerformanceSet(name: "My Third Set", at: "Mars", on: Date(), with: [.piano], image: nil)
        ]
    }
}
