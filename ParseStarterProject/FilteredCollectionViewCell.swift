//
//  FilteredCollectionViewCell.swift
//  InstaClone
//
//  Created by Heidi Yee on 11/6/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class FilteredCollectionViewCell: UICollectionViewCell  {
    
    @IBOutlet weak var filteredImage: UIImageView!
    var image: UIImage? {
        didSet {
            if let image = image {
                self.filteredImage.image = image
            }
        }
    }
    
    
    class func identifier() -> String {
        return "FilteredCollectionViewCell"
    }
    
    
}
