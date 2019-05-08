//
//  ClassModel.swift
//  MyGYM
//
//  Created by  Deema on 17/01/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

class ClassModel {
    var id: String?
    var name: String?
    var time: String?
    //  var capacity: String?
    
    init (id:String?, name:String?, time:String?){
        self.id = id;
        self.name = name;
        self.time = time;
        //  self.capacity = capacity; // remove capacity
    }
}
