//
//  TrainerWeeklyPlanViewController.swift
//  MyGYM
//
//  Created by Aseel Mohimeed on 09/02/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase

class TrainerWeeklyPlanViewController: UIViewController {


    @IBOutlet weak var membershipIdTextField: UITextField!
    
    @IBOutlet weak var day1TextField: UITextField!
    @IBOutlet weak var day2TextField: UITextField!
    @IBOutlet weak var day3TextField: UITextField!
    @IBOutlet weak var day4TextField: UITextField!
    
    @IBOutlet weak var errorLable: UILabel!
    @IBOutlet weak var notSubmitted: UILabel!

    
    //Array to store all classes
    var PalnsList = [WorkoutPlanModel]()
    var PlanRef:  DatabaseReference!
    
    let TrainingPlansRef = Database.database().reference().child("Training Plans");
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
        errorLable.isHidden = true
        notSubmitted.isHidden = true
        
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submit(_ sender: Any) {
        if (self.membershipIdTextField.text?.isEmpty)!
        {
            notSubmitted.text = "Plan is NOT submitted! Please fill in all fields"
            self.notSubmitted.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.notSubmitted.isHidden = true
            }
        } 
            
        else {
            submitPlan() }
        
    }
    
        
        func submitPlan(){
            if ((self.day1TextField.text?.isEmpty)! && (self.day2TextField.text?.isEmpty)! && (self.day3TextField.text?.isEmpty)! && (self.day4TextField.text?.isEmpty)! ){
                notSubmitted.text = "Fill in at least one day!"
                self.notSubmitted.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.notSubmitted.isHidden = true
                }
            }
            else {
            //test trainer email & name

                
                let ref = Database.database().reference()

                let uid = Auth.auth().currentUser?.uid
                ref.child("users").child(uid!).observeSingleEvent(of:
                    .value, with: { (snapshot) in
                        
                        let value = snapshot.value as? NSDictionary
                        let trainerName = value?["Name"] as? String ?? ""
                        let trainerEmail = value?["Email"] as? String ?? ""
                        let trainerId = value?["ID"] as? String ?? ""
                        
                        //self.tName!(trainerName)
                        //self.tEmail!(trainerEmail)
                        
                        let PlanId = self.TrainingPlansRef.childByAutoId().key
                        
                        //creating a class based on the info passed by the admin
                        
                        
                        let plan1 = ["Memebrship ID": self.membershipIdTextField.text!, "Day1": self.day1TextField.text!, "Day2": self.day2TextField.text!, "Day3": self.day3TextField.text!, "Day4": self.day4TextField.text!,
                                     "Trainer Name": trainerName,
                                     "Trainer Email": trainerEmail,
                                     "Trainer ID": trainerId]
                        
                        self.TrainingPlansRef.child(PlanId!).setValue(plan1)
                        
                        
                        self.errorLable.text = "Plan is submited successfully"
                        self.errorLable.isHidden = false
                        
                        self.membershipIdTextField.text! = ""
                        self.day1TextField.text! = ""
                        self.day2TextField.text! = ""
                        self.day3TextField.text! = ""
                        self.day4TextField.text! = ""
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            self.errorLable.isHidden = true
                        }
                        

                })
                
            // end test 
                
                
                
            //give a uniqe id to a class
          
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
    
    func hidesKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    }
    



