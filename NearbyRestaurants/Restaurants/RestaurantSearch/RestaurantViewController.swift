//
//  RestaurantViewController.swift
//  Restaurants
//
//  Created by Vivek Gupta on 29/03/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit
import CoreLocation

class RestaurantViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ZomatoViewModel = ZomatoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Nearby Restaurants"
        fetchRestaurants()
        self.setListener()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationItem.setLeftBarButton(UIBarButtonItem(image: UIImage(named: "arrowPng"), style: .plain, target: self, action: #selector(backClicked)), animated: true)
        navigationItem.leftBarButtonItem?.tintColor = .white
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = .clear
//        self.navigationController?.navigationBar.barStyle = .blackTranslucent
//        
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.navigationBar.backgroundColor = .clear
        
    }
    
    @objc func backClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func fetchRestaurants() {
        tableView.register(RestaurantTableViewCell.loadNib(), forCellReuseIdentifier: RestaurantTableViewCell.defaultReuseIdentifier)
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
        tableView.separatorStyle = .none
        viewModel.reloadData()
    }
    
    func setListener() {
        self.viewModel.onChange = { change in
            switch change {
            case .fetchStateChanged:
                print("Fetching")
            case .modelArrayChanged(let collectionChange):
                switch collectionChange {
                case .reload:
                    self.tableView.reloadData()
                default:
                   self.tableView.beginUpdates()
                   self.tableView.applyCollectionChange(collectionChange, toSection: 0, withAnimation: .fade)
                   self.tableView.endUpdates()
                }
            default:
                print("Unknown Case")
            }
            
        }
    }
}
