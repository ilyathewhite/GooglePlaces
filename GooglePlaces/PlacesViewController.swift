//
//  PlacesViewController.swift
//  GooglePlaces
//
//  Created by Ilya Belenkiy on 4/28/17.
//  Copyright © 2017 Ilya Belenkiy. All rights reserved.
//

import UIKit

class PlacesViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, PlacesDataSourceDelegate {
   var searchController : UISearchController!
   @IBOutlet var tableView: UITableView!
   
   private var dataSource = PlacesDataSource()
   private var timer = Timer()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      configureSearchBar()
      configureTableView()
      
      dataSource.delegate = self
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
      searchController.searchBar.delegate = self
      navigationItem.titleView = searchController.searchBar
   }
   
   private func configureTableView() {
      tableView.dataSource = dataSource
      dataSource.registerCells(for: tableView)

      tableView.delegate = self
      
      tableView.rowHeight = UITableViewAutomaticDimension
      tableView.estimatedRowHeight = 100
   }
   
   // UISearchBarDelegate
   
   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      guard !searchText.isEmpty else { return }
      
      timer.invalidate()
      timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] timer in
         self?.dataSource.search(query: searchText)
      }
   }
   
   // UITableViewDelegate
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let vc = PlaceViewController()
      vc.place = dataSource.place(at: indexPath)
      navigationController?.pushViewController(vc, animated: true)
   }
   
   // PlacesDataSourceDelegate
   
   func didFinishSearch(dataSource: PlacesDataSource) {
      tableView.reloadData()
   }
}
