//
//  TabBarController.swift
//  GuitSet
//
//  Created by Graeme Zinck on 2019-12-05.
//  Copyright © 2019 Graeme Zinck. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
