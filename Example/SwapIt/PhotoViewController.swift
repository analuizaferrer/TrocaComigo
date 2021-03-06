//
//  PhotoViewController.swift
//  Koloda
//
//  Created by Ana Luiza Ferrer on 6/8/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //AV FOUNDATION
    
    var session: AVCaptureSession!
    var input: AVCaptureDeviceInput!
    var output: AVCaptureStillImageOutput!
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    @IBOutlet var photoLibrary: UIButton!
    @IBOutlet var camera: UIButton!
    
    @IBOutlet var photoButton1: UIButton!
    @IBOutlet var photoButton2: UIButton!
    @IBOutlet var photoButton3: UIButton!
    @IBOutlet var photoButton4: UIButton!
    @IBOutlet var photoButton5: UIButton!
    @IBOutlet var photoButton6: UIButton!
    
    @IBOutlet var photoImage1: UIImageView!
    @IBOutlet var photoImage2: UIImageView!
    @IBOutlet var photoImage3: UIImageView!
    @IBOutlet var photoImage4: UIImageView!
    @IBOutlet var photoImage5: UIImageView!
    @IBOutlet var photoImage6: UIImageView!
    
    
    var photo: UIImage?
    
    var photos = [UIImage]()
    
    var photoButtons = [UIButton]()
    var photoImages = [UIImageView]()
    
    var confirmationView: UIView!
    
    var confirmationImageView : UIImageView!
    
    var selectedPhoto = 0
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.navigationBar.barTintColor = UIColor(red: 1, green: 0.58, blue: 0.67, alpha: 1)
        
        photoButtons.append(photoButton1)
        photoButtons.append(photoButton2)
        photoButtons.append(photoButton3)
        photoButtons.append(photoButton4)
        photoButtons.append(photoButton5)
        photoButtons.append(photoButton6)
        
        photoImages.append(photoImage1)
        photoImages.append(photoImage2)
        photoImages.append(photoImage3)
        photoImages.append(photoImage4)
        photoImages.append(photoImage5)
        photoImages.append(photoImage6)
        
        for i in photoImages {
            i.image = UIImage(named: "no-photo")
        }
        
        var i = 0
        for button in photoButtons {
            button.tag = i
            button.addTarget(self, action: #selector(PhotoViewController.selectedPhoto(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            i = i + 1
        }
    
        //CONFIRMATION VIEW
        
        confirmationView = UIView(frame: CGRectMake(0, 0, view.frame.width, view.frame.height))
        confirmationView.backgroundColor = UIColor(red:1.00, green:0.58, blue:0.67, alpha:1.0)
        
        let confirmButton = UIButton(frame: CGRectMake(238,558,72,72))
        let excludeButton = UIButton(frame: CGRectMake(66,558,72,72))

        confirmButton.setBackgroundImage(UIImage(named: "check"), forState: .Normal)
        confirmButton.addTarget(self, action: #selector(PhotoViewController.confirmPhoto), forControlEvents: UIControlEvents.TouchUpInside)
        excludeButton.setBackgroundImage(UIImage(named: "trash"), forState: .Normal)
        excludeButton.addTarget(self, action: #selector(PhotoViewController.excludePhoto), forControlEvents: UIControlEvents.TouchUpInside)
        
        confirmationView.addSubview(confirmButton)
        confirmationView.addSubview(excludeButton)
        confirmationImageView = UIImageView(frame: CGRectMake(0,64,view.frame.width, 456))
        confirmationImageView.image = UIImage(named: "quadrado photo")
        confirmationView.addSubview(confirmationImageView)
        
        
        //AV FOUNDATION
        
        
        setupSession()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cameraAction(sender: UIButton) {
        guard let connection = output.connectionWithMediaType(AVMediaTypeVideo) else { return }
        connection.videoOrientation = .Portrait
        
        output.captureStillImageAsynchronouslyFromConnection(connection) { (sampleBuffer, error) in
            guard sampleBuffer != nil && error == nil else { return }
            
            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
            guard let image = UIImage(data: imageData) else { return }
            
//            self.presentActivityVCForImage(image)
            self.displayImage(image)
        }
    }

    @IBAction func photoLIbraryAction(sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        presentViewController(picker, animated: true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        photo = info[UIImagePickerControllerOriginalImage] as? UIImage; dismissViewControllerAnimated(true, completion: nil)
        displayImage(photo!)
    }
    
    func displayImage (thisImage: UIImage) {
        if (photos.count == 0) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrow"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PhotoViewController.arrowClicked))
        }
        
        if (photos.count < 6) {
            photoImages[photos.count].image = thisImage
            photoImages[photos.count].contentMode = UIViewContentMode.ScaleAspectFill
            photoImages[photos.count].clipsToBounds = true
            photos.append(thisImage)
            
            if (photos.count == 6) {
                photoLibrary.enabled = false
            }
        }
    }
    
    func refreshImages() {
        var i = 0
        for image in photos {
            photoImages[i].image = image
            photoImages[i].contentMode = UIViewContentMode.ScaleAspectFill
            photoImages[i].clipsToBounds = true
            i = i + 1
        }
        while i < photoButtons.count {
            photoImages[i].image = UIImage(named: "no-photo")
            i = i + 1
        }
    }
    
    func arrowClicked() {
        performSegueWithIdentifier("segueToDepartmentViewController", sender: self)
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
            confirmationImageView.contentMode = UIViewContentMode.ScaleAspectFill
            confirmationImageView.clipsToBounds = true
            
            view.addSubview(confirmationView)
        
        }
        
    }
    
    //AV FOUNDATION
    
    func setupSession() {
        session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetPhoto
        
        let camera = AVCaptureDevice
            .defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        do { input = try AVCaptureDeviceInput(device: camera) } catch { return }
        
        output = AVCaptureStillImageOutput()
        output.outputSettings = [ AVVideoCodecKey: AVVideoCodecJPEG ]
        
        guard session.canAddInput(input)
            && session.canAddOutput(output) else { return }
        
        session.addInput(input)
        session.addOutput(output)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        
        previewLayer!.videoGravity = AVLayerVideoGravityResizeAspect
        previewLayer!.connection?.videoOrientation = .Portrait
        
        view.layer.addSublayer(previewLayer!)
        
        session.startRunning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        previewLayer?.frame = CGRectMake(0, 64, view.frame.width, 455)
    }
    
    func presentActivityVCForImage(image: UIImage) {
        self.presentViewController(
            UIActivityViewController(activityItems: [image], applicationActivities: nil),
            animated: true,
            completion: nil
        )
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "segueToDepartmentViewController") {
            
            let departmentVC = segue.destinationViewController as! DepartmentViewController
            
            for i in photos {
                
                //Image into NSData format
                let imageData:NSData = UIImagePNGRepresentation(i)!
                
                //Encoding
                //let strBase64:String = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
                
                departmentVC.productImages.append(imageData)
            }
        
        }
        
    }

}
