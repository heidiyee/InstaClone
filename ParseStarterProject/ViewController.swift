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

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CollectionViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var uploadImageButton: UIButton!
    @IBOutlet weak var addFilterToImageButton: UIButton!
    
    @IBOutlet weak var filteredImageCollectionView: UICollectionView!

    var filteredImages = [UIImage]() {
        didSet{
            self.filteredImageCollectionView.reloadData()
        }
    }
    
    var parseObject: PFObject!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let tabBarController = self.tabBarController, viewControllers = tabBarController.viewControllers {
            if let collectionViewController = viewControllers[1] as? CollectionViewController {
                collectionViewController.delegate = self
            }
        }
        
        self.filteredImageCollectionView.delegate = self
        self.filteredImageCollectionView.dataSource = self
        self.createFilteredImages()
        self.filteredImageCollectionView.hidden = true


        let collectionViewBounds = CGRectGetWidth(UIScreen.mainScreen().bounds)
        let collectionViewHeight = CGRectGetHeight(self.filteredImageCollectionView.frame)
        let galleryLayout = GridLayout()
        galleryLayout.thumbnailsFlowLayout(collectionViewBounds, viewHeight: collectionViewHeight)
        self.filteredImageCollectionView.collectionViewLayout = galleryLayout
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
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
            ParseService.uploadObjectToStatusClass(image, completion: { (success, error) -> Void in
                if let error = error {
                    print(error.description)
                    return
                }
                print("yay")
            })
        }
    }
    
    @IBAction func filterImageButton(sender: UIButton) {
        let filterAlert = UIAlertController(title: "Filters", message: "Choose an awesome filter...", preferredStyle: .ActionSheet)
        let vintageFilterAction = UIAlertAction(title: kVintageEffectTitle, style: .Default) { (alert) -> Void in
            FilterService.applyVintageEffect(self.imageView.image!, completion: { (filteredImage, name) -> Void in
                print("Vintage filter selected")
                if let filteredImage = filteredImage {
                    self.imageView.image = filteredImage
                }
            })
        }
        
        let bwFilterAction = UIAlertAction(title: kBWEffectTitle, style: .Default) { (alert) -> Void in
            FilterService.applyBWEffect(self.imageView.image!, completion: { (filteredImage, name) -> Void in
                print("BW filter selected")
                if let filteredImage = filteredImage {
                    self.imageView.image = filteredImage
                }
            })
        }
        
        let chromeFilterAction = UIAlertAction(title: kChromeEffectTitle, style: .Default) { (alert) -> Void in
            FilterService.applyChromeEffect(self.imageView.image!, completion: { (filteredImage, name) -> Void in
                print("Chrome filter selected")
                if let filteredImage = filteredImage {
                    self.imageView.image = filteredImage
                }
            })
        }
        
        let monochromeFilterAction = UIAlertAction(title: "Monochrome", style: .Default) { (alert) -> Void in
            FilterService.applyMonochromeEffect(self.imageView.image!, completion: { (filteredImage, name) -> Void in
                print("Monochrome filter selected")
                if let filteredImage = filteredImage {
                    self.imageView.image = filteredImage
                }
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        if self.imageView.image == nil {
            vintageFilterAction.enabled = false
            bwFilterAction.enabled = false
            chromeFilterAction.enabled = false
            monochromeFilterAction.enabled = false
        }
        
        filterAlert.addAction(vintageFilterAction)
        filterAlert.addAction(bwFilterAction)
        filterAlert.addAction(chromeFilterAction)
        filterAlert.addAction(monochromeFilterAction)
        filterAlert.addAction(cancelAction)
        
        self.presentViewController(filterAlert, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        let resizedImage = UIImage.resizeImage(image, size: CGSize(width: 600, height: 600))
        self.imageView.image = resizedImage
        createFilteredImages()
        self.filteredImageCollectionView.hidden = false

    }
    
    func createFilteredImages() {
        self.filteredImages.removeAll()
        if let image = self.imageView.image {
            FilterService.applyVintageEffect(image) { (filteredImage, name) -> Void in
                if let filteredImage = filteredImage {
                    self.filteredImages.append(filteredImage)
                }
            }
    
            FilterService.applyBWEffect(image) { (filteredImage, name) -> Void in
                if let filteredImage = filteredImage {
                    self.filteredImages.append(filteredImage)
                }
            }
    
            FilterService.applyChromeEffect(image) { (filteredImage, name) -> Void in
                if let filteredImage = filteredImage {
                    self.filteredImages.append(filteredImage)
                }
            }
    
            FilterService.applyMonochromeEffect(image) { (filteredImage, name) -> Void in
                if let filteredImage = filteredImage {
                    self.filteredImages.append(filteredImage)
                }
            }
            
            FilterService.applyInstantEffect(image) { (filteredImage, name) -> Void in
                if let filteredImage = filteredImage {
                    self.filteredImages.append(filteredImage)
                }
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredImages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(FilteredCollectionViewCell.identifier(), forIndexPath: indexPath) as! FilteredCollectionViewCell
        cell.image = self.filteredImages[indexPath.row]
        
        return cell
        
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let filteredImage = filteredImages[indexPath.row]
        self.imageView.image = filteredImage
    }     

    func collectionViewSelectedStatus(status: Status) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.imageView.image = status.image
        tabBarController!.selectedViewController = tabBarController!.viewControllers![0]
        createFilteredImages()
        self.filteredImageCollectionView.hidden = false
    }
    
}
