//
//  TextView.swift
//  GuitSet
//
//  Created by Graeme Zinck on 2019-12-01.
//  Copyright © 2019 Graeme Zinck. All rights reserved.
//

import UIKit

class TextView: UITextView {
    let padding = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textContainerInset = padding
    }
}
