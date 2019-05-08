//
//  WelcomeController.swift
//  MyGYM
//
//  Created by Aseel Mohimeed on 11/01/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //If there is a logged in user, by pass this screen and go straight to ChatViewController
        
        if Auth.auth().currentUser != nil {
           
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
}
