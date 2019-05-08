//
//  TrainerEditProfileViewController.swift
//  MyGYM
//
//  Created by Sara Abdulaziz on 25/02/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase

class TrainerEditProfileViewController: UIViewController {

    var ref: DatabaseReference!
    
    var storageRef = Storage.storage().reference()
    
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var nameTextF: UITextField!
    @IBOutlet weak var emailTextF: UITextField!
    @IBOutlet weak var createdLabel: UILabel!

//   a self.title = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.hidesKeyboard()
        createdLabel.isHidden = true
        
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

        // Do any additional setup after loading the view.
    }
        )}
    
    
    @IBAction func doneBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateBtnTapped(_ sender: Any) {
            let userID = Auth.auth().currentUser?.uid
            
            let newName = self.nameTextF.text
            let newEmail = self.emailTextF.text

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
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Edit Profile"
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
     }*/
    
    

}
