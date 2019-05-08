//
//  TrainerClassReservationViewController.swift
//  MyGYM
//
//  Created by Deema on 09/03/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase

class TrainerClassReservationViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var trainerClasses: UITableView!
    var ref : DatabaseReference!
    var reservationList = [ReservationModel]()
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return reservationList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        //creating a cell using the custom class
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TrainerClassReservationTableViewCell
        
        //the reservation object
        let reservation: ReservationModel
        //getting the reservation of selected position
        reservation = reservationList[indexPath.row]
        
        //adding values to labels
        cell.memberID.text = reservation.memberID
        cell.className.text = reservation.name
        cell.classTime.text = reservation.time
        
        //returning cell
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ref = Database.database().reference().child("ClassResevations");
        
        //observing the data changes
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                self.reservationList.removeAll()
                
                //iterating through all the values
                for reservations in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let reservationObject = reservations.value as? [String: AnyObject]
                    let className  = reservationObject?["ClassName"]
                    let classTime  = reservationObject?["ClassTime"]
                    let memberID = reservationObject?["memberId"]
                    let mID = reservationObject?["userID"]
                    let ID = reservationObject?["id"]
                    
                    //creating artist object with model and fetched values
                    let reservation = ReservationModel(id: ID as! String?,name: className as! String?, time:classTime as! String?, memberID: memberID as! String?, userID: mID as! String?)
                    //appending it to list
                    self.reservationList.append(reservation)
                }
                
                //reloading the tableview
                self.trainerClasses.reloadData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
