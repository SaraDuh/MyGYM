//
//  WorkoutPlanModel.swift
//  MyGYM
//
//  Created by Aseel Mohimeed on 09/02/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import Foundation
class WorkoutPlanModel {
    var id: String?
    var day1: String?
    var day2: String?
    var day3: String?
    var day4: String?
    var trainerNeme: String?
    var trainerEmail: String?
    var trainerId: String?
    

    
    init (id:String?, day1:String?, day2:String?, day3:String?, day4:String?, trainerNeme:String?, trainerEmail:String?, trainerId:String? ){
        self.id = id;
        self.day1 = day1;
        self.day2 = day2;
        self.day3 = day3;
        self.day4 = day4;
        self.trainerNeme = trainerNeme;
        self.trainerEmail = trainerEmail;
        self.trainerId = trainerId;
    }
}
