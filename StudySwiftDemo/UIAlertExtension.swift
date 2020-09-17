//
//  UIAlertExtension.swift
//  StudySwiftDemo
//
//  Created by StYiWe on 2020/9/17.
//  Copyright © 2020 stYiwe. All rights reserved.
//

import Foundation
import UIKit


extension UIAlertController {
    
    static func showAlert(message: String, in viewController: UIViewController) {
        let alertC = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertC.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
        viewController.present(alertC, animated: true, completion: nil)
    }
    
    static func showConfirm(message: String, viewController: UIViewController, comfirm: ((UIAlertAction)->Void)?) {
        let alertC = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alertC.addAction(UIAlertAction(title: "确定", style: .default, handler: comfirm))
        viewController.present(alertC, animated: true, completion: nil)
        
    }
    
}
