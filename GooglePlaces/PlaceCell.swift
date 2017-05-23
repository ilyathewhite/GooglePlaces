//
//  PlaceCell.swift
//  GooglePlaces
//
//  Created by Ilya Belenkiy on 4/28/17.
//  Copyright © 2017 Ilya Belenkiy. All rights reserved.
//

import UIKit

class PlaceCell :UITableViewCell {
   @IBOutlet var nameLabel: UILabel!
   @IBOutlet var addressLabel: UILabel!
}

extension PlaceCell {
   func configure(with place: Place) {
      nameLabel.text = place.name
      addressLabel.text = place.address
   }
}
