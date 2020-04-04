//
//  LocationSearchViewModel.swift
//  Restaurants
//
//  Created by Vivek Gupta on 29/03/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation
import MapKit


protocol SearchViewModel {
    associatedtype T
    var state: SearchListState<T> { get }
    var onChange: ((SearchListState<T>.ChangeStateForList) -> Void)? { get set}
    func reloadData()
}

struct SearchListState<T> {
    fileprivate(set) var locationArray: [T] = []
}

extension SearchListState {
    enum ChangeStateForList {
        case fetching
        case reload
        case notFound
        case error
    }
    
    mutating func setArrayData(items: [T]) -> ChangeStateForList {
        self.locationArray = items
        return .reload
    }
}

class LocationSearchViewModel: NSObject, SearchViewModel {
    typealias T = MKMapItem
    fileprivate(set) var state = SearchListState<MKMapItem>()
    var currentLocation: CLLocation?
    var onChange: ((SearchListState<MKMapItem>.ChangeStateForList) -> Void)?
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        self.initializeLocation()
    }
    
    func initializeLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func reloadData() {
    }
    
    var places:[MKMapItem]? {
        didSet {
            self.onChange?(self.state.setArrayData(items: places ?? []))
        }
    }
    
    private var localSearch: MKLocalSearch? {
        willSet {
            // Clear the results and cancel the currently running local search before starting a new search.
            places = nil
            localSearch?.cancel()
        }
    }
}


extension LocationSearchViewModel: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else { return }
        var localRegion: MKCoordinateRegion
        let distance: CLLocationDistance = 1200
        guard let loc = self.currentLocation else {return}
        let currentLocation = loc.coordinate //CLLocationCoordinate2D.init(latitude: 19.428687519999993, longitude: 72.82373585999997)
        
        localRegion = MKCoordinateRegion(center: currentLocation, latitudinalMeters: distance, longitudinalMeters: distance)
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBarText
        searchRequest.region = localRegion
        localSearch = MKLocalSearch(request: searchRequest)
        localSearch?.start(completionHandler: { [weak self] (response, error) in
            guard let slf = self else {return}
            guard error == nil else {
                slf.displaySearchError(error)
                return
            }
            slf.places = response?.mapItems
        })
    }
    
    private func displaySearchError(_ error: Error?) {
        if let error = error as NSError?, let errorString = error.userInfo[NSLocalizedDescriptionKey] as? String {
            
            //
        }
    }
}

extension LocationSearchViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
            self.currentLocation = nil
            self.showGoToSettingsAlert()
        case .authorizedAlways, .authorizedWhenInUse, .notDetermined:
            locationManager.requestLocation()
        @unknown default:
            print("Unknown status")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.currentLocation = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error in getting location: \(error.localizedDescription)")
    }
    
    func showGoToSettingsAlert() {
        let alertView =  UIAlertController(title: "Could not find your location.", message: "Please go to iOS Settings > Privacy > Location to allow access to your location.", preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Settings" , style: UIAlertAction.Style.default, handler: { (_) in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: { (success) in
                })
            }
        })
        alertView.addAction(action)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (_) in
        })
        alertView.addAction(cancelAction)
        AppDelegate.shared.window?.rootViewController?.present(alertView, animated: true, completion: nil)
    }
}




