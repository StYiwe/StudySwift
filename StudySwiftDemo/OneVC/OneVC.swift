//
//  OneVC.swift
//  StudySwiftDemo
//
//  Created by StYiWe on 2020/9/11.
//  Copyright © 2020 stYiwe. All rights reserved.
//

import UIKit

class OneVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
    }


    func netAction() {
        
        let url: NSURL = NSURL(string: "")!
        
        var request = URLRequest(url: url as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        
        request.httpMethod = "post"
//        request.httpBody
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            print(data as Any)
            print(response as Any)
            print(error as Any)
            
        }
        
        dataTask.resume()
    }
    
    
    
    

}
