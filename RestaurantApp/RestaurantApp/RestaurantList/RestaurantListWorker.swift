//
//  RestaurantListWorker.swift
//  RestaurantApp
//
//  Created by Ravi Vora on 9/9/2563 BE.
//  Copyright © 2563 Ravi Vora. All rights reserved.
//

import Foundation

protocol RestaurantListWorkerInterface {}

final class RestaurantListWorker: RestaurantListWorkerInterface {
    
    var service: RestaurantListService!
    
    init(with aService: RestaurantListService) {
        service = aService
    }
}
