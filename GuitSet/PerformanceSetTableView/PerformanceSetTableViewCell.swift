//
//  PerformanceSetTableViewCell.swift
//  GuitSet
//
//  Created by Graeme Zinck on 2019-09-02.
//  Copyright © 2019 Graeme Zinck. All rights reserved.
//

import UIKit

/**
 Cell for a table view that lists performance sets. This cell takes in a performance set and extracts the image,
 name, and date. These three elements are displayed in an attractive fashion. Each cell is 78px tall.
 */
class PerformanceSetTableViewCell: UITableViewCell {

    /// The image view showing the performance's image.
    @IBOutlet var performanceSetImage: UIImageView!
    /// The label showing the performance name.
    @IBOutlet var performanceSetNameLabel: UILabel!
    /// The label showing the performance date.
    @IBOutlet var performanceSetDateLabel: UILabel!
    /// The performance set model object containing all information on the performance set.
    /// Updates the cell when changed.
    var performanceSet: PerformanceSet? {
        didSet {
            guard let performanceSet = performanceSet else { return }
            
            performanceSetNameLabel.text = performanceSet.name
            
            // Set the performance date, if applicable.
            if let performanceSetDate = performanceSet.performanceDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                performanceSetDateLabel.text = dateFormatter.string(from: performanceSetDate)
            } else {
                performanceSetDateLabel.text = nil
            }
            
            // Set the image, if applicable.
            if let data = performanceSet.image, let image = UIImage(data: data) {
                performanceSetImage.image = image
            } else {
                performanceSetImage.image = nil
            }
            
            // Format the image to an appropriate content mode.
            performanceSetImage.contentMode = .scaleAspectFill
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    /**
     Initializes the cell with information from a performance set model object.
     - parameter performanceSet: The performance set model object with information to display in the cell.
     */
    func setPerformanceSet(performanceSet: PerformanceSet) {
        self.performanceSet = performanceSet
    }
}
