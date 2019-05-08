//
//  AgainViewController.swift
//  MyGYM
//
//  Created by Aseel Mohimeed on 11/01/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase

//var cells = ["Profile","Weekly Schedule","InBody Reservation","Workout Plan", "My InBody Reservations","My Classess Reservations"]
//var myIndex = 0

class AgainViewController: UIViewController  {

    override func viewDidLoad() {
        super.viewDidLoad()


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
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

//My InBody Reservations
//My Classess Reservations
    
    
    // new
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return cells.count
//    }
//
//     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = cells[indexPath.row]
//        return cell
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        //if user clicks on "Profile" myIndex = 0 / "Weekly Schedule" myIndex = 1 ...etc
//        myIndex = indexPath.row
//        if myIndex == 0 {
//            performSegue(withIdentifier: "segueProfile", sender: self)
//        }
//        else if myIndex == 1 {
//            performSegue(withIdentifier: "segueSchedule", sender: self)
//        }
//        else if myIndex == 2 {
//            performSegue(withIdentifier: "segueInBody", sender: self)
//
//        }
//        else if myIndex == 3 {
//            performSegue(withIdentifier: "segueWeeklyPlan", sender: self)
//
//        }
//        else if myIndex == 4 {
//            performSegue(withIdentifier: "goToMyInBodyReservations", sender: self)
//
//        }
//        else {
//            performSegue(withIdentifier: "goToMyClassesReservation", sender: self)
//
//        }
//    }
    

    
    
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


