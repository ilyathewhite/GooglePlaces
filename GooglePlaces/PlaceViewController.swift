//
//  PlaceViewController.swift
//  GooglePlaces
//
//  Created by Ilya Belenkiy on 5/15/17.
//  Copyright © 2017 Ilya Belenkiy. All rights reserved.
//

import UIKit
import MapKit

class PlaceViewController: UIViewController {
   var place: Place? {
      didSet {
         setLocationAndPin()
      }
   }
   
   func setLocationAndPin(animated: Bool = false) {
      guard isViewLoaded else { return }
      guard let place = place else { return }
      mapView.setRegion(place.region(forRadius: 0.5), animated: animated)
      mapView.addAnnotation(place.annotation())
   }
   
   @IBOutlet var mapView: MKMapView!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setLocationAndPin()
   }
}
