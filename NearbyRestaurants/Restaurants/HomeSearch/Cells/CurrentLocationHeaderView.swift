//
//  CurrentLocationHeaderView.swift
//  Restaurants
//
//  Created by Vivek Gupta on 29/03/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

class CurrentLocationHeaderView: UITableViewHeaderFooterView, UIGestureRecognizerDelegate {
    var delegate: HeaderTappedDelegate?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.delegate = self
        addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        guard (sender.view as? CurrentLocationHeaderView) != nil else {
            return
        }
        delegate?.tapped()
    }
}
