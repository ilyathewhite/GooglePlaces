//
//  Place+MapKit.swift
//  GooglePlaces
//
//  Created by Ilya Belenkiy on 5/15/17.
//  Copyright © 2017 Ilya Belenkiy. All rights reserved.
//

import Foundation
import MapKit

extension Place {
   func region(forRadius miles: Double) -> MKCoordinateRegion {
      let loc = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
      let scalingFactor = abs(cos((2 * Double.pi) * latitude / 360.0))
      return MKCoordinateRegion(center: loc, span: MKCoordinateSpan(latitudeDelta: miles / 69.0, longitudeDelta: miles / (scalingFactor * 69.0)))
   }
   
   func annotation() -> MKPointAnnotation {
      let res = MKPointAnnotation()
      res.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
      res.title = name
      return res
   }
}
