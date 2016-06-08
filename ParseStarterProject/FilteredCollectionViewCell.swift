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
    @IBOutlet weak var filterNameLabel: UILabel!
    
    var image: (UIImage, String)? {
        didSet {
            if let image = image {
                self.filteredImage.image = image.0
                self.filterNameLabel.text = image.1
            }
        }
    }
    
    
    class func identifier() -> String {
        return "FilteredCollectionViewCell"
    }
    
    
}
