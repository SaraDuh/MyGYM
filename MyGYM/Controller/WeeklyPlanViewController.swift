//
//  WeeklyPlanViewController.swift
//  MyGYM
//
//  Created by Aseel Mohimeed on 15/01/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase

class WeeklyPlanViewController: UIViewController {
    
    
    @IBOutlet weak var trainerName: UILabel!
    
    @IBOutlet weak var day1: UILabel!
    @IBOutlet weak var day2: UILabel!
    @IBOutlet weak var day3: UILabel!
    @IBOutlet weak var day4: UILabel!
    
    @IBOutlet weak var noPlansLabel: UILabel!
    
    var PalnsList = [WorkoutPlanModel]()
    var PlanRef:  DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        // test start
        
        trainerName.text = ""
        day1.text = ""
        day2.text = ""
        day3.text = ""
        day4.text = ""
        noPlansLabel.text = ""
        
        let ref = Database.database().reference()
        
        let uid = Auth.auth().currentUser?.uid
        
        ref.child("users").child(uid!).observeSingleEvent(of:
            .value, with: { (snapshot) in
                
                let value = snapshot.value as? NSDictionary
                let memberID = value?["MembershipID"] as? String ?? ""
                
                print (memberID)
                
                self.PlanRef = Database.database().reference().child("Training Plans");

                self.PlanRef.observe(DataEventType.value, with: { (snapshot) in
                    
                    //if the reference have some values
                    if snapshot.childrenCount > 0 {
                        
                        //clearing the list
                        self.PalnsList.removeAll()
                        
                        //iterating through all the values
                        for TrainingPlans in snapshot.children.allObjects as! [DataSnapshot] {
                            //getting values
                            let PlanObject = TrainingPlans.value as? [String: AnyObject]
                            let mID  = PlanObject?["Memebrship ID"]
                            let D1 = PlanObject?["Day1"]
                            let D2 = PlanObject?["Day2"]
                            let D3 = PlanObject?["Day3"]
                            let D4 = PlanObject?["Day4"]
                            let Tname  = PlanObject?["Trainer Name"]
                            //let Temail  = PlanObject?["Trainer Email"]
                            //let tID = PlanObject?["Trainer ID"]
                            


                             if (memberID == mID! as! String){

                                
                                print ("Current Memebr ID: ")
                                print (memberID)
                                print ("");
                                print ("Mmebr ID form plan: ")
                                print (mID!)
                                
                                print ("They are matching")
                                
                                self.trainerName.text! = Tname as! String
                                self.day1.text! = D1 as! String
                                self.day2.text! = D2 as! String
                                self.day3.text! = D3 as! String
                                self.day4.text! = D4 as! String
                            }
                            
                            //creating artist object with model and fetched values
                           // let Plan = WorkoutPlanModel(id: mID as! String?, day1: D1 as! String?, day2: D2 as! String?, day3: D3 as! String?, day4: D4 as! String?, trainerNeme: Tname as! String?, trainerEmail: Temail as! String?, trainerId: tID as! String? )
                            
                            //appending it to list
                           // self.PalnsList.append(Plan)
                           
                        }
                    }// end if
                    else {print ("No Plans in the list!")
                    self.noPlansLabel.text! = "You don't have any plans."
                    }
                })
        })
        //test end
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func plan(){
        
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "goToMemberHomePage", sender: self)
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "goToMemberHomePage", sender: self)
    }
    
    @IBAction func logOutPreseed(_ sender: Any) {
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
