//
//  LocationPickerVC.swift
//  WeatherForcast
//
//  Created by Pratipalsinh on 05/11/18.
//  Copyright © 2018 Pratipalsinh Jadeja. All rights reserved.
//

import GoogleMaps
import GooglePlaces
import UIKit

protocol LocationPickerDelegate {
    func selectedCity(coordinate:CLLocationCoordinate2D)
}

class LocationPickerVC: UIViewController {
    
    @IBOutlet var addressLabel:UILabel!
    @IBOutlet var googleMapView:GMSMapView!
    @IBOutlet var viewAddressContainer:UIView!
    @IBOutlet var buttonSetAddress:UIButton!
    var selectedCoordinates = CLLocationCoordinate2D(latitude: 23.0225, longitude: 72.5714)
    var delegate: LocationPickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select City"
        
        self.setupMapwith(location: self.selectedCoordinates)
        let searchButton =  Helper.barButtonItem(selector: #selector(self.searchBtnTapped(_:)), controller: self, image: UIImage(named: "search")!)
        self.navigationItem.rightBarButtonItem = searchButton
    }
    
    func setupMapwith(location: CLLocationCoordinate2D){
        self.googleMapView.delegate = self
        self.googleMapView.isMyLocationEnabled = true
        self.googleMapView.settings.myLocationButton = true
        if location.latitude != 0.0 && location.longitude != 0.0 {
            self.googleMapView.camera = GMSCameraPosition(target: location, zoom: 7, bearing: 0, viewingAngle: 0)
        }
    }
    
    func reverGeoCoding(latitude: Double, longitude: Double){
        let latitude: Double = latitude
        let longitude: Double = longitude
        let addressCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        let coder = GMSGeocoder()
        
        coder.reverseGeocodeCoordinate(addressCoordinates, completionHandler: { results, error in
            if error != nil {
                
            } else {
                guard let addressResults = results, let firstResult = addressResults.firstResult()  else {
                    return
                }
                let address  = firstResult
                self.addressLabel.text = address.locality
                self.selectedCoordinates = addressCoordinates
            }
        })
    }
    
    @IBAction func searchBtnTapped(_ sender: UIButton!){
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        self.present(acController, animated: true)
    }
    
    @IBAction func selectAddressTapped(_ sender: UIButton!){
        if selectedCoordinates.latitude != 0.0 && selectedCoordinates.longitude != 0.0{
            self.dismiss(animated: true) {
                self.delegate?.selectedCity(coordinate: self.selectedCoordinates)
            }
        }
        else {
            self.showBanner(title: "Select City", message: "Please select valid location", theme: .error, position: .center)
        }
    }
    
}

extension LocationPickerVC: GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        self.reverGeoCoding(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        
        self.googleMapView.camera = GMSCameraPosition(target: place.coordinate, zoom: 7, bearing: 0, viewingAngle: 0)
        
        self.dismiss(animated: true)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let coordinate = mapView.camera.target
        self.reverGeoCoding(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}

