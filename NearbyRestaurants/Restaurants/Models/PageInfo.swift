//
//  PageInfo.swift
//  Restaurants
//
//  Created by Vivek Gupta on 29/03/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation


struct PageInfo {
    
    static let `default` = PageInfo(offsetStart: 0, fetchedItems: 0, total: 0)
    
    fileprivate(set) var currentFetchedItems: Int
    fileprivate(set) var totalItems: Int
    fileprivate(set) var offset: Int
    
    
    var hasNextPage: Bool {
        return currentFetchedItems + offset < totalItems
    }
    
    init(offsetStart: Int, fetchedItems: Int, total: Int) {
        offset = offsetStart
        currentFetchedItems = fetchedItems
        totalItems = total
    }
    
    func getNextPage() -> Int {
        return currentFetchedItems + offset
    }
    
}
