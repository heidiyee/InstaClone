//
//  ParseService.swift
//  InstaClone
//
//  Created by Heidi Yee on 11/3/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class ParseService {
    
    class func uploadObjectToTestObject(image: UIImage, completion: (success: Bool, error: NSError?) -> Void ){
        
        if let imageData = UIImageJPEGRepresentation(image, 0.7) {
            
            let imageFile = PFFile(name: "image", data: imageData)
            let testObject = PFObject(className: "TestObject")
            testObject["foo"] = "two"
            testObject["image"] = imageFile
            testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                print("Object has been saved.")
                completion(success: success, error: error)
            }
        }
    }
}

