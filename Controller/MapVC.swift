//
//  MapVC.swift
//  FrancalanciaNick_Leasify
//
//  Created by Nicholas on 4/28/21.
//
//  Email : nfrancal@usc.edu

import Foundation
import UIKit
// Google Maps API and Google Places APIs provided by: https://developers.google.com/maps/documentation/ios-sdk/start
import GoogleMaps
import GooglePlaces


class MapVC : UIViewController, GMSAutocompleteResultsViewControllerDelegate{
    
    // variables for the map page and map view
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var camera : GMSCameraPosition?
    var mapView : GMSMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // position the camera so that it is hovering outside of USC campus
        camera = GMSCameraPosition.camera(withLatitude: 34.0224, longitude: -118.2851, zoom: 15.0)
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera!)
        mapView!.isMyLocationEnabled = true
        mapView!.settings.compassButton = true
        mapView!.settings.zoomGestures = true
        self.view.addSubview(mapView!)
        mapView?.settings.myLocationButton = true
        mapView?.isMyLocationEnabled = true

        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 34.0224, longitude: -118.2851)
        marker.title = "USC Campus"
        marker.snippet = "Fight On!"
        marker.map = mapView
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
        
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        mapView?.animate(to: GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15.0))
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        if let place = place.formattedAddress {
            marker.title = place
        }
        marker.map = mapView

    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
           print("Error: ", error.localizedDescription)
    }
}
