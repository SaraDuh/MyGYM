//
//  File.swift
//  MyGYM
//
//  Created by Deema on 24/02/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import Foundation

class InBodyModel {
    
    var id: String?
    var memberID: String?
    var inbodyTime: String?
    
    init(id: String?,memberID: String?, inbodyTime: String? ){
        self.id = id
        self.memberID = memberID
        self.inbodyTime = inbodyTime
        
    }
}