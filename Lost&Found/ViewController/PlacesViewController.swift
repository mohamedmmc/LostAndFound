//
//  PlacesViewController.swift
//  Lost&Found
//
//  Created by Mohanmed Melek Chtourou on 04/12/2021.
//

import Foundation
import UIKit
import GooglePlaces
import GoogleMaps
class PlacesViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    var likelyPlaces : [GMSPlace] = []
    var selectedPlace : GMSPlace?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "unwindToMain" {
         if let nextViewController = segue.destination as? GPSController {
           nextViewController.selectedPlace = selectedPlace
         }
       }
     }
   }

   // Respond when a user selects a place.
   extension PlacesViewController: UITableViewDelegate {
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       selectedPlace = likelyPlaces[indexPath.row]
       performSegue(withIdentifier: "unwindToMain", sender: self)
     }

     // Adjust cell height to only show the first five items in the table
     // (scrolling is disabled in IB).


     // Make table rows display at proper height if there are less than 5 items.
     func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       if (section == tableView.numberOfSections - 1) {
         return 1
       }
       return 0
     }
}
// Populate the table with the list of most likely places.
extension PlacesViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return likelyPlaces.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    let collectionItem = likelyPlaces[indexPath.row]

    cell.textLabel?.text = collectionItem.name

    return cell
  }
}
      
