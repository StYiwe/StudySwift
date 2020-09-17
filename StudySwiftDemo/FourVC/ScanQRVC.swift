//
//  ScanQRVC.swift
//  StudySwiftDemo
//
//  Created by StYiWe on 2020/9/12.
//  Copyright © 2020 stYiwe. All rights reserved.
//

import UIKit
import AVFoundation

class ScanQRVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    //MARK: - 懒加载输入输出中间会话
    lazy var session: AVCaptureSession = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //UI
        photoAlbumUIAction()
        
        //扫描
        addScaningVideo()
        
    }
    
    //相册UI
    func photoAlbumUIAction() {
        
        let imgBtn = UIButton.init(type: .custom)
        imgBtn.frame = CGRect(x: UIScreen.main.bounds.size.width - 60, y: UIScreen.main.bounds.size.height - 100, width: 30, height: 30)
        imgBtn.setBackgroundImage(UIImage.init(named: "icon_xiangce"), for: .normal)
        imgBtn.addTarget(self, action: #selector(goPhotoAlbumAction), for: .touchUpInside)
        self.view.addSubview(imgBtn)
    }
    
    
    //MARK: - 初始化扫描设备
    func addScaningVideo() {
        //1.获取输入设备（摄像头）
        guard let device = AVCaptureDevice.default(for: .video) else {
            print("不支持摄像头")
            return
        }
        
        //2.根据输入设备创建输入对象
        guard let deviceInput = try? AVCaptureDeviceInput(device: device) else {
            print("不支持摄像头")
            return
        }
        
        //3.创建源数据的输出对象
        let metadataOutput = AVCaptureMetadataOutput()
        
        //4.设置代理监听输出对象输出的数据，在主线程中刷新
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        //5.创建会话（桥梁）
//        let session = AVCaptureSession()
        
        //采集质量
        session.canSetSessionPreset(.high)
        
        //6.添加输入和输出到会话
        if session.canAddInput(deviceInput) {
            session.addInput(deviceInput)
        }
        
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
        }
        
        //7.告诉输出对象要输出什么样的数据（二维码还是条形码），要先创建会话才能设置
        metadataOutput.metadataObjectTypes = [.qr, .code128, .code39, .code93, .code39Mod43, .ean8, .ean13, .upce, .pdf417, .aztec]
        
        //8.创建预览图层
        let previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.insertSublayer(previewLayer, at: 0)
        
        //9.设置有效扫描区域（默认整个屏幕区域）(每个取值0~1，以屏幕右上角为坐标原点)
//        let rect = CGRect(x: <#T##CGFloat#>, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
//        metadataOutput.rectOfInterest = rect
        
        //10.开始扫描
        session.startRunning()
        
    }
    
    //MARK: - 实现代理 需要将扫描的结果转化成机器可读的编码数据,才能获取二维码的相关信息
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        //1.取出扫描到的数据，metadataObjects
        //2.以振动的形式告知用户扫描成功
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        //3.关闭session
        session.stopRunning()
        
        //4.遍历结果
        var resultArr = [String]()
        for result in metadataObjects {
            //转换成机器可读的编码数据
            if let code = result as? AVMetadataMachineReadableCodeObject {
                resultArr.append(code.stringValue ?? "")
            } else {
                resultArr.append(result.type.rawValue)
            }
            
        }
        
        //5.处理结果
        print("扫描结果:\(resultArr)")
        alertShow(resultArr.first)
    }
    
    
    //MARK: - 去相册选择相片
    @objc func goPhotoAlbumAction() {
        
        //关闭扫描
        session.stopRunning()
        
        let imgPickerC = UIImagePickerController()
        imgPickerC.sourceType = .photoLibrary
        imgPickerC.allowsEditing = false
        imgPickerC.delegate = self
        present(imgPickerC, animated: true, completion: nil)
    }
    
    //MARK: - 相册代理
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        session.startRunning()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        let img = info[.originalImage] as? UIImage
        
        //识别二维码
        recognitionQRCode(qrCodeImage: img!)
    }

    //MARK: - 识别图片中的二维码
    func recognitionQRCode(qrCodeImage: UIImage) -> [String]? {
        //1.创建过滤器,CIDetectorAccuracyHigh设置识别精度为High
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        
        //2.获取CIImage
        guard let ciImage = CIImage(image: qrCodeImage) else {
            return nil
        }
        
        //3.识别二维码
        guard let features = detector?.features(in: ciImage) else {
            return nil
        }
        
        //以振动的形式告知用户识别成功
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        //4.遍历数组，获取信息
        var resultArr = [String]()
        
        for feature in features {
            
            if let qrFeature = feature as? CIQRCodeFeature {
                resultArr.append(qrFeature.messageString!)
            }
            
        }
        print("识别二维码：\(resultArr)")
        
        //弹框提示
        alertShow(resultArr.first)
        
        return resultArr
    }
    
    //MARK: - 弹框提示
    func alertShow(_ alertStr: String?) {
        
        let alertC = UIAlertController.init(title: "扫描结果", message: alertStr, preferredStyle: .alert)
        alertC.addAction(UIAlertAction.init(title: "确定", style: .cancel, handler: { (action) in
            self.session.startRunning()
        }))
        present(alertC, animated: true, completion: nil)
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //设置导航栏透明
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    
}
