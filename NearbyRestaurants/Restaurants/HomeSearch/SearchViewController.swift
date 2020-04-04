//
//  SearchViewController.swift
//  Restaurants
//
//  Created by Vivek Gupta on 28/03/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit
import MapKit

protocol HeaderTappedDelegate {
    func tapped()
}

class SearchViewController: UIViewController {
    var resultSearchController:UISearchController? = nil
    @IBOutlet weak var tableView: UITableView!
    var viewModel = LocationSearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeLocationController()
        setSearchBar()
        setTableCells()
        setViewModelListener()
    }
    
    func initializeLocationController() {
        resultSearchController =
            UISearchController(searchResultsController: nil)
        resultSearchController?.searchResultsUpdater = self.viewModel
    }
    
    func setTableCells() {
        tableView.register(LocationTableViewCell.loadNib(), forCellReuseIdentifier: LocationTableViewCell.defaultReuseIdentifier)
        tableView.register(CurrentLocationHeaderView.loadNib(), forHeaderFooterViewReuseIdentifier: CurrentLocationHeaderView.defaultReuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setViewModelListener() {
        viewModel.onChange = { change in
            switch change {
            case .reload:
                self.tableView.reloadData()
            @unknown default:
                print(change)
            }
        }
    }
    
    func setSearchBar() {
        self.navigationItem.searchController = resultSearchController
        resultSearchController?.searchBar.tintColor = .white
        resultSearchController?.searchBar.tintColor = .white
        let textFieldInsideUISearchBar = resultSearchController?.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.textColor = UIColor.white
        textFieldInsideUISearchBar?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        textFieldInsideUISearchBar?.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        // SearchBar placeholder
        let textFieldInsideUISearchBarLabel = textFieldInsideUISearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideUISearchBarLabel?.textColor = UIColor.white
        textFieldInsideUISearchBarLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        resultSearchController?.dimsBackgroundDuringPresentation = false
        resultSearchController?.searchBar.placeholder = "Get nearby restaurants.."
        definesPresentationContext = true
        navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
}


extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let vw = tableView.dequeueReusableHeaderFooterView(withIdentifier: CurrentLocationHeaderView.defaultReuseIdentifier) as? CurrentLocationHeaderView {
            vw.delegate = self
            return vw
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let array = self.viewModel.places, array.count > 0 {
            return array.count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.defaultReuseIdentifier, for: indexPath) as? LocationTableViewCell {
            cell.viewBindableModel = self.viewModel.places?[indexPath.row]
            return cell
        }
        
        return UITableViewCell()
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = self.viewModel.state.locationArray[indexPath.row]
        self.viewModel.currentLocation = obj.placemark.location
        performSegue(withIdentifier: "LocationToRestaurant", sender: self.viewModel.currentLocation)
    }
}


extension SearchViewController: HeaderTappedDelegate {
    func tapped() {
        if viewModel.currentLocation == nil {
            viewModel.showGoToSettingsAlert()
            return
        }
        viewModel.locationManager.requestLocation()
        performSegue(withIdentifier: "LocationToRestaurant", sender: self.viewModel.currentLocation)
    }
}

