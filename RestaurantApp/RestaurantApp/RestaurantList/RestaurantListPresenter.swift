//
//  RestaurantListPresenter.swift
//  RestaurantApp
//
//  Created by Ravi Vora on 9/9/2563 BE.
//  Copyright © 2563 Ravi Vora. All rights reserved.
//

import Foundation

protocol RestaurantListPresenterInterface {
    func displayLocationList()
    func showLoading()
    func hideLoading()
    func showAlertError()
}

class RestaurantListPresenter: RestaurantListPresenterInterface {
    
    var restaurantListView: RestaurantListView!
    
    init(viewController: RestaurantListView) {
        self.restaurantListView = viewController
    }
    
    func displayLocationList() {
        self.restaurantListView.displayLocationList()
    }
    
    func showLoading() {
        self.restaurantListView.showLoading()
    }
    
    func hideLoading() {
        self.restaurantListView.hideLoading()
    }
    
    func showAlertError() {
        self.restaurantListView.showAlertError()
    }
}
