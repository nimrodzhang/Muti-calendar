//
//  ReadDocumentViewController.swift
//  Muti-calendar
//
//  Created by Apple on 2017/12/22.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import WebKit
import SSZipArchive
import QuickLook
import AVKit

class ReadDocumentViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, QLPreviewControllerDelegate, QLPreviewControllerDataSource {

    @IBOutlet weak var DocumentTitle: UINavigationItem!
    
    var alert: UIAlertController?
    var quickLookView = QLPreviewController()
    //var wkView: WKWebView!
    
    
    var docName:String?
    var docPath:String?
    var docType:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        
        DocumentTitle.title = docName
        let fileManager = FileManager.default
        let isFilepath = docPath
        
        let qlOpenTypes = ["xls","xlsx","doc","docx","ppt","pptx","pdf","txt","htm","html"]
        let plyOpenTypes = ["avi","mpeg","mpg","rmvb","mkv","flv","mp4","mp3","wav","flac"]
        print("doc type:\(docType!)")
        
        if fileManager.fileExists(atPath: isFilepath!) {
            if docType == "zip" {

                //let desPath:String = NSHomeDirectory() + "/Documents/"
                let desPath:String = "/Users/apple/Desktop/test/"
                do {
                    try SSZipArchive.unzipFile(atPath: docPath!, toDestination: desPath, overwrite: true, password: nil)
                }catch let error {
                    print("unzip failed: \(error)")
                }
                
                alert = UIAlertController(title: "解压完成", message: nil, preferredStyle: .alert)
                
                
                Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(readDismiss), userInfo: nil, repeats: false)
                
                self.present(alert!, animated: true, completion: nil)

            }
            else if qlOpenTypes.contains(docType!) {
                print("enter quicklook")
                quickLookView.delegate = self
                quickLookView.dataSource = self
                let rect = CGRect(x: 0, y: 70, width: self.view.frame.width, height: self.view.frame.height-70)
                
                quickLookView.view.frame = rect
                quickLookView.currentPreviewItemIndex = 0
                self.addChildViewController(quickLookView)
                self.view.addSubview(quickLookView.view)
                //self.present(quickLookView, animated: true, completion: nil)
            }
            else if plyOpenTypes.contains(docType!) {
                let videoURL = URL.init(fileURLWithPath: docPath!, isDirectory: false)
                let player = AVPlayer(url: videoURL)
                let playerLayer = AVPlayerLayer(player: player)
                playerLayer.frame = self.view.bounds
                self.view.layer.addSublayer(playerLayer)
                player.play()
            }
            else {
                let config = WKWebViewConfiguration()
                let wkView = WKWebView(frame: self.view.frame, configuration: config)
                
                wkView.uiDelegate = self
                wkView.navigationDelegate = self
                
                self.view.addSubview(wkView)
                
                
                DocumentTitle.title = docName
                let fileurl = URL.init(fileURLWithPath: docPath!, isDirectory: false)
                let request = URLRequest(url: fileurl)
                wkView.load(request)
            }
            
        }
        else {
            alert = UIAlertController(title: "文件不存在", message: nil, preferredStyle: .alert)

            let confirmAction = UIAlertAction(title: "确定", style: .default, handler: { (action) in
                let isPresentingInReadCourseMode = self.presentingViewController is UINavigationController
                
                if isPresentingInReadCourseMode {
                    self.dismiss(animated: true, completion: nil)
                }
                else if let owningNavigationController = self.navigationController{
                    owningNavigationController.popViewController(animated: true)
                }
                else {
                    fatalError("The ReadDocumentViewController is not inside a navigation controller.")
                }
                
            })
            alert?.addAction(confirmAction)
            self.present(alert!, animated: true, completion: nil)
        }
        
        
        
    }

    @objc private func readDismiss() {
        
        alert?.dismiss(animated: true, completion: nil)
        
        let isPresentingInReadCourseMode = self.presentingViewController is UINavigationController
        
        if isPresentingInReadCourseMode {
            self.dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = self.navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The ReadDocumentViewController is not inside a navigation controller.")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        print("qlitem")
        let url = URL(fileURLWithPath: docPath!)
        return url as QLPreviewItem
    }
    
    /*
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("!!!!!!!!!!!!")
        
        printAlert()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("!!!!!!!!!!!")
       
        printAlert()
    }
    */
    private func printAlert() {
        /*
        let alert = UIAlertController(title: "打开失败", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "确定", style: .cancel) { (action) in
            
        }
        
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
        */
        
        alert = UIAlertController(title: "打开失败", message: "文件类型不合法", preferredStyle: .alert)
        
        
        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(readDismiss), userInfo: nil, repeats: false)
        
        self.present(alert!, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
