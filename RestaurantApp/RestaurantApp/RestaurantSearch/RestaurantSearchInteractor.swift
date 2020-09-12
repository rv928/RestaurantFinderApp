//
//  RestaurantSerachInteractor.swift
//  RestaurantApp
//
//  Created by Ravi Vora on 12/9/2563 BE.
//  Copyright © 2563 Ravi Vora. All rights reserved.
//

import Foundation
import MapKit

protocol RestaurantSearchBusinessLogic {
    func findMatchingLocations(searchText: String, region: MKCoordinateRegion)
    func findMatchingAddress(selectedItem: MKPlacemark) -> String
}

final class RestaurantSearchInteractor: RestaurantSearchBusinessLogic {
    
    var presenter: RestaurantSearchPresenterInterface!
    var worker: RestaurantSearchWorkerInterface!
    
    init(presenter: RestaurantSearchPresenterInterface, worker:
        RestaurantSearchWorkerInterface = RestaurantSearchWorker(with: RestaurantSearchService())) {
        self.presenter = presenter
        self.worker = worker
    }
    
    func findMatchingLocations(searchText: String, region: MKCoordinateRegion) {
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = region
        let search = MKLocalSearch(request: request)
        
        search.start { response, _ in
            guard let response = response else {
                return
            }
            var matchingItems: [MKMapItem] = []
            matchingItems = response.mapItems
            self.presenter.presentMatchingLocations(mapItems: matchingItems)
        }
    }
    
    func parseAddress(selectedItem: MKPlacemark) -> String {
        
        let firstSpace = (selectedItem.subThoroughfare != nil &&
            selectedItem.thoroughfare != nil) ? " " : ""
        
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) &&
            (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        
        let secondSpace = (selectedItem.subAdministrativeArea != nil &&
            selectedItem.administrativeArea != nil) ? " " : ""
        
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
    
    func findMatchingAddress(selectedItem: MKPlacemark) -> String {
        let addressString: String = self.parseAddress(selectedItem: selectedItem)
        return addressString
    }
}
