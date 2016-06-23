//
//  UserTableViewController.swift
//  Koloda
//
//  Created by Helena Leitão on 14/06/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import Firebase

var closetArray : [NSData] = []

class UserTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    var closetImageIds : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
        self.profileImage.clipsToBounds = true
        
        let user = UIImage(named: "user-fill")
        let imageView = UIImageView(image: user)
        self.navigationItem.titleView = imageView
        
        generateClosetImageIDArray()
        
        
        
    }
    
    func generateClosetImageIDArray () {
        
        for i in User.singleton.products {
            closetImageIds.append(i.id!)
        }
        
        DAO().getClosetImages(closetImageIds, callback: { images in
            for image in images {
                closetArray.append(image)
                print("appending 2")
            }
            
        })

        
    }
    
    override func viewWillAppear(animated: Bool) {
        if User.singleton.name != nil {
            self.nameLabel.text = User.singleton.name
        }
       
        if User.singleton.location != nil {
            self.locationLabel.text = User.singleton.location
        }
        
        if User.singleton.profilePic != nil {
            profileImage.image = User.singleton.profilePic
        }
        
        let imageData: NSData = UIImagePNGRepresentation(profileImage.image!)!
        DAO().registerProfilePic(imageData)
        User.singleton.profilePic = profileImage.image
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func callbackName(snapshot: FIRDataSnapshot) {
        self.nameLabel.text = snapshot.value! as? String
    }
    
    func callbackLocation(snapshot: FIRDataSnapshot) {
        self.locationLabel.text = snapshot.value! as? String
    }

    @IBAction func image(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Change Profile Photo", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let removeCurrentPhoto = UIAlertAction(title: "Remove Current Photo", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction) in
            
            self.profileImage.image = UIImage(named: "profile")
            User.singleton.profilePic = self.profileImage.image
            DAOCache().saveUser()
        
        })
        alert.addAction(removeCurrentPhoto)
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction) in
            
            let picker = UIImagePickerController()
            
            picker.delegate = self
            picker.sourceType = .Camera
            
            self.presentViewController(picker, animated: true, completion: nil)
            
        })

        alert.addAction(takePhoto)
        
        let chooseFromLibrary = UIAlertAction(title: "Choose From Library", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction) in
            
            let picker = UIImagePickerController()
            
            picker.delegate = self
            picker.sourceType = .PhotoLibrary
            
            self.presentViewController(picker, animated: true, completion: nil)
            
        })

        alert.addAction(chooseFromLibrary)
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(cancel)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let profilePhoto = info[UIImagePickerControllerOriginalImage] as? UIImage; dismissViewControllerAnimated(true, completion: nil)
        
        self.profileImage.image = profilePhoto
        
        User.singleton.profilePic = profilePhoto
        DAOCache().saveUser()
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.row {
        case 1:
            performSegueWithIdentifier("profile", sender: self)
            break
        case 2:
            
            if closetArray.count == User.singleton.products.count {
                
                self.performSegueWithIdentifier("closet", sender: self)
                
            }
                
            
            break
        case 3:
            performSegueWithIdentifier("settings", sender: self)
            break
        default:
            print("pmsdinv")
        }
    }
    
    override func viewDidLayoutSubviews() {
        if self.tableView.respondsToSelector(Selector("setSeparatorInset:")) {
            self.tableView.separatorInset = UIEdgeInsetsZero
        }
        if self.tableView.respondsToSelector(Selector("setLayoutMargins:")) {
            self.tableView.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell.respondsToSelector(Selector("setSeparatorInset:")) {
            cell.separatorInset = UIEdgeInsetsZero
        }
        if cell.respondsToSelector(Selector("setLayoutMargins:")) {
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    func encodeProfilePhoto (profilePhoto: UIImage) -> String {
    
        //Image into NSData format
        let imageData:NSData = UIImagePNGRepresentation(profilePhoto)!
    
        //Encoding
        let strBase64:String = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        
        return strBase64

    }
}
