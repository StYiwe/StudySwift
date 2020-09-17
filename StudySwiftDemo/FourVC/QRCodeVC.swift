//
//  QRCodeVC.swift
//  StudySwiftDemo
//
//  Created by StYiWe on 2020/9/11.
//  Copyright © 2020 stYiwe. All rights reserved.
//

import UIKit
import Photos

class QRCodeVC: UIViewController {

    
    var qrImgV = UIImageView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "二维码"
        
        /**
            方法使用#selector的形式，实现方法的时候需要在func前面加@objc
         */
        //导航栏右侧按钮
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保存", style: .plain, target: self, action: #selector(saveImageToPhotoLibrary))
        

        qrImgV = UIImageView.init(frame: CGRect(x: (UIScreen.main.bounds.size.width - 300)/2, y: (UIScreen.main.bounds.size.height - 300)/2, width: 300, height: 300))
        qrImgV.backgroundColor = .gray
        self.view.addSubview(qrImgV)
        
        
        //url
        let url = "https://www.jianshu.com/p/357c6477edf2"
        
        //头像
        let iconImage = UIImage.init(named: "icon")
        
        
        qrImgV.image = setupQRCodeImage(url, iconImage)
        
    }
    
    //MARK: - 保存图片前判断权限
    @objc func saveImageToPhotoLibrary() {
        print("保存图片")
        
        //判断图片是否为空
        guard self.qrImgV.image != nil else {
            return
        }
        
        //使用UIImageWriteToSavedPhotosAlbum，使用简单
//        UIImageWriteToSavedPhotosAlbum(self.qrImgV.image!, nil, nil, nil)
        
        
        //判断权限
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized://已授权，保存图片
            saveImage(image: self.qrImgV.image!)
        case .notDetermined://请求权限
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized {//授权
                    self.saveImage(image: self.qrImgV.image!)
                } else {//不同意授权
                    print("不同意授权")
                }
            }
        case .restricted, .denied://已拒绝，跳转设置进行设置（注：设置完返回，此时APP会重启）
            if let url = URL.init(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        default: break

        }
    }
    
    //MARK: - 保存图片
    func saveImage(image: UIImage) {
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { (isSuccess, error) in
            
            DispatchQueue.main.async {
                if isSuccess {//保存成功
                    print("保存成功")
                } else {
                    print("保存失败,\(String(describing: error?.localizedDescription))")
                }
            }
        }
        
    }
    
    
    
    //MARK: - 传进去字符串，生成二维码图片
    func setupQRCodeImage(_ text: String, _ image: UIImage?) -> UIImage {
        //创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        //将url加入二维码
        filter?.setValue(text.data(using: String.Encoding.utf8), forKey: "inputMessage")
        //取出生成的二维码(不清晰)
        if let outputImage = filter?.outputImage {
            //生成清晰度更好的二维码
            let qrCodeImage = setupHighDefinitionUIImage(outputImage, size: 300)
            //如果有一个头像的话，将头像加入二维码中心
            if var image = image {
                //给头像加一个白色圆边（如果没有这个需求直接忽略）
                image = circleImageWithImage(image, borderWidth: 50, borderColor: .white)
                //合成图片
                let newImage = syntheticImage(qrCodeImage, iconImage: image, width: 100, height: 100)
                
                return newImage
            }
            
            return qrCodeImage
        }
        
        return UIImage()
    }
    
    //MARK: - 生成高清的二维码
    func setupHighDefinitionUIImage(_ image: CIImage, size: CGFloat) -> UIImage {
        
        let integral: CGRect = image.extent.integral
        let proportion: CGFloat = min(size/integral.width, size/integral.height)
        
        let width = integral.width * proportion
        let height = integral.height * proportion
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(image, from: integral)!
        
        bitmapRef.interpolationQuality = CGInterpolationQuality.none
        bitmapRef.scaleBy(x: proportion, y: proportion)
        bitmapRef.draw(bitmapImage, in: integral)
        
        let image: CGImage = bitmapRef.makeImage()!
        return UIImage(cgImage: image)
        
    }
    
    //MARK: - 合成图片
    func syntheticImage(_ image: UIImage, iconImage: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
        //开启图片上下文
        UIGraphicsBeginImageContext(image.size)
        //绘制背景图片
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let x = (image.size.width - width) * 0.5
        let y = (image.size.height - height) * 0.5
        
        iconImage.draw(in: CGRect(x: x, y: y, width: width, height: height))
        //取出绘制好的图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        //关闭上下文
        UIGraphicsEndImageContext()
        
        //返回合成好的图片
        if let newImage = newImage {
            return newImage
        }
        
        return UIImage()
    }
    
    
    //MARK: - 生成边框
    func circleImageWithImage(_ sourceImage: UIImage, borderWidth: CGFloat, borderColor: UIColor) -> UIImage {
        let imageWidth = sourceImage.size.width + 2 * borderWidth
        let imageHeight = sourceImage.size.height + 2 * borderWidth
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: imageWidth, height: imageHeight), false, 0.0)
        UIGraphicsGetCurrentContext()
        
        let radius = (sourceImage.size.width < sourceImage.size.height ? sourceImage.size.width : sourceImage.size.height) * 0.5
        let bezierPath = UIBezierPath(arcCenter: CGPoint(x: imageWidth * 0.5, y: imageHeight * 0.5), radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        bezierPath.lineWidth = borderWidth
        borderColor.setStroke()
        bezierPath.stroke()
        bezierPath.addClip()
        sourceImage.draw(in: CGRect(x: borderWidth, y: borderWidth, width: sourceImage.size.width, height: sourceImage.size.height))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
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
