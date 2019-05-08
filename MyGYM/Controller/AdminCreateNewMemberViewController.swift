//
//  AdminCreateNewMemberViewController.swift
//  MyGYM
//
//  Created by Aseel Mohimeed on 18/01/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase

class AdminCreateNewMemberViewController: UIViewController {

    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var membershipID: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var createdLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesKeyboard()
        createdLabel.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createPressed(_ sender: Any) {
        
        //TODO: Set up a new user on our Firbase database
      //  guard let email = emailTextfield.text, !email.isEmpty else { print("Email is empty"); return }
      //  guard let password = passwordTextfield.text, !password.isEmpty else { print("Pssword is empty"); return }
      //  guard let name = nameTextfield.text, !name.isEmpty else { print("Name is empty"); return }
      //  guard let membershipId = membershipID.text, !membershipId.isEmpty else { print("Membership ID is empty"); return }
        
        let email = emailTextfield.text
        let password = passwordTextfield.text
        let ref = Database.database().reference().root
        let name = nameTextfield.text
        let membershipId = membershipID.text
        
        if email != "" && password != "" && name != "" && membershipId != ""{
            Auth.auth().createUser(withEmail: email!, password: password!, completion: { (user, error) in if error != nil{
                print(error!)
                
                    let alertController = UIAlertController(title: "Error!", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                
                } else {
                //success
                print ("Registration Successful!")
                let userID = Auth.auth().currentUser!.uid
                
                ref.child("users").child(userID).setValue(["Name": name, "Email": email, "Role": "Member", "MembershipID": membershipId])
                
                self.createdLabel.text = "Member Created Successfully! "
                self.createdLabel.isHidden = false
                
                self.nameTextfield.text = ""
                self.emailTextfield.text = ""
                self.membershipID.text = ""
                self.passwordTextfield.text = ""
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.createdLabel.isHidden = true
                }
                }
            })
        } else {
            self.view.endEditing(true)

                let alert = UIAlertController(
                    title: "Invalid Registration!",
                    message: "Please fill in all fields",
                    preferredStyle: UIAlertControllerStyle.alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    // do something when user press OK button, like deleting text in both fields or do nothing
                }
                
                alert.addAction(OKAction)
                
                self.present(alert, animated: true, completion: nil)
                return
            
        }
    }
    
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "goToAdminHomePage", sender: self)
    }
    
  
        
    @IBAction func backButtonPressed(_ sender: Any) {
                self.performSegue(withIdentifier: "goToAdminManageAccounts", sender: self)
    }
    

    @IBAction func logOutPressed(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            
            navigationController?.popToRootViewController(animated: true)
            
        }
        catch {
            print("error: there was a problem logging out")
        }
    }
    
    // The 2 functions here to hide navigation bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
