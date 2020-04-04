//
//  HomeViewController.swift
//  Restaurants
//
//  Created by Vivek Gupta on 28/03/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit
import CoreLocation


class HomeViewController: SearchViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationItem.backBarButtonItem?.title = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LocationToRestaurant" {
            guard let vc = segue.destination as? RestaurantViewController, let loc = sender as? CLLocation else { return }
            vc.viewModel.currentLocation = loc
        }
    }
}

