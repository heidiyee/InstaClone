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
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: CollectionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        let collectionViewBounds = CGRectGetWidth(UIScreen.mainScreen().bounds)
        let galleryLayout = GridLayout()
        galleryLayout.galleryFlowLayout(collectionViewBounds)
        self.collectionView.collectionViewLayout = galleryLayout
        
        
        let gesturePinchRecognizer = UIPinchGestureRecognizer(target: self , action: Selector("scaleCollectionWhenPinched:"))
        collectionView.addGestureRecognizer(gesturePinchRecognizer)

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
        return statusObjects.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCollectionViewCell", forIndexPath: indexPath) as! ImageCollectionViewCell
        let statusObject = self.statusObjects[indexPath.row]
        cell.statusObject = statusObject
        
        
        return cell
    }

    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("selected")
        if let delegate = self.delegate {
            delegate.collectionViewSelectedStatus(self.statusObjects[indexPath.row])
        }
    }
    
    
    func scaleCollectionWhenPinched(sender: UIPinchGestureRecognizer) {
//        sender.view!.transform = CGAffineTransformScale(sender.view!.transform, sender.scale, sender.scale)
        
        print(sender.velocity)
        //print(sender.scale)
        
        //sender.scale = 10.0
        //cellSize += sender.scale
        //self.collectionView.reloadData()
        
        

        
    }
    
    
}