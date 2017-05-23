//
//  PlacesViewController.swift
//  GooglePlaces
//
//  Created by Ilya Belenkiy on 4/28/17.
//  Copyright © 2017 Ilya Belenkiy. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class PlacesViewController: UIViewController {
   var searchController : UISearchController!
   @IBOutlet var tableView: UITableView!
   
   var placesModel: PlacesModel!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      configureSearchBar()
      configureTableView()
      
      placesModel = PlacesModel(querySource: searchController.searchBar.rx.text.asObservable())
      
      placesModel.placesArray
         .drive(tableView.rx.items(cellIdentifier: placeCellIdentifier, cellType: PlaceCell.self)) { (row, place, cell) in
            cell.configure(with: place)
         }
         .disposed(by: placesModel.disposeBag)
      
      tableView.rx.modelSelected(Place.self)
         .subscribe(
            onNext: { [unowned self] place in
               let vc = PlaceViewController()
               vc.place = place
               self.navigationController?.pushViewController(vc, animated: true)
            }
         )
         .disposed(by: placesModel.disposeBag)
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
      tableView.deselectRow(at: selectedIndexPath, animated: true)
   }
   
   private func configureSearchBar() {
      searchController = UISearchController(searchResultsController:  nil)
      searchController.hidesNavigationBarDuringPresentation = false
      searchController.dimsBackgroundDuringPresentation = false
      navigationItem.titleView = searchController.searchBar
   }
   
   private func configureTableView() {
      tableView.rowHeight = UITableViewAutomaticDimension
      tableView.estimatedRowHeight = 100
      
      tableView.register(UINib(nibName: placeCellIdentifier, bundle: nil), forCellReuseIdentifier: placeCellIdentifier)
   }
   
   private let placeCellIdentifier = "PlaceCell"
}
