//
//  LocationTableViewCell.swift
//  Restaurants
//
//  Created by Vivek Gupta on 29/03/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

class LocationTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var descLabel: UILabel!
    
    override var viewBindableModel: ViewBindableProtocol? {
        didSet {
            self.titleLabel.text = viewBindableModel?.getTitle()
            self.subTitleLabel.text = viewBindableModel?.getSubtitle()
            self.descLabel.text = viewBindableModel?.getSubText()
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    
}
