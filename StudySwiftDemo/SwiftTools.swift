//
//  SwiftTools.swift
//  StudySwiftDemo
//
//  Created by StYiWe on 2020/9/14.
//  Copyright © 2020 stYiwe. All rights reserved.
//

import UIKit

class SwiftTools: NSObject {

    //MARK: - 将中文转成大写字母（主要用于tableview的索引列表）
    func firstLetterFromString(str: String) -> String {
        //转变成可变字符串
        let mutableStr = NSMutableString.init(string: str)
        
        //将中文转变成带声调的拼音
        CFStringTransform(mutableStr as CFMutableString, nil, kCFStringTransformToLatin, false)
        
        //去掉声调
        let pyStr = mutableStr.folding(options: .diacriticInsensitive, locale: .current)
        
        //将拼音转成大写字母
        let PYStr = pyStr.uppercased()
        
        //截取大写首字母
        let index = PYStr.index(PYStr.startIndex, offsetBy: 1)
        let firstStr = PYStr[..<index]
        
        //判断是否为大写字母，是就返回，不是就用"#"代替
        let uppercaseLetter = "^[A-Z]$"
        let predicateLetter = NSPredicate.init(format: "SELF MATCHES %@", uppercaseLetter)
        
        return String(predicateLetter.evaluate(with: firstStr) ? firstStr : "#")
    }
    
    
    
    //MARK: - 在数组中筛选符合条件的数据。添加一个筛选器方法：使用swift数组自带的filter方法，返回一个符合条件的新数组
    
    /// 在数组中筛选符合条件的内容，主要用于本地搜索数据
    /// - Parameters:
    ///   - text: 筛选的内容
    ///   - dataList: 进行筛选的数组
    /// - Returns: 返回符合条件的新数组
    func searchFilter(text: String, dataList: [String]) -> [String] {
        var resultArr = [String]()
        
        resultArr = dataList.filter({ (str) -> Bool in
            return str.localizedCaseInsensitiveContains(text)
        })
        
        return resultArr
    }
    
    
    
    
    
    
    
    
}
