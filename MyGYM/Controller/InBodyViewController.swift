//
//  InBodyViewController.swift
//  MyGYM
//
//  Created by Deema on 9/22/18.
//  Copyright © 2018 Deema. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

class InBodyViewController: UIViewController {


    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var bookLabel: UILabel!
    
    var refInBodies = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookLabel.isHidden = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func bookPressed(_ sender: Any) {
        //dateViewed.text = "\(datePicker.date)"
        let uid = Auth.auth().currentUser?.uid
        refInBodies.child("users").child(uid!).observeSingleEvent(of:
            .value, with: { (snapshot) in
                
                let value = snapshot.value as? NSDictionary
                let memberID = value?["MembershipID"] as? String ?? ""
                
                let key = self.refInBodies.childByAutoId().key
                
                
                let userID = Auth.auth().currentUser!.uid
                
                let selfDate = self.datePicker
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
                let dateString = dateFormatter.string(from: (selfDate?.date)!)

                
                
                print (dateString)
                let inBodyDate = ["id":key , "InbodyDate": dateString as String , "userID" : userID as String,  "MembershipID": memberID ]
                self.refInBodies.child("InBodyDate").child(key!).setValue(inBodyDate)
                
                self.bookLabel.text = "Your InBody reserved Successfully! "
                self.bookLabel.isHidden = false
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.bookLabel.isHidden = true
                }
                
                // Notification
                
                let content = UNMutableNotificationContent()
                content.title = "InBody Reservation"
                content.subtitle = ""
                content.body = "Your InBody has been reserved in \(dateString)"
                content.badge = 1
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)

        })
        
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "goToMemberHomePage", sender: self)
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
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

