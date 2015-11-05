//
//  Status.swift
//  InstaClone
//
//  Created by Heidi Yee on 11/3/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class Status {
    
    var image: UIImage!
    var statusDescription: String!

    init(image: UIImage?, statusDescription: String? = "Description") {
        self.image = image
        self.statusDescription = statusDescription
    }
    
}
