//
//  TrainerProfileViewController.swift
//  MyGYM
//
//  Created by Sara Abdulaziz on 23/02/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase


class TrainerProfileViewController: UIViewController {
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var TrainerID: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var createdLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createdLabel.isHidden = true
        
        // Do any additional setup after loading the view.
        let userID = Auth.auth().currentUser?.uid
        ref = Database.database().reference().child("users");
        
        ref.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let userObject = snapshot.value as? [String: AnyObject]
            let userName  = userObject?["Name"]
            let userEmail  = userObject?["Email"]
            let userTrainerID = userObject?["ID"]
            
            //appending it to list
            self.name.text = userName as? String
            self.email.text = (userEmail as! String)
            self.TrainerID.text = (userTrainerID as! String)
        })
    }
    
    
    @IBAction func editBtnTapped(_ sender: Any) {
        viewDidLoad()
    }
    
    @IBAction func resetBtnTapped(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: self.email.text!) { error in
            // Your code here
            print("REset!")
            self.createdLabel.text = "Emaail has bees successfully sent!"
            self.createdLabel.isHidden = false
        }
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "goToTrainerHomePage", sender: self)
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "goToTrainerHomePage", sender: self)
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
    
    
    
}
