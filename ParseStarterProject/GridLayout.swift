//
//  GridLayout.swift
//  InstaClone
//
//  Created by Heidi Yee on 11/4/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class GridLayout: UICollectionViewFlowLayout {
    
    var cellSize: CGFloat!
    
    override init() {
        super.init()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func galleryFlowLayout(viewWidth: CGFloat) {
        
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 0
        let numberColumns: CGFloat = 2.0
        let cellWidth = (viewWidth - self.minimumInteritemSpacing) / numberColumns
        self.itemSize = CGSize(width: cellWidth, height: cellWidth)
        print(viewWidth)
        print(cellWidth)
        self.cellSize = cellWidth
    
    }
    
    func getWidthSize() -> CGFloat {
        return cellSize
    }

    func thumbnailsFlowLayout(viewWidth: CGFloat, viewHeight: CGFloat) {
        
        //self.minimumInteritemSpacing = 1.0
        self.minimumLineSpacing = 2.0
        //let numberColumns: CGFloat = 2.0
        let cellWidth = viewHeight - self.minimumLineSpacing
        self.itemSize = CGSize(width: cellWidth, height: cellWidth)
        self.scrollDirection = UICollectionViewScrollDirection.Horizontal
        print("Cell Width \(cellWidth)")

    }
}
