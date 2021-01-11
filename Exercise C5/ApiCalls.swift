//
//  ApiCalls.swift
//  Exercise C5
//
//  Created by Vladimir Terzievski on 12/29/20.
//

import Alamofire
import SwiftyJSON

typealias CompletionAlbums = (_ completed: [Albums]?,_ error:Error?) -> ()
typealias CompletionPhotos = (_ completed: [Photos]?,_ error:Error?) -> ()

class ApiCalls {
    
    public static var shared = ApiCalls()
    
    var albumsUrl = "https://jsonplaceholder.typicode.com/albums"
    var photosUrl = "https://jsonplaceholder.typicode.com/photos"
    
    var albums = [Albums]()
    var photos = [Photos]()
    
    
    func getAllAlbums(completion: @escaping CompletionAlbums){
        Alamofire.request(albumsUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response  in
            if response.result.isSuccess {
                var myAlbums:[Albums] = []
                if let object = response.result.value {
                    let json = JSON(object)
                    if let albums = json.array {
                        for album in albums {
                            let myAlbum = Albums(album)
                            myAlbums.append(myAlbum)
                        }
                    }
                }
                completion(myAlbums,nil)
            } else {
                completion(nil,response.result.error)
            }
        }
        
    }
    
    func getPhotos(completion: @escaping CompletionPhotos){
        Alamofire.request(photosUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response  in
            if response.result.isSuccess {
                var myPhotos:[Photos] = []
                if let object = response.result.value {
                    let json = JSON(object)
                    if let photos = json.array {
                        for photo in photos {
                            let myPhoto = Photos(photo)
                            myPhotos.append(myPhoto)
                        }
                    }
                }
                completion(myPhotos,nil)
            } else {
                completion(nil,response.result.error)
            }
        }
        
    }
    
    
    
    
    
}
