//
//  TrainerWeeklyScheduleViewController.swift
//  MyGYM
//
//  Created by Deema on 09/03/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase

class TrainerWeeklyScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var trainerSchedule: UITableView!
    var refClasses: DatabaseReference!
      var classList = [ClassModel]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return classList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        //creating a cell using the custom class
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TrainerScheduleTableViewCell
        
        //the artist object
        let class1: ClassModel
        
        //getting the artist of selected position
        class1 = classList[indexPath.row]
        
        //adding values to labels
        
        cell.className.text = class1.name
        cell.classTime.text = class1.time
        
        //returning cell
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
                self.trainerSchedule.reloadData()
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
    
    @IBAction func logOutPrseed(_ sender: Any) {
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
