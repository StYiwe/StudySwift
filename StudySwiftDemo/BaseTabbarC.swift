//
//  BaseTabbarC.swift
//  StudySwiftDemo
//
//  Created by StYiWe on 2020/9/11.
//  Copyright © 2020 stYiwe. All rights reserved.
//

import UIKit

class BaseTabbarC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //设置选中字体颜色
        UITabBar.appearance().tintColor = .red
        
        // Do any additional setup after loading the view.
        addTabbarC()
    }
    
    func addTabbarC() {
        initChildrenVC(OneVC.init(), title: "一", img: "", selImg: "")
        initChildrenVC(TwoVC.init(), title: "二", img: "", selImg: "")
        initChildrenVC(ThreeVC.init(), title: "三", img: "", selImg: "")
        initChildrenVC(FourVC.init(), title: "四", img: "", selImg: "")
    }

    
    //MARK: - 初始化子控制器
    func initChildrenVC(_ childrenVC: UIViewController, title: String, img: String, selImg: String) {
        //设置tabbar默认图片
        var nomalImg = UIImage.init(named: img)
        nomalImg = nomalImg?.withRenderingMode(.alwaysOriginal)
        childrenVC.tabBarItem.image = nomalImg
        
        //设置tabbar选中图片
        var selectImg = UIImage.init(named: selImg)
        selectImg = selectImg?.withRenderingMode(.alwaysOriginal)
        childrenVC.tabBarItem.selectedImage = selectImg
        
        //设置导航栏标题、tabbar文本
        childrenVC.navigationItem.title = title
        childrenVC.title = title
        
        //添加导航栏
        let navC = UINavigationController.init(rootViewController: childrenVC)
        addChild(navC)
        
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
