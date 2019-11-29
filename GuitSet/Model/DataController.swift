//
//  DataController.swift
//  GuitSet
//
//  Created by Graeme Zinck on 2019-09-02.
//  Copyright © 2019 Graeme Zinck. All rights reserved.
//

import Foundation

class DataController {
    private init() {}
    
    static var performanceSets: [PerformanceSet] = [] {
        didSet {
            PerformanceSet.saveToFile(performanceSets)
            print("performanceSets edited")
        }
    }
    
    static func initializePerformanceSets() {
        if let performanceSets = PerformanceSet.loadFromFile() {
            self.performanceSets = performanceSets
        } else {
            self.performanceSets = getPlaceholderPerformanceSets()
        }
    }
    
    static func getPlaceholderPerformanceSets() -> [PerformanceSet] {
        return [
            PerformanceSet(name: "My First Set", at: "The Bathroom", on: Date(), with: [.piano], image: nil),
            PerformanceSet(name: "My Second Set", at: "The Laundry Room", on: Date(), with: [.piano], image: nil),
            PerformanceSet(name: "My Third Set", at: "Mars", on: Date(), with: [.piano], image: nil)
        ]
    }
}
