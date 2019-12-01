//
//  TextField.swift
//  GuitSet
//
//  Created by Graeme Zinck on 2019-12-01.
//  Copyright © 2019 Graeme Zinck. All rights reserved.
//

import SwiftUI

class TextField : UITextField {
    let padding = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
