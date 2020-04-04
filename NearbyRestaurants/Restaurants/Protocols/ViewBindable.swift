//
//  ViewBindable.swift
//  Restaurants
//
//  Created by Vivek Gupta on 29/03/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation

protocol ViewBindableProtocol {
    func getTitle() -> String
    func getSubtitle() -> String
    func getSubText() -> String?
}

extension ViewBindableProtocol {
    
    func getTitle() -> String {
        return ""
    }
    
    func getSubtitle() -> String {
        return ""
    }
    
    func getSubText() -> String? {
        return nil
    }
    
    func getRating() -> String {
        return ""
    }
    
    
    
}
