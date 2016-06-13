//
//  PhotoViewController.swift
//  Koloda
//
//  Created by Ana Luiza Ferrer on 6/8/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import AVFoundation

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //CAMERA
    
    var captureSession : AVCaptureSession?
    var stillImageOutput : AVCaptureStillImageOutput?
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    @IBOutlet var photoLibrary: UIButton!
    @IBOutlet var camera: UIButton!
    @IBOutlet var imageDisplay: UIImageView!
    
    @IBOutlet var photoButton1: UIButton!
    @IBOutlet var photoButton2: UIButton!
    @IBOutlet var photoButton3: UIButton!
    @IBOutlet var photoButton4: UIButton!
    @IBOutlet var photoButton5: UIButton!
    @IBOutlet var photoButton6: UIButton!
    
    var photo: UIImage?
    
    var photos = [UIImage]()
    
    var photoButtons = [UIButton]()
    
    var confirmationView: UIView!
    
    var confirmationImageView : UIImageView!
    
    var selectedPhoto = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 1, green: 0.58, blue: 0.67, alpha: 1)
        
        photoButtons.append(photoButton1)
        photoButtons.append(photoButton2)
        photoButtons.append(photoButton3)
        photoButtons.append(photoButton4)
        photoButtons.append(photoButton5)
        photoButtons.append(photoButton6)
        
        var i = 0
        for button in photoButtons {
            button.tag = i
            button.addTarget(self, action: #selector(PhotoViewController.selectedPhoto(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            i = i + 1
        }
        
        //CONFIRMATION VIEW
        
        confirmationView = UIView(frame: CGRectMake(0, 0, view.frame.width, view.frame.height))
        confirmationView.backgroundColor = UIColor.yellowColor()
        
        let confirmButton = UIButton(frame: CGRectMake(200,500,50,50))
        let excludeButton = UIButton(frame: CGRectMake(100,500,50,50))

        confirmButton.setBackgroundImage(UIImage(named: "Round"), forState: .Normal)
        confirmButton.addTarget(self, action: #selector(PhotoViewController.confirmPhoto), forControlEvents: UIControlEvents.TouchUpInside)
        excludeButton.setBackgroundImage(UIImage(named: "Round"), forState: .Normal)
        excludeButton.addTarget(self, action: #selector(PhotoViewController.excludePhoto), forControlEvents: UIControlEvents.TouchUpInside)
        
        confirmationView.addSubview(confirmButton)
        confirmationView.addSubview(excludeButton)
        
        confirmationImageView = UIImageView(frame: CGRectMake(0,0,view.frame.width, 450))
        
        confirmationImageView.image = UIImage(named: "quadrado photo")
        
        confirmationView.addSubview(confirmationImageView)

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
        
        if (photos.count == 0) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrow"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PhotoViewController.arrowClicked))
        }
        
        if (photos.count < 6) {
            
            imageDisplay.image = photo
            
            photoButtons[photos.count].setBackgroundImage(photo, forState: .Normal)
            
            photos.append(photo!)
            
            if (photos.count == 6) {
                
                galleryButton.enabled = false
            
            }
        }
        

    }
    
    func refreshImages() {
        var i = 0
        for image in photos {
            photoButtons[i].setBackgroundImage(image, forState: .Normal)
            i = i + 1
        }
        while i < photoButtons.count {
            photoButtons[i].setBackgroundImage(UIImage(named: "no-photo"), forState: .Normal)
            i = i + 1
        }
        
        
    }
    

    func arrowClicked() {
    
    }
    
    func confirmPhoto () {
        confirmationView.removeFromSuperview()
    }
    
    func excludePhoto() {
        
        photos.removeAtIndex(selectedPhoto)
        
        refreshImages()
        confirmationView.removeFromSuperview()

        
    }
    
    func selectedPhoto (sender:UIButton) {
        
        if(sender.tag < photos.count)
        {
            selectedPhoto = sender.tag
            
            confirmationImageView.image = photos[selectedPhoto]
            
            view.addSubview(confirmationView)
        
        }
        
    }
    

}
