//
//  AdminInBodyViewController.swift
//  MyGYM
//
//  Created by Deema on 24/02/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase

class AdminInBodyViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var MessageLable: UILabel!
    var InBodyRef:  DatabaseReference!
    @IBOutlet weak var inbodyTable: UITableView!
    
    //list to store all the inbodies
    var inbodyList = [InBodyModel]()
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return inbodyList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        //creating a cell using the custom class
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AdminInBodyTableViewCell
        //the inbody object
        let inbody: InBodyModel
        //getting the inbodies of selected position
        inbody = inbodyList[indexPath.row]
        
        //adding values to labels
        cell.memberID.text = inbody.memberID
        cell.bookTime.text = inbody.inbodyTime
        
        //returning cell
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
          InBodyRef = Database.database().reference().child("InBodyDate");
        
        //observing the data changes
        InBodyRef.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                //clearing the list
                self.inbodyList.removeAll()
                
                //iterating through all the values
                for inbodies in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let inbodyObject = inbodies.value as? [String: AnyObject]
                    let memberID  = inbodyObject?["MembershipID"]
                    let inbodyID  = inbodyObject?["id"]
                    let inbodyTime = inbodyObject?["InbodyDate"]
                    let mID = inbodyObject?["userID"]
                    
                    //creating artist object with model and fetched values
                    let inbody = InBodyModel(id: inbodyID as! String?, memberID: memberID as! String?, inbodyTime: inbodyTime as! String?, userID: mID as! String?)
                    
                    //appending it to list
                    self.inbodyList.append(inbody)
                }
                
                //reloading the tableview
                self.inbodyTable.reloadData()
            }
        })
    }

    
    
    //this function will be called when a row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //getting the selected artist
        let inbody  = inbodyList[indexPath.row]
        
        //building an alert
        let alertController = UIAlertController(title: inbody.memberID, message: "Do you want to delete this InBody Session?", preferredStyle: .alert)
        
        //the cancel action doing nothing //delete is set insted!!!!!!!
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (_) in
            
            //deleting class
            self.deleteClass(id: inbody.id!)
        }
        
        let cancelAction = UIAlertAction(title: "Cancle", style: .cancel) { (_) in }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        //presenting dialog
        present(alertController, animated: true, completion: nil)
    }
    
    func deleteClass(id:String){
        InBodyRef.child(id).setValue(nil)
        
        //displaying message
        MessageLable.text = "Session Deleted!"
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "goToAdminHomePage", sender: self)
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
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
