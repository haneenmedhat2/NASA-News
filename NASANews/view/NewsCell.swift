//
//  NewsCell.swift
//  NASANews
//
//  Created by Haneen Medhat on 16/10/2024.
//

import UIKit

class NewsCell: UICollectionViewCell {
    @IBOutlet weak var newsLabel: UILabel!
    
    @IBOutlet weak var newsImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupImageView()
    }
    
     func setupImageView() {
        newsImage.layer.cornerRadius = 12
    }

}
