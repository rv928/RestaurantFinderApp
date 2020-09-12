//
//  RestaurantSerachViewController.swift
//  RestaurantApp
//
//  Created by Ravi Vora on 9/9/2563 BE.
//  Copyright © 2563 Ravi Vora. All rights reserved.
//

import UIKit
import MapKit

protocol RestaurantSearchView {
    func displayMatchingLocations(mapItems: [MKMapItem])
}

class RestaurantSearchViewController: UITableViewController {
    
    weak var handleMapSearchDelegate: HandleMapSearch?
    var matchingItems: [MKMapItem] = []
    var mapView: MKMapView?
    
    var interactor: RestaurantSearchBusinessLogic!
    var router: RestaurantSearchRouterInterface!
    
    // MARK: - Initializers
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil:
        Bundle?) {
        super.init(nibName: nibNameOrNil, bundle:nibBundleOrNil)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    init(interatcor: RestaurantSearchBusinessLogic? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.interactor = interatcor
    }
    
    // MARK: - Setup
    private func setup() {
        let router = RestaurantSearchRouter()
        router.viewController = self
        
        let presenter = RestaurantSearchPresenter(viewController: self)
        presenter.restaurantSearchView = self
        
        let interactor = RestaurantSearchInteractor(presenter: presenter)
        interactor.presenter = presenter
        
        self.interactor = interactor
        self.router = router
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        setUpTableView()
    }
    
    func setUpTableView() {
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 60
        
        self.tableView.register(UINib(nibName: "RestaurantSearchCell", bundle: nil), forCellReuseIdentifier: "RestaurantSearchCell")
        self.tableView.separatorInset = .zero
        self.tableView.layoutMargins = .zero
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.accessibilityIdentifier = "tableView--restaurantSearchTableView"
    }
}

// UISearchController Delegate Methods

extension RestaurantSearchViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView,
            let searchBarText = searchController.searchBar.text else { return }
        self.interactor.findMatchingLocations(searchText: searchBarText, region: mapView.region)
    }
}

// UITableView DataSource Methods

extension RestaurantSearchViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantSearchCell", for: indexPath) as? RestaurantSearchCell {
            cell.accessibilityIdentifier = "RestaurantSearchCell\(indexPath.row)"
            let selectedItem = matchingItems[indexPath.row].placemark
            cell.titleLabel?.text = selectedItem.name
            cell.subtitleLabel?.text = self.interactor.findMatchingAddress(selectedItem: selectedItem)
            return cell
        }
        return UITableViewCell()
    }
}

// UITableView Delegate Methods

extension RestaurantSearchViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        dismiss(animated: true, completion: nil)
    }
}

extension RestaurantSearchViewController: RestaurantSearchView {
    
    func displayMatchingLocations(mapItems: [MKMapItem]) {
        self.matchingItems = mapItems
        self.tableView.reloadData()
    }
}
