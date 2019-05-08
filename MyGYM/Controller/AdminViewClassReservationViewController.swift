//
//  AdminViewClassReservationViewController.swift
//  MyGYM
//
//  Created by Deema on 30/02/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase

class AdminViewClassReservationViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var classesReservationTable: UITableView!
    var ref : DatabaseReference!
    var reservationList = [ReservationModel]()
   
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return reservationList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        //creating a cell using the custom class
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AdminViewClassReservationTableViewCell
        
        //the reservation object
        let reservation: ReservationModel
        //getting the reservation of selected position
        reservation = reservationList[indexPath.row]
        
        //adding values to labels
        cell.membershipID.text = reservation.memberID
        cell.className.text = reservation.name
        cell.classTime.text = reservation.time
        
        //returning cell
        return cell
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
                self.classesReservationTable.reloadData()
            }
        })
        
    }
    
    //this function will be called when a row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //getting the selected artist
        let reservation  = reservationList[indexPath.row]
        
        //building an alert
        let alertController = UIAlertController(title: reservation.memberID, message: "Do you want to delete this Class Reservation?", preferredStyle: .alert)
        
        //the cancel action doing nothing //delete is set insted!!!!!!!
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (_) in
            
            //deleting class
            self.deleteClass(id: reservation.id!)
        }
        
        let cancelAction = UIAlertAction(title: "Cancle", style: .cancel) { (_) in }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        //presenting dialog
        present(alertController, animated: true, completion: nil)
    }
    
    func deleteClass(id:String){
        ref.child(id).setValue(nil)
        
        //displaying message
        message.text = "Class Reservation Deleted!"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backPressed(_ sender: Any) {
         self.performSegue(withIdentifier: "goToAdminHomePage", sender: self)
    }
    
    @IBAction func homePressed(_ sender: Any) {
         self.performSegue(withIdentifier: "goToAdminHomePage", sender: self)
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
