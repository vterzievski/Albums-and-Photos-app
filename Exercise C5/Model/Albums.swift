//
//  Albums.swift
//  Exercise C5
//
//  Created by Vladimir Terzievski on 12/29/20.
//

import Foundation
import SwiftyJSON

class Albums {
    
    
    var userId : Int? 
    var id : Int?
    var title : String?
    
    var photo:Photos? = nil
    
    convenience init(_ json:JSON){
        self.init()
        
        if let userId = json["userId"].int {
            self.userId = userId
        }
        
        if let id = json["id"].int {
            self.id = id
        }
        
        if let title = json["title"].string {
            self.title = title
        }
    }
}
