//
//  UIViewController.swift
//  GuitSet
//
//  Created by Graeme Zinck on 2019-12-01.
//  Copyright © 2019 Graeme Zinck. All rights reserved.
//

import SwiftUI

extension UIViewController {
    var topbarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0) + (self.navigationController?.navigationBar.frame.height ?? 0)
    }
    
    var tabbarHeight: CGFloat {
        return self.tabBarController?.tabBar.frame.height ?? 0
    }
}
