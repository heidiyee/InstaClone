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
    
    var cellSize: CGFloat = 1.0 {
        didSet {
            self.collectionView.reloadData()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
//        let collectionViewBounds = CGRectGetWidth(UIScreen.mainScreen().bounds)
//        let galleryLayout = GridLayout()
//        galleryLayout.galleryFlowLayout(collectionViewBounds)
//        self.collectionView.collectionViewLayout = galleryLayout
//        cellSize = galleryLayout.getWidthSize()
        
        
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
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let collectionViewBounds = CGRectGetWidth(UIScreen.mainScreen().bounds)
        let numberColumns: CGFloat = 2.0
        let cellWidth = (collectionViewBounds / numberColumns) * cellSize
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    
    func scaleCollectionWhenPinched(sender: UIPinchGestureRecognizer) {
        print("Velocity is \(sender.velocity)")
        sender.scale = 0.1
        if sender.velocity > 0 {
            self.cellSize += sender.scale
        } else {
            if cellSize > 0.2 {
                self.cellSize -= sender.scale
            }
        }
        print(cellSize)
    }
    
    
}