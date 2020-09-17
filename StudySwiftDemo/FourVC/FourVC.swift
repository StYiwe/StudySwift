//
//  FourVC.swift
//  StudySwiftDemo
//
//  Created by StYiWe on 2020/9/11.
//  Copyright © 2020 stYiwe. All rights reserved.
//

import UIKit

class FourVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    var dataList = [String]()
    
    var tableV = UITableView()
    //选择照片
    var trackPickerC: UIImagePickerController!
    //头像
    var iconImgV: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        
        self.dataList = ["收藏", "相册", "扫描", "二维码", "设置"]
        
        self.tableV = UITableView.init(frame: UIScreen.main.bounds, style: .plain)
        self.view.addSubview(self.tableV)
        self.tableV.delegate = self
        self.tableV.dataSource = self
        
        self.tableV.register(UINib(nibName: "FourTableViewCell", bundle: nil), forCellReuseIdentifier: "cellID")
        
        //表头
        let topV = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 250))
        topV.backgroundColor = .green
        
        //头像
        self.iconImgV = UIImageView.init(frame: CGRect(x: (UIScreen.main.bounds.size.width - 80)/2, y: (250 - 80)/2, width: 80, height: 80))
        //裁圆
        self.iconImgV.layer.cornerRadius = 40
        self.iconImgV.layer.masksToBounds = true
        self.iconImgV.image = UIImage.init(named: "icon")
        topV.addSubview(self.iconImgV)
        self.tableV.tableHeaderView = topV
        
        self.tableV.reloadData()
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! FourTableViewCell
        //设置选中样式
        cell.selectionStyle = .gray
        cell.titleLabel.text = self.dataList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("点击了\(self.dataList[indexPath.row])")
        
        switch indexPath.row {
        case 0:
            //收藏
            
            break
        case 1:
            //相册
            alertVAction()
            break
        case 2:
            //扫描
            let scanVc = ScanQRVC.init()
            //隐藏tabbar
            scanVc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(scanVc, animated: false)
            
            break
        case 3:
            //二维码
            let qrCodeVc = QRCodeVC.init()
            //隐藏tabbar
            qrCodeVc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(qrCodeVc, animated: false)
            
            break
        case 4:
            //设置
            
            break
        default:
            break
        }
    }
    
    //MARK: - 相册
    func alertVAction() {
        print("弹框选择方式")
        
        let sheetC = UIAlertController()
        
        let cancleAction = UIAlertAction(title: "取消", style: .cancel) { (UIAlertAction) in
            print("取消")
        }
        
        let tackingPictureAction = UIAlertAction(title: "拍照", style: .destructive) { (UIAlertAction) in
            print("拍照")
            self.getImage(type: 1)
        }
        
        let photoAlbumAction = UIAlertAction(title: "相册", style: .destructive) { (UIAlertAction) in
            print("相册")
            self.getImage(type: 2)
        }
        
        sheetC.addAction(cancleAction)
        sheetC.addAction(tackingPictureAction)
        sheetC.addAction(photoAlbumAction)
        
        //显示
        self.present(sheetC, animated: true, completion: nil)
    }
    
    func getImage(type: Int) {
        trackPickerC = UIImagePickerController.init()
        if type == 1 {
            //拍照
            trackPickerC.sourceType = .camera
            //拍照是否显示工具栏
//            trackPickerC.showsCameraControls = true
        } else if type == 2 {
            //相册
            trackPickerC.sourceType = .photoLibrary
        }
        //是否截取，设置为true在获取图片后可以将其截取成正方形
        trackPickerC.allowsEditing = false
        trackPickerC.delegate = self
        present(trackPickerC, animated: true, completion: nil)
        
    }
    
    //拍照或是相册选择返回的图片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if picker.allowsEditing == false {
            self.iconImgV.image = info[.originalImage] as? UIImage
        } else {
            self.iconImgV.image = info[.editedImage] as? UIImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    

}
