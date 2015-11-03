//
//  FilterService.swift
//  InstaClone
//
//  Created by Heidi Yee on 11/3/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class FilterService {
    
    private class func setupFilter(filterName: String, parameters: [String: AnyObject]?, image: UIImage) -> UIImage? {
        
        let image = CIImage(image: image)
        let filter: CIFilter
        
        if let parameters = parameters {
            filter = CIFilter(name: filterName, withInputParameters: parameters)!
        } else {
            filter = CIFilter(name: filterName)!
        }
        filter.setValue(image, forKey: kCIInputImageKey)
        
        let options = [kCIContextWorkingColorSpace : NSNull()]
        let eaglContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
        let gpuContext = CIContext(EAGLContext: eaglContext, options: options)
        
        let outputImage = filter.outputImage
        let extent = outputImage!.extent
        let cgImage = gpuContext.createCGImage(outputImage!, fromRect: extent)
        
        let finalImage = UIImage(CGImage: cgImage)
        return finalImage
    }
    
    class func applyVintageEffect(image: UIImage, completion: (filteredImage: UIImage?, name: String) -> Void) {
        
        let filterName = Constants.Filters.kVintageFilter
        let displayName = Constants.Filters.kVintageEffectTitle
        
        let finalImage = self.setupFilter(filterName, parameters: nil, image: image)
        
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            completion(filteredImage: finalImage, name: displayName)
        }
    }
    
    class func applyBWEffect(image: UIImage, completion: (filteredImage: UIImage?, name: String) -> Void) {
        
        let filterName = "CIPhotoEffectMono"
        let displayName = "Black and White"
        
        let finalImage = self.setupFilter(filterName, parameters: nil, image: image)
        
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            completion(filteredImage: finalImage, name: displayName)
        }
    }
    
    class func applyChromeEffect(image: UIImage, completion: (filteredImage: UIImage?, name: String) -> Void) {
        
        let filterName = "CIPhotoEffectChrome"
        let displayName = "Chrome"
        
        let finalImage = self.setupFilter(filterName, parameters: nil, image: image)
        
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            completion(filteredImage: finalImage, name: displayName)
        }
    }
}
