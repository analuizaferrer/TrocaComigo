//
//  PhotoViewController.swift
//  Koloda
//
//  Created by Ana Luiza Ferrer on 6/8/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var photoLibrary: UIButton!
    @IBOutlet var camera: UIButton!
    @IBOutlet var imageDisplay: UIImageView!
    
    @IBOutlet var photoButton1: UIButton!
    @IBOutlet var photoButton2: UIButton!
    @IBOutlet var photoButton3: UIButton!
    @IBOutlet var photoButton4: UIButton!
    @IBOutlet var photoButton5: UIButton!
    @IBOutlet var photoButton6: UIButton!
    @IBOutlet var arrowButton: UIButton!
    @IBOutlet var galleryButton: UIButton!
    
    var photo: UIImage?
    
    var photos = [UIImage]()
    
    var photoButtons = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if photos.count == 0 {
            arrowButton.hidden = true
        }
        
        photoButtons.append(photoButton1)
        photoButtons.append(photoButton2)
        photoButtons.append(photoButton3)
        photoButtons.append(photoButton4)
        photoButtons.append(photoButton5)
        photoButtons.append(photoButton6)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cameraAction(sender: UIButton) {
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.sourceType = .Camera
        
        presentViewController(picker, animated: true, completion: nil)
        
    }

    @IBAction func photoLIbraryAction(sender: UIButton) {
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        
        presentViewController(picker, animated: true, completion: nil)
        
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    
        photo = info[UIImagePickerControllerOriginalImage] as? UIImage; dismissViewControllerAnimated(true, completion: nil)
        
        if (photos.count < 6) {
            
            imageDisplay.image = photo
            
            photoButtons[photos.count].setBackgroundImage(photo, forState: .Normal)
            
            photos.append(photo!)
            
            if (photos.count == 6) {
                
                galleryButton.enabled = false
            
            }
        }
        
        arrowButton.hidden = false
        
        
    }

}
