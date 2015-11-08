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
        
        let filterName = kVintageFilter
        let displayName = kVintageEffectTitle
        
        let finalImage = self.setupFilter(filterName, parameters: nil, image: image)
        
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            completion(filteredImage: finalImage, name: displayName)
        }
    }
    
    class func applyBWEffect(image: UIImage, completion: (filteredImage: UIImage?, name: String) -> Void) {
        
        let filterName = kBWFilter
        let displayName = kBWEffectTitle
        
        let finalImage = self.setupFilter(filterName, parameters: nil, image: image)
        
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            completion(filteredImage: finalImage, name: displayName)
        }
    }
    
    class func applyChromeEffect(image: UIImage, completion: (filteredImage: UIImage?, name: String) -> Void) {
        
        let filterName = kChromeFilter
        let displayName = kChromeEffectTitle
        
        let finalImage = self.setupFilter(filterName, parameters: nil, image: image)
        
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            completion(filteredImage: finalImage, name: displayName)
        }
    }
    
    class func applyMonochromeEffect(image: UIImage, completion: (filteredImage: UIImage?, name: String) -> Void) {
        
        let filterName = "CIColorMonochrome"
        let displayName = "Monochrome"
        
        let finalImage = self.setupFilter(filterName, parameters: nil, image: image)
        
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            completion(filteredImage: finalImage, name: displayName)
        }
    }
    
    class func applyInstantEffect(image: UIImage, completion: (filteredImage: UIImage?, name: String) -> Void){
        
        let filterName = "CIPhotoEffectInstant"
        let displayName = "Instant"
        
        let finalImage = self.setupFilter(filterName, parameters: nil, image: image)
        
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            completion(filteredImage: finalImage, name: displayName)
        }
    }
}
