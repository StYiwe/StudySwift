//
//  TwoVC.swift
//  StudySwiftDemo
//
//  Created by StYiWe on 2020/9/11.
//  Copyright © 2020 stYiwe. All rights reserved.
//

import UIKit

class TwoVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    
    

    var tableView = UITableView()
    
    //原始数据
    var dataList = [String]()
    //处理后的数据
    var resultDict = [String : [String]]()
    //组头标题数组
    var sectionTitle = [String]()
    
    //搜索
    var searchVc : UISearchController!
    //搜索的数据
    var searchDatas = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataList = ["阿狗", "阿毛", "兔子🐰", "鹰酱", "毛熊", "傻大木", "A", "BB", "狗大户", "He", "Dog", "big dog", "big yellow dog", "高卢🐔", "脚盆鸡", "秃子", "大毛", "二毛", "三毛", "$@"]
        
        
        self.tableView = UITableView.init(frame: UIScreen.main.bounds, style: .plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "TwoViewCell", bundle: nil), forCellReuseIdentifier: "cellID")
        self.view.addSubview(self.tableView)
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addDataAction))
        
        
        //UISearchController初始化
        searchVc = UISearchController.init(searchResultsController: nil)
        searchVc.searchResultsUpdater = self
        searchVc.searchBar.placeholder = "请输入名称进行搜索"
        searchVc.searchBar.searchBarStyle = .minimal//透明模式
        searchVc.obscuresBackgroundDuringPresentation = false
        
        tableView.tableHeaderView = (searchVc.searchBar)
        
        createResultDict()
    }
    
    //MARK: - 根据首字母进行分组
    func createResultDict() {
        for str in dataList {
            //获得首字母
            let FirstLetterIndex = str.index(str.startIndex, offsetBy: 1)
            print("首字母:\(FirstLetterIndex)")
            
            //字符串切到指定索引
            var keyStr = String(str[..<FirstLetterIndex])
            //转成大写字母
//            keyStr = firstLetterFromString(str: keyStr)
            keyStr = SwiftTools.init().firstLetterFromString(str: keyStr)
            print(keyStr)
            
            if var values = resultDict[keyStr] {
                values.append(str)
                resultDict[keyStr] = values
            } else {
                resultDict[keyStr] = [str]
            }
            print("分组后的数据：\(resultDict)")
            
            sectionTitle = [String](resultDict.keys)
            print("分组标题：\(sectionTitle)")
            sectionTitle = sectionTitle.sorted(by: {$0 < $1})
            print("分组标题：\(sectionTitle)")
        }
    }
    
    //MARK: - 将中文转为大写字母
    func firstLetterFromString(str: String) -> String {
        //转变成可变字符串
        let mutableString = NSMutableString.init(string: str)
        
        //将中文转变成带声调的拼音
        CFStringTransform(mutableString as CFMutableString, nil, kCFStringTransformToLatin, false)
        
        //去掉声调
        let pyStr = mutableString.folding(options: .diacriticInsensitive, locale: .current)
        print("pyStr:\(pyStr)")
        //将拼音首字母换成大写
        let PYStr = pyStr.uppercased()
        print("PYStr:\(PYStr)")
        //截取大写首字母
        let index = PYStr.index(PYStr.startIndex, offsetBy: 1)
        let firstStr = PYStr[..<index]
        print(firstStr)
        
        //判断首字母是否为大写
        let regexA = "^[A-Z]$"
        let predA = NSPredicate.init(format: "SELF MATCHES %@", regexA)
        
        return String(predA.evaluate(with: firstStr) ? firstStr : "#")
    }
    
    //MARK: - 搜索结果
    func updateSearchResults(for searchController: UISearchController) {
        //获取搜索栏文字,筛选后更新列表
        if var text = searchController.searchBar.text {
            //忽略前后空格
            text = text.trimmingCharacters(in: .whitespaces)
            print("搜索内容:\(text)")
            searchFilter(text: text)
            tableView.reloadData()
        }
    }
    
    //MARK: - 添加一个筛选器方法:使用Swift数组自带filter方法,返回一个符合条件的新数组
    func searchFilter(text: String) {
        searchDatas = dataList.filter({ (str) -> Bool in
            print("搜索结果：\(str.localizedCaseInsensitiveContains(text))")
            return str.localizedCaseInsensitiveContains(text)
        })
        print("searchDatas:\(searchDatas)")
    }
    
    
    //MARK: - 返回多少组
    func numberOfSections(in tableView: UITableView) -> Int {
        return searchVc.isActive ? 1 : sectionTitle.count
    }
    
    //MARK: - 返回多少行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let key = sectionTitle[section]
        guard let values = resultDict[key] else {
            return 0
        }
        
        return searchVc.isActive ? searchDatas.count : values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! TwoViewCell
        
        let key = sectionTitle[indexPath.section]
        let values = resultDict[key]
        
        
        cell.imgV.image = UIImage.init(named:"icon")
        cell.title.text = searchVc.isActive ? searchDatas[indexPath.row] : values?[indexPath.row]
        
        return cell
    }
    
    //MARK: - section的标题
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return searchVc.isActive ? "搜索结果" : sectionTitle[section]
    }
    
    
    //MARK: - 分割线从左端顶部显示(使cell的)分割线与屏幕的左右两端对齐显示
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = .zero
        }
        if cell.responds(to: #selector(setter: UITableViewCell.layoutMargins)) {
            cell.layoutMargins = .zero
        }
    }
    
    
    //MARK: - 设置行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //MARK: - 是否可编辑
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //MARK: - 设置编辑的类型 - 删除
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    //MARK: - 删除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.dataList.remove(at: indexPath.row)
        self.tableView.reloadData()
    }
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        var action1 : UITableViewRowAction
//        var action2 : UITableViewRowAction
//
//        action1 = UITableViewRowAction.init(style: .destructive, title: "删除", handler: { (action, index) in
//            //删除
////            self.tableView.deleteRows(at: [indexPath], with: .none)
//            self.dataList.remove(at: indexPath.row)
//            self.tableView.reloadData()
//        })
//
//        action2 = UITableViewRowAction.init(style: .normal, title: "增加", handler: { (action, index) in
////            self.tableView.insertRows(at: [indexPath], with: .none)
//        })
//
//        return [action1, action2]
//    }
    
    
    //MARK: - 右侧索引
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitle
    }
    
    
    
    //MARK: - 添加数据
    @objc func addDataAction() {
        print("添加数据")
        
        let alertC = UIAlertController.init(title: "添加数据", message: nil, preferredStyle: .alert)
        
        alertC.addTextField { (textField) in
//            textField.backgroundColor = .green
            textField.placeholder = "请输入内容"
        }
        
        alertC.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
            
            let text = (alertC.textFields?.first)!.text!
            print("输入内容:\(text)")
            
            if text.count > 0 {
                self.dataList.append(text)
                
                self.resultDict.removeAll()
                self.sectionTitle.removeAll()
                
                self.createResultDict()
                
                self.tableView.reloadData()
            }
            
        }))
        present(alertC, animated: true, completion: nil)
    }
    
    
}
