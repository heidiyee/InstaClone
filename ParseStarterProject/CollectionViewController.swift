//
//  CollectionViewController.swift
//  InstaClone
//
//  Created by Heidi Yee on 11/4/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

protocol CollectionViewControllerDelegate {
    func collectionViewSelectedStatus(status: Status)
}

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var statusObjects = [Status]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var width: CGFloat = 0.0

    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: CollectionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        let collectionViewWidth = CGRectGetWidth(self.collectionView.frame)
        self.width = (collectionViewWidth / 5)
        
//        let gestureTapRecognizer = UITapGestureRecognizer(target: self , action: Selector("cellSelected"))
//        collectionView.addGestureRecognizer(gestureTapRecognizer)
//        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(false)
        ParseService.getParseData(kClassName) { (array, error) -> Void in
            if let array = array {
                self.parseToStatus(array)
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.statusObjects = [Status]()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    class func identifier() -> String {
        return "CollectionViewController"
    }
    
    func parseToStatus(array: [PFObject]) {
            
            for object in array {
                let data = object["image"] as! PFFile
                
                data.getDataInBackgroundWithBlock { (parseImage: NSData?, error) -> Void in
                    if let parseImage = parseImage {
                        let image = UIImage(data: parseImage)
                        let status = Status(image: image)
                        
                        if NSThread.currentThread().isMainThread {
                            print("Main thread...")
                        }
                        
                        self.statusObjects.append(status)
                    }
                }
        }
        
        
    }
    
    func setupView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print(statusObjects.count)
        
        return statusObjects.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCollectionViewCell", forIndexPath: indexPath) as! ImageCollectionViewCell
        let statusObject = self.statusObjects[indexPath.row]
        cell.statusObject = statusObject
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(self.width, self.width)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("selected")
        if let delegate = self.delegate {
            delegate.collectionViewSelectedStatus(self.statusObjects[indexPath.row])
        }
    }
    
    
//    func cellSelected() {
//        print("yasss")
////        if let delegate = delegate {
////            delegate.collectionViewSelectedStatus()
////        }
//    }
    
    
}