//
//  RestaurantListInteractor.swift
//  RestaurantApp
//
//  Created by Ravi Vora on 9/9/2563 BE.
//  Copyright © 2563 Ravi Vora. All rights reserved.
//

import Foundation

protocol RestaurantListBusinessLogic {
    func fetchLocationList()
    func showLoading()
}

final class RestaurantListInteractor: RestaurantListBusinessLogic {
    
    var presenter: RestaurantListPresenterInterface!
    var worker: RestaurantListWorkerInterface!
    
    init(presenter: RestaurantListPresenterInterface, worker:
        RestaurantListWorkerInterface = RestaurantListWorker(with: RestaurantListService())) {
        self.presenter = presenter
        self.worker = worker
    }
    
    func fetchLocationList() {
        self.presenter.displayLocationList()
    }
    
    func showLoading() {
        self.presenter.showLoading()
    }
}
