//
//  NewDocumentViewController.swift
//  Muti-calendar
//
//  Created by Apple on 2017/12/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import WebKit
import CoreData

class NewDocumentViewController: UIViewController, UINavigationControllerDelegate, WKUIDelegate, WKNavigationDelegate, UITextFieldDelegate, URLSessionDownloadDelegate{
   

    @IBOutlet weak var urlText: UITextField!
    
    @IBOutlet weak var wkView: WKWebView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var goBackbutton: UIButton!
    @IBOutlet weak var goForwardButton: UIButton!
    @IBOutlet weak var goHomeButton: UIButton!
    @IBOutlet weak var refreshBUtton: UIButton!
    @IBOutlet weak var webImage: UIImageView!
    
    
    var barColorString: String!
    var normalColorString: String!
    
 
    //var refreshControl = UIRefreshControl()
    var curCourseName: String?
    var curDocName: String?
    var curTypeName: String?
    let homePage = "http://www.baidu.com"
    
    var curDownloadUrl: URL?
    
    lazy var downloadSession: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        wkView.uiDelegate = self
        wkView.navigationDelegate = self
        urlText.delegate = self
        indicator.hidesWhenStopped = true
        wkView.allowsBackForwardNavigationGestures = true
        
        
        /*
         refreshControl.addTarget(self, action:Selector("refresh") , for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "REFRESH")
        wkView.scrollView.addSubview(refreshControl)
       // refresh.backgroundColor = UIColor.red
       // wkView.addSubview(refresh)
         */
        
        let barColor = UIColor.colorWithHexString(hex: barColorString)
        let textColor = UIColor.colorWithHexString(hex: normalColorString)
        
        goBackbutton.setTitleColor(textColor, for: .normal)
        goBackbutton.backgroundColor = barColor
        goBackbutton.layer.cornerRadius = 15.0
        
        goForwardButton.setTitleColor(textColor, for: .normal)
        goForwardButton.backgroundColor = barColor
        goForwardButton.layer.cornerRadius = 15.0
        
        goHomeButton.setTitleColor(textColor, for: .normal)
        goHomeButton.backgroundColor = barColor
        goHomeButton.layer.cornerRadius = 15.0
        
        refreshBUtton.setTitleColor(textColor, for: .normal)
        refreshBUtton.backgroundColor = UIColor.white
        
        webImage.image = #imageLiteral(resourceName: "weblink").tintColor(color: textColor, blendMode: .destinationIn)
        
        
        self.wkView.load(URLRequest(url: URL(string: homePage)!))
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.indicator.startAnimating()
        print("START:\(String(describing: wkView.url))")
        
