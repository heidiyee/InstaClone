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
    
    class func uploadObjectToStatusClass(image: UIImage, completion: (success: Bool, error: NSError?) -> Void ){
        
        if let imageData = UIImageJPEGRepresentation(image, 0.7) {
            
            let imageFile = PFFile(name: "image", data: imageData)
            let status = PFObject(className: kClassName )
            status["description"] = "two"
            status["image"] = imageFile
            status.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                print("Object has been saved.")
                completion(success: success, error: error)
            }
        }
    }
    
    class func getParseData(className: String, completion: (array: [PFObject]?, error: NSError?) -> Void) {
        
        let parseQuery = PFQuery(className: className)
        parseQuery.findObjectsInBackgroundWithBlock { (parseObjects, error) -> Void in
            if let parseObjects = parseObjects {
                completion(array: parseObjects,error: nil)
            }
        }
        
    }
}

