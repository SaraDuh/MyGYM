//
//  ProfileViewController.swift
//  MyGYM
//
//  Created by  Deema on 13/01/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    var ref: DatabaseReference!

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var MembershipID: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 self.createdLabel.isHidden = true
        //        imageProfile.image = UIImage( named: "userDefault.png")
//weeklyPlan.text = "Week 1: \n\n Sunday: \n Monday: \n Tuesday: \n Wednesday \n Thursday: \n Friday \n Saturday: "

            // Do any additional setup after loading the view.
            
            let userID = Auth.auth().currentUser?.uid
            ref = Database.database().reference().child("users");
            
            ref.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let userObject = snapshot.value as? [String: AnyObject]
                let userName  = userObject?["Name"]
                let userEmail  = userObject?["Email"]
                //let userRole  = userObject?["Role"]
                let userMembershipID = userObject?["MembershipID"]
                
                //appending it to list
                self.name.text = userName as? String
                self.email.text = (userEmail as! String)
                self.MembershipID.text = (userMembershipID as! String)
            })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateProfirePressed(_ sender: Any) {
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
    
    
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "goToMemberHomePage", sender: self)
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "goToMemberHomePage", sender: self)
        
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
