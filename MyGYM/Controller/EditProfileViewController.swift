//
//  EditProfileViewController.swift
//  MyGYM
//
//  Created by Sara Abdulaziz on 28/01/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import Photos

class EditProfileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    

    var ref: DatabaseReference!
    
    var storageRef = Storage.storage().reference()

    var imagePicker = UIImagePickerController()
    var permission = false

    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    @IBOutlet weak var nameTextF: UITextField!
    @IBOutlet weak var emailTextF: UITextField!
    @IBOutlet weak var passwordTextF: UITextField!
    @IBOutlet weak var repeatPasswordTextF: UITextField!
    
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var changePic: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hidesKeyboard()
          createdLabel.isHidden = true
        passwordTextF.isHidden = true
        repeatPasswordTextF.isHidden = true
        changePic.isHidden = true
        
        // Do any additional setup after loading the view.
        
       let userID = Auth.auth().currentUser?.uid
       ref = Database.database().reference().child("users");
        
//        data retrieval
        ref.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get user value
      let userObject = snapshot.value as? [String: AnyObject]
      let userName  = userObject?["Name"]
      let userEmail  = userObject?["Email"]
        
          //appending it to list
        self.nameTextF.text = userName as? String
        self.emailTextF.text = (userEmail as! String)

            
            if(userObject!["photo"] !== nil ){
                let databaseProfilePic = userObject!["photo"] as! String
                let data = NSData(contentsOf: NSURL(string: databaseProfilePic)! as URL)
                  print("70________________________________________")
                self.setProfilePicture(imageView: self.profilePictureImageView,imageToSet:UIImage(data: data! as Data)!)
                
            }
        
                })
        }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func doneBtnTapped(_ sender: Any) {
      self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func chooseBtnTapped(_ sender: UITapGestureRecognizer) {
    
            
            let myActionsheet = UIAlertController(title: "Profile Picture", message: "Select", preferredStyle: .actionSheet)
//
//            let viewPicture = UIAlertAction(title: "View Picture", style: UIAlertActionStyle.default) { (action) in
//                let imageView = sender.view as! UIImageView
//                let newImageView = UIImageView(image: imageView.image)
//
//                newImageView.frame = self.view.frame
//                newImageView.backgroundColor = UIColor.white
//                newImageView.contentMode = .scaleAspectFit
//                newImageView.isUserInteractionEnabled = true
//
//                let tap = UITapGestureRecognizer(target: self,action:#selector(self.dismissFullScreenImage))
//
//                newImageView.addGestureRecognizer(tap)
//                self.view.addSubview(newImageView)
//                print("110________________________________________")
//
//        }
//            let photoGallery = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.default) { (action) in
//
//                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum)
//                {
//                    self.imagePicker.delegate = self
//                    self.imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
//                    self.imagePicker.allowsEditing = true
//                    self.present(self.imagePicker, animated: true, completion: nil)
//                    print("121________________________________________")
//
//                }
//                print("124________________________________________")

//            }
            let camera = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) { (action) in
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
                {
                    self.imagePicker.delegate = self
                    self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                    self.imagePicker.allowsEditing = true
                    
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
                
            }
            
//            myActionsheet.addAction(viewPicture)
//            myActionsheet.addAction(photoGallery)
            myActionsheet.addAction(camera)
            
            myActionsheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            
            self.present(myActionsheet, animated: true, completion: nil)
            
        }
        

    
    @IBAction func updateBtnTapped(_ sender: Any) {
        let userID = Auth.auth().currentUser?.uid
        
        let newName = self.nameTextF.text
        let newEmail = self.emailTextF.text
        //        if self.passwordTextF.text != nil && self.repeatPasswordTextF.text != nil && self.passwordTextF.text == self.repeatPasswordTextF.text {
        //        let newPass = self.passwordTextF.text
        //       }
        
        if newName != nil && newEmail != nil {
            
            if Auth.auth().currentUser != nil{
                Auth.auth().currentUser?.updateEmail(to: newEmail!) { error in
                    if let error = error {
                        print(error.localizedDescription)
                        self.createdLabel.text = "Can't be Updated!"
                        self.createdLabel.isHidden = false
                    } else {
                        let newProfileValues = ["Name": newName, "Email":newEmail]
                        self.ref.child(userID!).updateChildValues(newProfileValues as [AnyHashable : Any], withCompletionBlock: {(error,ref) in
                            if error != nil{
                                print(error!)
                                return
                            }
                            print("CHANGED")
                            print("Profile Updated Successfully")
                            self.createdLabel.text = "Profile Updated Successfully!"
                            self.createdLabel.isHidden = false
                        }) // updateChildValues fun
                    }// else
                }// updateEmail func
            }// currentUser != nil
        }// if
        
        
        
    }// method

    
    internal func setProfilePicture(imageView:UIImageView,imageToSet:UIImage){
          print("169________________________________________")
        imageView.layer.cornerRadius = 10.0
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.masksToBounds = true
        checkPermission()
        if permission != false {
        imageView.image = imageToSet
        print("181________________________________________")
        }

    }
    
    
    
    @objc func dismissFullScreenImage(sender: UITapGestureRecognizer){
        sender.view?.removeFromSuperview() }
  
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo image: UIImage) {
        print("231________________________________________")
        
        setProfilePicture(imageView: self.profilePictureImageView,imageToSet: image)
        print("238_____________________________________")

        let currentUser = Auth.auth().currentUser?.uid
        print("241_____________________________________")

        
        //        if let imageData: NSData = (UIImagePNGRepresentation(self.profilePictureImageView.image!)! as NSData)

        let imageData: NSData
        let imageTry: NSData
        print("244_____________________________________")
        imageTry = UIImagePNGRepresentation(self.profilePictureImageView.image!)! as NSData
        imageData = UIImagePNGRepresentation(self.profilePictureImageView.image!)! as NSData
        print("247_____________________________________")
        if !(imageData != imageTry) {
            print("236_____________________________________")
            let profilePicStorageRef = storageRef.child("photos/\(currentUser!)/photo")
            //let uploudTask = profilePicStorageRef.putData(imageData as Data, metadata: nil)
            _ = profilePicStorageRef.putData(imageData as Data, metadata: nil)
            {metadata,error in
                if error == nil
                {
                    print("241________________________")
                    
                    //let size = metadata!.size
                    self.storageRef.child("photos/\(currentUser!)/photo").downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            // Uh-oh, an error occurred!
                            print(error?.localizedDescription as Any)
                            print("253_______________________")
                            return
                        };self.ref.child(currentUser!).child("photo").setValue(downloadURL.absoluteString)
                        //let downloadUrl = metadata?.downloadURL()
                        
                        //                    self.ref.child(currentUser).child("photo").setValue(downloadUrl!.absoluteString)
                        
                    }
                }
            }
            
        } else { print("269________________________")}
        
    }
    

        
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : Any]) {
//          print("231________________________________________")
//
//        setProfilePicture(imageView: self.profilePictureImageView,imageToSet: image)
//        let currentUser = Auth.auth().currentUser?.uid
//        //ref = Database.database().reference().child("users");
//
//
//        if let imageData: NSData = (UIImagePNGRepresentation(self.profilePictureImageView.image!) as! NSData)
//
//        {
//            print("236_____________________________________")
//            let profilePicStorageRef = storageRef.child("photos/\(currentUser!)/photo")
//            let uploudTask = profilePicStorageRef.putData(imageData as Data, metadata: nil)
//            {metadata,error in
//                if error == nil
//                {
//                    print("241________________________")
//
//                    self.storageRef.child("photos/\(currentUser!)/photo").downloadURL { (url, error) in
//                    guard let downloadURL = url else {
//                        // Uh-oh, an error occurred!
//                        print(error?.localizedDescription)
//                        print("253_________")
//                        return
//                        };self.ref.child(currentUser!).child("photo").setValue(downloadURL.absoluteString)
////let downloadUrl = metadata?.downloadURL()
//
////                    self.ref.child(currentUser).child("photo").setValue(downloadUrl!.absoluteString)
//
//                }
//                }
//            }
//
//        }
//
//    }
    
    
    // Authorization for Photos
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    self.permission = true
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        }
    }
    

    
    func hidesKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
