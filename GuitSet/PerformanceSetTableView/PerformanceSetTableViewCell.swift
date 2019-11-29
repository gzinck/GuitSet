//
//  PerformanceSetTableViewCell.swift
//  GuitSet
//
//  Created by Graeme Zinck on 2019-09-02.
//  Copyright © 2019 Graeme Zinck. All rights reserved.
//

import UIKit

class PerformanceSetTableViewCell: UITableViewCell {

    @IBOutlet var performanceSetImage: UIImageView!
    @IBOutlet var performanceSetNameLabel: UILabel!
    @IBOutlet var performanceSetDateLabel: UILabel!
    
    var performanceSet: PerformanceSet?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // Initialize the cell with performance information
    func setPerformanceSet(performanceSet: PerformanceSet) {
        self.performanceSet = performanceSet
        refreshPerformanceSet()
    }
    
    // Refresh the view with the current performance set
    func refreshPerformanceSet() {
        guard let performanceSet = performanceSet else { return }
        
        performanceSetNameLabel.text = performanceSet.name
        
        // Set the performance date, if applicable
        if let performanceSetDate = performanceSet.performanceDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            performanceSetDateLabel.text = dateFormatter.string(from: performanceSetDate)
        } else {
            performanceSetDateLabel.text = nil
        }
        
        // Set the image, if applicable
        if let data = performanceSet.image, let image = UIImage(data: data) {
            performanceSetImage.image = image
        } else {
            performanceSetImage.image = nil
        }
        performanceSetImage.contentMode = .scaleAspectFill
    }
}
