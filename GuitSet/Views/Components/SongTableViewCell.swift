//
//  SongTableViewCell.swift
//  GuitSet
//
//  Created by Graeme Zinck on 2019-12-05.
//  Copyright © 2019 Graeme Zinck. All rights reserved.
//

import UIKit
import BFWControls

class SongTableViewCell: NibTableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var artistLabel: UILabel!
    private var song: Song?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setSong(_ song: Song) {
        self.song = song
        titleLabel.text = song.title != "" ? song.title : "No Title"
        artistLabel.text = song.artist != "" ? song.artist : "No Artist"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
