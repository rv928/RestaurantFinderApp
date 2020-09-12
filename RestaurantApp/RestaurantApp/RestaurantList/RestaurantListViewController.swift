//
//  RestaurantListViewController.swift
//  RestaurantApp
//
//  Created by Ravi Vora on 9/9/2563 BE.
//  Copyright © 2563 Ravi Vora. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch: class {
    func dropPinZoomIn(placemark: MKPlacemark)
}


protocol RestaurantListView {
    func displayLocationList()
    func showLoading()
    func hideLoading()
    func showAlertError()
}

class RestaurantListViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var resultSearchController: UISearchController!
    var selectedPin: MKPlacemark?
    let locationManager = CLLocationManager()
    
    var interactor: RestaurantListBusinessLogic!
    var router: RestaurantListRouterInterface!
    
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
    
    init(interatcor: RestaurantListBusinessLogic? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.interactor = interatcor
    }
    
    // MARK: - Setup
    private func setup() {
        let router = RestaurantListRouter()
        router.viewController = self
        
        let presenter = RestaurantListPresenter(viewController: self)
        presenter.restaurantListView = self
        
        let interactor = RestaurantListInteractor(presenter: presenter)
        interactor.presenter = presenter
        
        self.interactor = interactor
        self.router = router
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Tools.shared.hasConnectivity() == false {
            Tools.shared.alert(sMessage: internetMsg, handler: nil)
        } else {
            loadLocationManager()
            loadSearchController()
        }
    }
    
    func loadSearchController() {
        self.mapView.delegate = self
        self.mapView.accessibilityIdentifier = "mapView--restaurantMapView"
        self.interactor.fetchLocationList()
    }
    
    func loadLocationManager() {
        let locationManager = UserLocationManager.sharedManager
        locationManager.delegate = self
    }
    
    @objc func getDirections() {
        guard let selectedPin = selectedPin else { return }
        let mapItem = MKMapItem(placemark: selectedPin)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
}



// UserLocationManager Delegate Methods

extension RestaurantListViewController: UserLocationManagerDelegate {
    
    func locationdidUpdateToLocation(location: CLLocation) {
        print("location updated")
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}


// RestaurantSearchController Delegate Methods

extension RestaurantListViewController: HandleMapSearch {
    
    func dropPinZoomIn(placemark: MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}

// MKMapView Delegate Methods

extension RestaurantListViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        pinView?.accessibilityIdentifier = "mkPinAnnotationView--pinView"
        pinView?.pinTintColor = UIColor.black
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: .zero, size: smallSquare))
        button.accessibilityIdentifier = "mkPinAnnotationView--pinButton"
        button.setBackgroundImage(UIImage(named: UIConstant.Images.locationPinIcon), for: .normal)
        button.addTarget(self, action: #selector(self.getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
}


extension RestaurantListViewController: RestaurantListView {
    
    func displayLocationList() {
        let searchTableView = self.storyboard?.instantiateViewController(identifier: "RestaurantSerachViewController") as! RestaurantSearchViewController
        resultSearchController = UISearchController(searchResultsController: searchTableView)
        resultSearchController.searchResultsUpdater = searchTableView
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search nearby restaurants"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        searchTableView.mapView = mapView
        searchTableView.handleMapSearchDelegate = self
    }
    
    func showLoading() {
        
    }
    
    func hideLoading() {
        
    }
    
    func showAlertError() {
        
    }
}
