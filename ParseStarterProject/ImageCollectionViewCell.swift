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
    
    var statusObject: Status? {
        didSet {
            if let statusObject = self.statusObject {
                self.imageView.image = statusObject.image
            }
        }
    }
    
    
    class func identifier() -> String {
        return "ImageCollectionViewCell"
    }
    
    
}
