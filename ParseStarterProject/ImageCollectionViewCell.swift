//
//  ImageCollectionViewCell.swift
//  InstaClone
//
//  Created by Heidi Yee on 11/4/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var parseObject: PFObject? {
        didSet {
            if let parseObject = self.parseObject {
                let data = parseObject["image"] as! PFFile
                data.getDataInBackgroundWithBlock { (parseImage: NSData?, error) -> Void in
                    if let parseImage = parseImage {
                        let image = UIImage(data: parseImage)
                        self.imageView.image = image
                    }
                }
            }
        
        }
    }
    
    
    class func identifier() -> String {
        return "ImageCollectionViewCell"
    }
    
    
}
