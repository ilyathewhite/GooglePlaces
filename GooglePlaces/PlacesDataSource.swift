//
//  PlacesDataSource.swift
//  GooglePlaces
//
//  Created by Ilya Belenkiy on 4/28/17.
//  Copyright © 2017 Ilya Belenkiy. All rights reserved.
//

import UIKit

protocol PlacesDataSourceDelegate: class {
   func didFinishSearch(dataSource: PlacesDataSource)
}

class PlacesDataSource: NSObject, UITableViewDataSource {
   enum Cell {
      case place

      var identifier: String {
         switch self {
         case .place: return "PlaceCell"
         }
      }
      
      var nib: UINib {
         switch self {
         case .place: return UINib(nibName: "PlaceCell", bundle: nil)
         }
      }
      
      var all: [Cell] {
         return [.place]
      }
   }
   
   weak var delegate: PlacesDataSourceDelegate?
   private var places: [Place] = []
   
   func place(at indexPath: IndexPath) -> Place {
      return places[indexPath.row]
   }
   
   func registerCells(for tableView: UITableView) {
      for cell in Cell.place.all {
         tableView.register(cell.nib, forCellReuseIdentifier: cell.identifier)
      }
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return places.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: Cell.place.identifier) as! PlaceCell
      cell.configure(with: place(at: indexPath))
      return cell
   }
   
   func search(query: String) {
      PlacesAPI.getPlaces(query) {  [weak self] result in
         guard let me = self else { return }
         
         switch result {
         case .success(let newPlaces):
            me.places = newPlaces
            
         case .error(let error):
            print(error)
            me.places = []
         }
         
         me.delegate?.didFinishSearch(dataSource: me)
      }
   }
}
