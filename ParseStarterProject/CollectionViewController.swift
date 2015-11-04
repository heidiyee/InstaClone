//
//  CollectionViewController.swift
//  InstaClone
//
//  Created by Heidi Yee on 11/4/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var parseObjects = [PFObject]()
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.getParseObjects()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    class func identifier() -> String {
        return "CollectionViewController"
    }
    
    func setupView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        
    }
    
    func getParseObjects() {
        let parseQuery = PFQuery(className: kClassName)
        parseQuery.findObjectsInBackgroundWithBlock { (parseObjects, error) -> Void in
            if let parseObjects = parseObjects {
                self.parseObjects = parseObjects
                self.collectionView.reloadData()
                return
            }
            print("no objects")
        }

    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parseObjects.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCollectionViewCell", forIndexPath: indexPath) as! ImageCollectionViewCell
        let parseObject = self.parseObjects[indexPath.row]
        cell.parseObject = parseObject
        
        return cell
    }
    
    
}