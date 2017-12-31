//
//  BackgroundViewController.swift
//  Muti-calendar
//
//  Created by Apple on 2017/12/26.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import CoreData


class BackgroundViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    @IBOutlet weak var BackgroundCollectionView: UICollectionView!
    
    var images: Array<UIImage> = []
    var ChosenImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BackgroundCollectionView.delegate = self
        BackgroundCollectionView.dataSource = self

        loadPhotos()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - Collection View
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10 + images.count
    }
    
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagePickerCell", for: indexPath) as! ImagePickerCollectionViewCell
            
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BackgroundCell", for: indexPath) as! BackgroundCollectionViewCell
            
            let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(cellLongPressed(recognizer:)))
            
            cell.addGestureRecognizer(gestureRecognizer)
            
        
            if indexPath.row < images.count+1 {
                cell.backgroundImageView.image = images[indexPath.row-1]
            }
            else {
                cell.backgroundImageView.image = UIImage(named: "BGI\(indexPath.row-images.count-1)")
            }
            
            return cell
        }
        
    }
    
    
    
    @objc func cellLongPressed(recognizer: UIGestureRecognizer) {
        if recognizer.state == UIGestureRecognizerState.began {
            
            let location = recognizer.location(in: self.BackgroundCollectionView)
            let indexPath = self.BackgroundCollectionView.indexPathForItem(at: location)!
            
            if indexPath.row > 0 && indexPath.row < images.count+1 {
                let alert = UIAlertController(title: "删除这个背景？", message: nil, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                let confirmAction = UIAlertAction(title: "确定", style: .destructive, handler: { (action) in
                    let cell = self.BackgroundCollectionView.cellForItem(at: indexPath) as! BackgroundCollectionViewCell
                    let image = cell.backgroundImageView.image
                    let index = self.images.index(of: image!)
                    self.images.remove(at: index!)
                    self.deleteAPhoto(selectedImage: image!)
                    
                    self.BackgroundCollectionView.reloadData()
                })
                
                alert.addAction(cancelAction)
                alert.addAction(confirmAction)
                self.present(alert, animated: true, completion: nil)
            }
            else {
                let alert = UIAlertController(title: "该背景不能删除", message: nil, preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                alert.addAction(confirmAction)
                self.present(alert, animated: true, completion: nil)
            }
  
        }
    }
    
    
    @IBAction func chooseImageFromLibrary(_ sender: UIButton) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    
    //MARK: - ImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        images.append(selectedImage)
        addAPhoto(selectedImage: selectedImage)
        
        
        self.BackgroundCollectionView.reloadData()
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        
    }
    
    func loadPhotos() {
        if !images.isEmpty {
            images.removeAll()
        }
        
        
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let container = appDel.persistentContainer
        let context = container.viewContext
        let fetch: NSFetchRequest<Bgimage> = Bgimage.fetchRequest()
        
        
        //fetch.predicate = NSPredicate(format: "??? == %@", NSNumber(value: curWeekday))
        do {
            let photoDatas = try context.fetch(fetch)
            
            for imageData in photoDatas {
                let temp = UIImage(data: imageData.photoData! as Data)
                images.append(temp!)
            }
            
        }catch let error {
            print("load error:\(error)")
        }
    }
    
    
    
    func addAPhoto(selectedImage: UIImage) {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let container = appDel.persistentContainer
        let context = container.viewContext
        let image = NSEntityDescription.insertNewObject(forEntityName: "Bgimage", into: context) as! Bgimage
        
        let imageData = UIImagePNGRepresentation(selectedImage)! as NSData
        image.photoData = imageData
     
        do {
            try context.save()
        }catch {
            print("save error at newcoursemanually")
        }
    }
    
    
    func deleteAPhoto(selectedImage: UIImage) {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let container = appDel.persistentContainer
        let context = container.viewContext
        let fetch: NSFetchRequest<Bgimage> = Bgimage.fetchRequest()
        
        let imageData = UIImagePNGRepresentation(selectedImage)! as NSData
        fetch.predicate = NSPredicate(format: "photoData == %@", imageData)
        
        do {
            let rsts = try context.fetch(fetch)
            for data in rsts {
                context.delete(data)
            }
        }catch {
            print("seek error at bg table")
        }
        do {
            try context.save()
        }catch {
            print("context can't save! at bg table")
        }
        
    }
    
  

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let des = segue.destination as! CalendarViewController
        let cell = sender as! BackgroundCollectionViewCell
        ChosenImage = cell.backgroundImageView.image
        des.backgroundImage.image = cell.backgroundImageView.image
        
        
        
    }


}
