//
//  ZomatoViewModel.swift
//  Restaurants
//
//  Created by Vivek Gupta on 29/03/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit
import CoreLocation

class ZomatoViewModel: NSObject {
    typealias T = RestaurantElement
    fileprivate(set) var state = RestaurantListState<RestaurantElement>()
    var currentLocation: CLLocation?
    var onChange: ((RestaurantListState<RestaurantElement>.ChangeStateForRestaurant) -> Void)?
    
    func reloadData() {
        state.update(page: .default)
        fetchFromNetwork(completion: {[weak self] array in
            guard let slf = self else {return}
            slf.onChange?(slf.state.reload(rest: array))
        })
    }
    
    func loadMoreReataurants(offset: Int) {
        guard state.page.hasNextPage else {return}
        fetchFromNetwork(offset: offset, completion: {[weak self] array in
            guard let slf = self else {return}
            slf.onChange?(slf.state.insert(rest: array))
        })
    }
    
    func fetchFromNetwork(offset: Int = 0, completion: @escaping ([RestaurantElement]) -> Void) {
        guard let loc = self.currentLocation else {return}
        let lat = "\(String(describing: loc.coordinate.latitude))"
        let lon = "\(String(describing: loc.coordinate.longitude))"
        let off = "\(offset)"
        let dict = ["count": "100", "lat": lat, "lon": lon, "radius": "1200", "sort": "real_distance", "order": "asc", "start": off]
        ApiManager.shared.fetchRestaurants(from: .search, query: dict) {[weak self] (result) in
            guard let slf = self else {return}
            switch result {
            case .success(let data):
                print(data)
                guard let array = data.restaurants else {return}
                var total = 0
                var offset = 0
                var itemsFound = 0
                if let tl = data.resultsFound {
                    total = tl
                }
                if let start = data.resultsStart, let shown = data.resultsShown {
                    offset = start + shown
                    itemsFound = shown
                }
                let page = PageInfo(offsetStart: offset, fetchedItems: itemsFound, total: total)
                slf.state.update(page: page)
                DispatchQueue.main.async {
                    completion(array)
                }
            case .failure(let failedData):
                print(failedData.localizedDescription)
            }
        }
    }
}

extension ZomatoViewModel: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.state.restaurantArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantTableViewCell.defaultReuseIdentifier, for: indexPath) as? RestaurantTableViewCell {
            let model = self.state.restaurantArray[indexPath.row]
            cell.viewBindableModel = model
            cell.setRating(val: model.getRating())
            cell.setImage(link: model.getImageUrl())
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.state.page.hasNextPage {
            if indexPath.row == self.state.restaurantArray.count - 5 {
                self.loadMoreReataurants(offset: self.state.page.offset)
            }
        }
    }
}



struct RestaurantListState<T> {
    fileprivate(set) var restaurantArray: [T] = []
    fileprivate(set) var page = PageInfo.default
    fileprivate(set) var isFetching = false
}

extension RestaurantListState {
    enum ChangeStateForRestaurant {
        case none
        case fetchStateChanged
        case error
        case modelArrayChanged(CollectionChange)
        case searching
    }
    
    mutating func setFetching(fetching: Bool) -> ChangeStateForRestaurant {
        self.isFetching = fetching
        return .fetchStateChanged
    }
    
    mutating func reload(rest: [T]) -> ChangeStateForRestaurant {
        self.restaurantArray = rest
        return .modelArrayChanged(.reload)
    }
    
    mutating func insert(rest: [T]) -> ChangeStateForRestaurant {
        let index = self.restaurantArray.count
        self.restaurantArray.append(contentsOf: rest)
        let range = IndexSet(integersIn: index..<self.restaurantArray.count)
        return .modelArrayChanged(.insertion(range))
    }
    
    mutating func update(page: PageInfo) {
        self.page = page
        print("==> currentPage fetched \(self.page.currentFetchedItems)")
    }
    
}
