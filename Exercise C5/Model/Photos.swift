//
//  Photos.swift
//  Exercise C5
//
//  Created by Vladimir Terzievski on 12/29/20.
//

import Foundation
import SwiftyJSON

class Photos {
    
    var albumId : Int?
    var id : Int?
    var title : String?
    var url : String?
    var thumbnailUrl : String?
    
    convenience init(_ json:JSON) {
        self.init()
        if let albumId = json["albumId"].int {
            self.albumId  = albumId
        }
        if let id = json["id"].int {
            self.id  = id
        }
        if let title = json["title"].string {
            self.title  = title
        }
        if let url = json["url"].string {
            self.url  = url
        }
        if let thumbnailUrl = json["thumbnailUrl"].string {
            self.thumbnailUrl  = thumbnailUrl
        }
    }
}



