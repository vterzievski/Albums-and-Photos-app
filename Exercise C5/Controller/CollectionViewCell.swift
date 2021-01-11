//
//  CollectionViewCell.swift
//  Exercise C5
//
//  Created by Vladimir Terzievski on 12/29/20.
//

import UIKit
import SDWebImage

class CollectionViewCell: UICollectionViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var imageViewCell: UIImageView!
    @IBOutlet weak var labelViewCell: UILabel!
    
    
    func setup(album:Albums) {
        labelViewCell.text = album.title
        imageViewCell.sd_setImage(with: URL(string: album.photo?.thumbnailUrl ?? ""), placeholderImage: UIImage(named: "placeholder-image"))
    }
}
