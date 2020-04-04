//
//  NibLoadable.swift
//  Restaurants
//
//  Created by Vivek Gupta on 29/03/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

protocol StoryBoardID: class {}

extension StoryBoardID where Self: UIViewController {
    static var storyBoardID: String {
        return String(describing: self)
    }
}

extension UIViewController: StoryBoardID {}

//---------------------------------------------------//

protocol NibLoadable {
    static var defaultNibName: String {get}
    static func loadNib() -> UINib
}

extension NibLoadable where Self: UIView {
    static var defaultNibName: String {
        return String(describing: self)
    }
    
    static func loadNib() -> UINib {
        return UINib(nibName: self.defaultNibName, bundle: nil)
    }

}



extension UIView: NibLoadable {
    
}

extension UITableViewCell {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewHeaderFooterView {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}
