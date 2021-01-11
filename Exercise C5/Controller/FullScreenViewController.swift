//
//  FullScreenViewController.swift
//  Exercise C5
//
//  Created by Vladimir Terzievski on 12/30/20.
//

import UIKit
import SDWebImage

class FullScreenViewController: UIViewController {
    
    @IBOutlet weak var fullScreenImgView: UIImageView!
    var album:Albums?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if let album = album {
            if let photo = album.photo {
                self.title = photo.title ?? ""
                if let url = photo.url {
                    fullScreenImgView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholder-image"))
                }
            }
        }
    }
}
