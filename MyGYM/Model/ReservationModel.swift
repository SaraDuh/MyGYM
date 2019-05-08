//
//  ReservationModel.swift
//  MyGYM
//
//  Created by Deema on 30/02/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import Foundation
class ReservationModel {
   var id: String?
    var name: String?
    var time: String?
    var memberID : String?
    var userID: String?
    
    init (id:String?, name:String?, time:String?, memberID:String?, userID:String?){
        self.id = id;
        self.name = name;
        self.time = time;
        self.memberID = memberID;
        self.userID = userID;
    }
}
