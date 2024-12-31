//
//  FavNewsCell.swift
//  NASANews
//
//  Created by Haneen Medhat on 26/10/2024.
//

import UIKit

class FavNewsCell: UITableViewCell {

    @IBOutlet weak var favImg: UIImageView!
    
    @IBOutlet weak var newsTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupImage()
    }
    
    func setupImage(){
        favImg.layer.cornerRadius = 12
    }
    
    



}
