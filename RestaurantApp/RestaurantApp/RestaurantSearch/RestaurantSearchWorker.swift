//
//  RestaurantSerachWorker.swift
//  RestaurantApp
//
//  Created by Ravi Vora on 12/9/2563 BE.
//  Copyright © 2563 Ravi Vora. All rights reserved.
//

import Foundation

protocol RestaurantSearchWorkerInterface {}

final class RestaurantSearchWorker: RestaurantSearchWorkerInterface {
    
    var service: RestaurantSearchService!
    
    init(with aService: RestaurantSearchService) {
        service = aService
    }
}
