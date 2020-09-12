//
//  RestaurantSerachPresenter.swift
//  RestaurantApp
//
//  Created by Ravi Vora on 12/9/2563 BE.
//  Copyright © 2563 Ravi Vora. All rights reserved.
//

import Foundation
import MapKit

protocol RestaurantSearchPresenterInterface {
    func presentMatchingLocations(mapItems: [MKMapItem])
}

class RestaurantSearchPresenter: RestaurantSearchPresenterInterface {
    
    var restaurantSearchView: RestaurantSearchView!
    
    init(viewController: RestaurantSearchView) {
        self.restaurantSearchView = viewController
    }
    
    func presentMatchingLocations(mapItems: [MKMapItem]) {
        self.restaurantSearchView.displayMatchingLocations(mapItems: mapItems)
    }
}
