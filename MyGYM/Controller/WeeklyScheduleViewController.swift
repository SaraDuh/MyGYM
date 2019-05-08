//
//  WeeklyScheduleViewController.swift
//  MyGYM
//
//  Created by Aseel Mohimeed on 15/01/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase

class WeeklyScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var bookLabel: UILabel!
   
    //new
    var refClasses: DatabaseReference!
    

    @IBOutlet weak var weeklyScheduleTable: UITableView!
    
    
    
        var classList = [ClassModel]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return classList.count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        //creating a cell using the custom class
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MembelScheduleTableViewCell
        
        //the artist object
        let class1: ClassModel
        
        //getting the artist of selected position
        class1 = classList[indexPath.row]
        
        //adding values to labels
       
        cell.classNameLable.text = class1.name
        cell.classTimeLable.text = class1.time
        
        //returning cell
        return cell
    }
    // end new
    
    override func viewDidLoad() {
        super.viewDidLoad()
    self.bookLabel.text = ""
        // Do any additional setup after loading the view.
        refClasses = Database.database().reference().child("classes");
        
        //observing the data changes
        refClasses.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                self.classList.removeAll()
                
                //iterating through all the values
                for classes in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let classtObject = classes.value as? [String: AnyObject]
                    let classId  = classtObject?["id"]
                    let className  = classtObject?["className"]
                    let classTime  = classtObject?["classDate"]
                    
                    //creating artist object with model and fetched values
                    let Class = ClassModel(id: classId as! String?, name: className as! String?, time: classTime as! String?)
                    
                    //appending it to list
                    self.classList.append(Class)
                }
                
                //reloading the tableview
                self.weeklyScheduleTable.reloadData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func BookPressed(_ sender: Any) {
        let ref = Database.database().reference()
        refClasses = Database.database().reference().child("ClassResevations")
        let key = refClasses.childByAutoId().key
        let userID = Auth.auth().currentUser!.uid
        let class1: ClassModel
        
        guard let cell = (sender as AnyObject).superview??.superview as? UITableViewCell else {
            return // or fatalError() or whatever
        }
        
        let indexPath = weeklyScheduleTable.indexPath(for: cell)
        
        let x = indexPath?.row
        
        //getting the artist of selected position
        
        class1 = classList [x!]
        
        //adding values to labels
        
        
        
        ref.child("users").child(userID).observeSingleEvent(of:
            .value, with: { (snapshot) in
                
                let value = snapshot.value as? NSDictionary
                let memberName = value?["Name"] as? String ?? ""
                let memberEmail = value?["Email"] as? String ?? ""
                let memberId = value?["MembershipID"] as? String ?? ""
                
                let ClassReservation = ["id":key , "ClassName": class1.name , "ClassTime": (class1.time as String?), "userID" : userID as String ,"memberName": memberName , "memberEmail" : memberEmail , "memberId" : memberId ]
                self.refClasses.child(key!).setValue(ClassReservation)  } )
        
        self.bookLabel.text = "Your Class reserved Successfully! "
        self.bookLabel.isHidden = false
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.bookLabel.isHidden = true
        }
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
