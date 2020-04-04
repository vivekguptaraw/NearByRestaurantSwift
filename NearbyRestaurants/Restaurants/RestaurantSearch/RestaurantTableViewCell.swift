//
//  RestaurantTableViewCell.swift
//  Restaurants
//
//  Created by Vivek Gupta on 29/03/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLable: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var starImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        restaurantImage.image = UIImage(named: "default")
        // Initialization code
    }

    override var viewBindableModel: ViewBindableProtocol? {
        didSet {
            self.nameLabel.text = viewBindableModel?.getTitle()
            self.locationLabel.text = viewBindableModel?.getSubtitle()
            self.descLabel.text = viewBindableModel?.getSubText()
            
        }
    }
    
    func setRating(val: String?) {
        guard  let v = val else {
            self.ratingLable.isHidden = true
            self.starImageView.isHidden = true
            return
        }
        self.ratingLable.isHidden = false
        self.starImageView.isHidden = false
        self.ratingLable.text = v
    }
    
    func setImage(link: String?) {
        guard let str = link else {
            self.restaurantImage.image = nil
            return
        }
        self.restaurantImage.loadImage(urlString: str, shouldReload: false) { (_) in}
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        restaurantImage.image = UIImage(named: "default")
    }
}
