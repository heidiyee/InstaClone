/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var uploadImageButton: UIButton!
    @IBOutlet weak var addFilterToImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addImageButtonSelected(sender: UIButton) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let cameraAlert = UIAlertController(title: "Select photo", message: "From...", preferredStyle: .ActionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) { (action) -> Void in
            
            print("Camera selected")
            //Camera action selected
            
            imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
            imagePickerController.allowsEditing = true
            self.presentViewController(imagePickerController, animated: true, completion: nil)
        }
        
        let libraryAction = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default) { (action) -> Void in
        
            print("Photo Library selected")
            //Photo Library action selected
            
            imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePickerController.allowsEditing = true
            self.presentViewController(imagePickerController, animated: true, completion: nil)
        }
        
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            cameraAction.enabled = false
        }
        else if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            libraryAction.enabled = false
        }
    
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        cameraAlert.addAction(cameraAction)
        cameraAlert.addAction(libraryAction)
        cameraAlert.addAction(cancelAction)
        
        self.presentViewController(cameraAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func uploadImageButton(sender: AnyObject) {
        
        if let image = self.imageView.image {
            ParseService.uploadObjectToTestObject(image)
        } else {
            print("No image")
        }
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismissViewControllerAnimated(true, completion: nil)

//        let imageResized = image
        let resizedImage = UIImage.resizeImage(image, size: CGSize(width: 600, height: 600))
    }
}
