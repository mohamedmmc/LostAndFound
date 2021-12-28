//
//  GPSController.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 03/12/2021.
//

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces
class GPSController: UIViewController, CLLocationManagerDelegate,GMSMapViewDelegate {

    
//    var locationManager: CLLocationManager = CLLocationManager()
//    var mapView: GMSMapView = GMSMapView()
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var preciseLocationZoomLevel: Float = 17.0
    var approximateLocationZoomLevel: Float = 10.0
    var likelyPlaces: [GMSPlace] = []
    var positionGPSSaved = [Double]()
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    // The currently selected place.
    var selectedPlace: GMSPlace?
    override func viewDidLoad() {
       
        
        
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self

        placesClient = GMSPlacesClient.shared()
        // A default location to use when location permission is not granted.
        let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
        let lat = Double(-33.869405)
        let long = Double(151.199)
        positionGPSSaved.append(lat)
        positionGPSSaved.append(long)
        print("la pos maintenant est",positionGPSSaved)
        // Create a map.
        let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.indoorPicker = false
        mapView.delegate = self

        // Add the map to the view, hide it until we've got a location update.
        self.view.insertSubview(mapView, at: 0)
        }
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        mapView.clear()
    }
    
    @IBAction func addGPSLocationButton(_ sender: Any) {
        
       // performSegue(withIdentifier: "gpsValide", sender: positionGPSSaved)
        if let gpsLoc = presentingViewController as? AjouterArticleController{
            gpsLoc.gpsLocation = positionGPSSaved
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
      // Clear the map.
      mapView.clear()

      // Add a marker to the map.
      if let place = selectedPlace {
        let marker = GMSMarker(position: place.coordinate)
        marker.title = selectedPlace?.name
        marker.snippet = selectedPlace?.formattedAddress
        marker.map = mapView
      }

      listLikelyPlaces()
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
      print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        mapView.clear()
          let marker = GMSMarker(position: coordinate)
          marker.title = selectedPlace?.name
          marker.snippet = selectedPlace?.formattedAddress
          marker.map = mapView
        positionGPSSaved.removeAll()
        let lat = Double(coordinate.latitude)
        let long = Double(coordinate.longitude)
        positionGPSSaved.append(lat)
        positionGPSSaved.append(long)
        print("la pos maintenant est",positionGPSSaved)

    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//       if segue.identifier == "gpsValide" {
//         if let nextViewController = segue.destination as? AjouterArticleController {
//           nextViewController.gpsLocation = positionGPSSaved
//         }
//       }
//     }
    let geocoder = GMSGeocoder()

    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
      mapView.clear()
    }

    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
        geocoder.reverseGeocodeCoordinate(cameraPosition.target) { [self] (response, error) in
          guard error == nil else {
            return
          }

          if let result = response?.firstResult() {
            let marker = GMSMarker()
            marker.position = cameraPosition.target
            marker.title = result.lines?[0]
            marker.snippet = result.lines?[0]
            marker.map = mapView
            let lat = Double(cameraPosition.target.latitude)
            let long = Double(cameraPosition.target.longitude)
            positionGPSSaved.removeAll()
            self.positionGPSSaved.append(lat)
            self.positionGPSSaved.append(long)
            print("la pos maintenant est",positionGPSSaved)
          }
        }
      }
      
    // Populate the array with the list of likely places.
    func listLikelyPlaces() {
      // Clean up from previous sessions.
      likelyPlaces.removeAll()

      let placeFields: GMSPlaceField = [.name, .coordinate]
      placesClient.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: placeFields) { (placeLikelihoods, error) in
        guard error == nil else {
          // TODO: Handle the error.
          print("Current Place error: \(error!.localizedDescription)")
          return
        }

        guard let placeLikelihoods = placeLikelihoods else {
          print("No places found.")
          return
        }

        // Get likely places and add to the list.
        for likelihood in placeLikelihoods {
          let place = likelihood.place
          self.likelyPlaces.append(place)
        }
      }
    }
}

// Delegates to handle events for the location manager.
extension GPSController {

  // Handle incoming location events.
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location: CLLocation = locations.last!
    print("Location: \(location)")

    let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
    let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                          longitude: location.coordinate.longitude,
                                          zoom: zoomLevel)

    if mapView.isHidden {
      mapView.isHidden = false
      mapView.camera = camera
    } else {
      mapView.animate(to: camera)
    }

    listLikelyPlaces()
  }

  // Handle authorization for the location manager.
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    // Check accuracy authorization
    let accuracy = manager.accuracyAuthorization
    switch accuracy {
    case .fullAccuracy:
        print("Location accuracy is precise.")
    case .reducedAccuracy:
        print("Location accuracy is not precise.")
    @unknown default:
      fatalError()
    }

    // Handle authorization status
    switch status {
    case .restricted:
      print("Location access was restricted.")
    case .denied:
      print("User denied access to location.")
      // Display the map using the default location.
      mapView.isHidden = false
    case .notDetermined:
      print("Location status not determined.")
    case .authorizedAlways: fallthrough
    case .authorizedWhenInUse:
      print("Location status is OK.")
    @unknown default:
      fatalError()
    }
  }

  // Handle location manager errors.
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    locationManager.stopUpdatingLocation()
    print("Error: \(error)")
  }
}
      
extension ViewController: GMSAutocompleteResultsViewControllerDelegate {
  func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                         didAutocompleteWith place: GMSPlace) {
    //searchController?.isActive = false
    // Do something with the selected place.
    print("Place name: \(place.name)")
    print("Place address: \(place.formattedAddress)")
    print("Place attributions: \(place.attributions)")
  }

  func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                         didFailAutocompleteWithError error: Error){
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }

  func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }
}