        if let urlString = self.wkView.url?.absoluteString {
            let urlArray = urlString.components(separatedBy: "/")
            print(urlArray)
            let reversedUrlArray = urlArray.reversed()
            var docname = ""
            for name in reversedUrlArray {
                if name != "" {
                    docname = name
                    break;
                }
            }
            if docname == "" {
                print("wrong docname")
                webView.stopLoading()
                return
            }
            print(docname)
            
            let docnameArray = docname.components(separatedBy: ".")
            let lastindex2 = docnameArray.endIndex - 1
            let typename = docnameArray[lastindex2]
            print(typename)
            
            
            
            let types = ["xls","xlsx","zip","rar","tar","gz","bz2","avi","mpeg","mpg","rmvb","mkv","flv","mp4","bt"]
            if types.contains(typename) {
                let alertController = UIAlertController(title: "是否下载这个文件？", message: nil, preferredStyle: .actionSheet)
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                let downloadAction = UIAlertAction(title: "下载", style: .default, handler: { (action) in
                    
                    self.curDownloadUrl = self.wkView.url
                    
                    let downloadTask = self.downloadSession.downloadTask(with: self.curDownloadUrl!)
                    downloadTask.resume()
                    
                    //let newLocation:String = NSHomeDirectory() + "/Documents/" + curDocName
                    self.curDocName = docname
                    self.curTypeName = typename
                    
                    let newLocation:String = "/Users/apple/Desktop/test/" + self.curDocName!
                    self.saveFile(location: newLocation)
                })
                
                alertController.addAction(cancelAction)
                alertController.addAction(downloadAction)
                self.present(alertController, animated: true, completion: nil)
                
                self.indicator.stopAnimating()
                self.wkView.stopLoading()
                
            }
        }
    
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.indicator.stopAnimating()
        //refreshControl.endRefreshing()
        //get dill with url
        urlText.text = wkView.url?.absoluteString
        //print(wkView.url)
    
    }
    
    /*
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("!!!!!!!!!!!!")
        load404Page()
        self.indicator.stopAnimating()
        
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("!!!!!!!!!!!")
        load404Page()
        self.indicator.stopAnimating()
    }
    */
    
    private func webGoBack() {
        if self.wkView.canGoBack {
            self.wkView.goBack()
        }
    }
    
    private func webGoForward() {
        if self.wkView.canGoForward {
            self.wkView.goForward()
        }
    }
    
    private func webGoHome() {
        self.wkView.load(URLRequest(url: URL(string: homePage)!))
        
    }
    
    
    private func load404Page() {
        /*
        let _404ImageView = UIImageView()
        _404ImageView.frame = self.wkView.frame
        _404ImageView.image = #imageLiteral(resourceName: "BGI6")
        self.view.addSubview(_404ImageView)
        */
        let file = Bundle.main.path(forResource: "page404", ofType: "jpg")
        let url = URL(fileURLWithPath: file!)
        self.wkView.load(URLRequest(url: url))
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if var urlString = self.urlText.text {
            print("url"+urlString)
            let first7 = urlString.prefix(7)
            let first8 = urlString.prefix(8)
            print(first7)
            print(first8)
            if !urlString.hasPrefix("http://") && !urlString.hasPrefix("https://") {
                urlString = "http://"
                + urlString
            }
            
            
            
            self.wkView.load(URLRequest(url: URL(string: urlString)!))
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    
    @IBAction func downloadAction(_ sender: UIBarButtonItem) {
        
        if let urlString = self.wkView.url?.absoluteString {
            let urlArray = urlString.components(separatedBy: "/")
            print(urlArray)
            let reversedUrlArray = urlArray.reversed()
            var docname = ""
            for name in reversedUrlArray {
                if name != "" {
                    docname = name
                    break;
                }
            }
            if docname == "" {
                print("wrong docname")
                
                let alert = UIAlertController(title: "文件错误", message: "下载失败", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "确定", style: .default, handler: nil)
                alert.addAction(confirmAction)
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            print(docname)
            
            let docnameArray = docname.components(separatedBy: ".")
            let lastindex2 = docnameArray.endIndex - 1
            let typename = docnameArray[lastindex2]
            print(typename)
            
            curDocName = docname
            curTypeName = typename
            //dowload url and change path
            
            curDownloadUrl = self.wkView.url!
            let downloadTask = downloadSession.downloadTask(with: curDownloadUrl!)
            downloadTask.resume()
            
            //let newLocation:String = NSHomeDirectory() + "/Documents/" + curDocName!
            let newLocation:String = "/Users/apple/Desktop/test/" + curDocName!
            saveFile(location: newLocation)
        }
        
    }
    

    @IBAction func goBack(_ sender: UIButton) {
        webGoBack()
    }
    
    @IBAction func goForward(_ sender: UIButton) {
        webGoForward()
    }
    
    @IBAction func goHome(_ sender: UIButton) {
        webGoHome()
    }
    
    @IBAction func webRefresh(_ sender: UIButton) {
        
        self.wkView.reload()
    }
    
    
    //Download by urlsession
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        print("download succ")
        print("ori loc:\(location)")
        let oriLocation = location.path
        //let newLocation:String = NSHomeDirectory() + "/Documents/" + curDocName!
        let newLocation:String = "/Users/apple/Desktop/test/" + curDocName!
        let fileManager = FileManager.default
        do {
            try fileManager.copyItem(atPath: oriLocation, toPath: newLocation)
            print("new file loc:\(newLocation)")
        }catch {
            print("copy file fail")
        }
        
    }
    
    
    private func saveFile(location: String) {
        
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let container = appDel.persistentContainer
        let context = container.viewContext
        
        let fetch: NSFetchRequest<Document> = Document.fetchRequest()
        fetch.predicate = NSPredicate(format: "docPath == %@", location)
        do {
            let rsts = try context.fetch(fetch)
            if rsts.isEmpty {
                let document = NSEntityDescription.insertNewObject(forEntityName: "Document", into: context) as! Document
                document.courseName = curCourseName ?? "???"
                document.docName = curDocName
                document.docPath = location
                document.docType = curTypeName
            }
        }catch {
            print("seek error at new doc")
        }
  
        do {
            try context.save()
        }catch {
            print("save error at newdocument")
        }
    }
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        //print("!!")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        //offset
    }
    
    
    
    // MARK: - Navigation

    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        let isPresentingInAddDocumentMode = presentingViewController is UINavigationController
        
        if isPresentingInAddDocumentMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The NewDocumentViewController is not inside a navigation controller.")
        }
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
