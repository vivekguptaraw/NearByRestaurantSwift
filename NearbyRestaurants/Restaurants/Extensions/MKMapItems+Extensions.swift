//
//  MKMapItems+Extensions.swift
//  Restaurants
//
//  Created by Vivek Gupta on 29/03/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation
import MapKit
import Contacts

extension MKMapItem: ViewBindableProtocol {
    func getTitle() -> String {
        return self.name ?? ""
    }
    
    func getSubText() -> String? {
        return self.placemark.formattedAddress ?? ""
    }
    
    func getSubtitle() -> String {
        return ""
    }
}

extension MKPlacemark {
    var formattedAddress: String? {
        guard let postalAddress = postalAddress else { return nil }
        return CNPostalAddressFormatter.string(from: postalAddress, style: .mailingAddress).replacingOccurrences(of: "\n", with: " ")
    }
}
