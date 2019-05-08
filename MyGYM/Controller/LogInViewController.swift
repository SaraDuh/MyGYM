//  LogInViewController.swift
//  MyGYM
//
//  Created by Aseel Mohimeed on 11/01/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesKeyboard()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func logInPressed(_ sender: UIButton) {
        
       // logInPressed.layer.cornerRadius = 10
        // logInPressed.clipsToBounds = true
        
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            if error != nil {
                print (error!)
                
                self.view.endEditing(true)
                
                if (self.emailTextfield.text?.isEmpty)! || (self.passwordTextfield.text?.isEmpty)!
                {
                    let alert = UIAlertController(
                        title: "Invalid Login!",
                        message: "Please fill your e-mail and password",
                        preferredStyle: UIAlertControllerStyle.alert)
                    
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        // do something when user press OK button, like deleting text in both fields or do nothing
                    }
                    
                    alert.addAction(OKAction)
                    
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                else {
                // need to add handel exception when invalid email or password
                    //MBProgressHUD.dismiss()
                    print("error")
                    let alertController = UIAlertController(title: "Invalid Login!", message: "Incorrect credentials", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    print(error?.localizedDescription as Any)
                }
                
            } else {
               let userID = Auth.auth().currentUser?.uid
               let ref = Database.database().reference().root
                ref.child("users").child(userID!).observeSingleEvent(of: .value, with: {     (snapshot) in
                    
                    let snapDict = snapshot.value as? NSDictionary
                    
                    let role = snapDict?["Role"] as? String ?? ""
                    print(role)
                        
                        if (role == "Member") {
                          print ("Log in succssful! Hi member")
                          self.performSegue(withIdentifier: "goToWelcomeAgain", sender: self)}
                        else if (role == "Trainer") {
                            print ("Log in succssful! Hi Trainer")
                            self.performSegue(withIdentifier: "goToTrainerHomePage", sender: self)}
                 else   if (role == "Admin") {
                        print ("Log in succssful! Hi Admin")
                        self.performSegue(withIdentifier: "goToAdminHomePage", sender: self)}
                   else {
                    print ("Sorry you are not member")}
                })

                }
            }
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "goToWelcome", sender: self)
    }
    
    
    @IBAction func forgetPasswordTapped(_ sender: Any) {
        let forgotPasswordAlert = UIAlertController(title: "Forgot password?", message: "Enter email address", preferredStyle: .alert)
        forgotPasswordAlert.addTextField { (textField) in
            textField.placeholder = "Enter email address"
        }
        forgotPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        forgotPasswordAlert.addAction(UIAlertAction(title: "Reset Password", style: .default, handler: { (action) in
            let resetEmail = forgotPasswordAlert.textFields?.first?.text
            Auth.auth().sendPasswordReset(withEmail: resetEmail!, completion: { (error) in
                //Make sure you execute the following code on the main queue
                DispatchQueue.main.async {
                    //Use "if let" to access the error, if it is non-nil
                    if let error = error {
                        let resetFailedAlert = UIAlertController(title: "Reset Failed", message: error.localizedDescription, preferredStyle: .alert)
                        resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(resetFailedAlert, animated: true, completion: nil)
                    } else {
                        let resetEmailSentAlert = UIAlertController(title: "Reset email sent successfully", message: "Check your email", preferredStyle: .alert)
                        resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(resetEmailSentAlert, animated: true, completion: nil)
                    }
                }
            })
        }))
        //PRESENT ALERT
        self.present(forgotPasswordAlert, animated: true, completion: nil)
    }
    
    
    func hidesKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
    
    
}
    

