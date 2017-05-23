//
//  PlacesModel.swift
//  GooglePlaces
//
//  Created by Ilya Belenkiy on 5/20/17.
//  Copyright © 2017 Ilya Belenkiy. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxSwiftExt

class PlacesModel {
   public var disposeBag = DisposeBag()
   
   public var places: Driver<Result<[Place]>>
   public var placesArray: Driver<[Place]>
   
   init(querySource: Observable<String?>) {
      places = querySource
         .debounce(0.5, scheduler: MainScheduler.instance)
         .unwrap()
         .filter { !$0.isEmpty }
         .map { query -> URL? in
            guard let queryArg = query.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else { return nil }
            let googlePlacesKey = ""
            return URL(string: "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(queryArg)&sensor=false&key=\(googlePlacesKey)")
         }
         .unwrap()
         .flatMap { (url: URL) in URLSession.shared.rx.json(url: url) }
         .map { (json: Any) -> Result<[Place]> in Place.getPlaces(from: json as! JSONDict) }
         .asDriver(onErrorJustReturn: .error(GeneralError.invalidData))
      
      placesArray = places
         .map { result in result.wrapped(or: []) }
   }
}

extension Place {
   private struct Geometry {
      struct Location {
         let latitude: Double
         let longitude: Double
         
         init(json: JSONDict) throws {
            latitude = try json.get(key: "lat")
            longitude = try json.get(key: "lng")
         }
      }
      
      let location: Location
      
      init(json: JSONDict) throws {
         location = try Location(json: json.get(key: "location"))
      }
   }
   
   private init(json: JSONDict) throws {
      let geometry: Geometry = try Geometry(json: json.get(key: "geometry"))
      latitude = geometry.location.latitude
      longitude = geometry.location.longitude
      address = try json.get(key: "formatted_address")
      name = try json.get(key: "name")
   }
   
   static func getPlaces(from json: JSONDict) throws -> [Place] {
      let content: [JSONDict] = try json.get(key: "results")
      return try content.map(Place.init)
   }
   
   static func getPlaces(from json: JSONDict) -> Result<[Place]> {
      do {
         return try .success(Place.getPlaces(from: json))
      }
      catch {
         return .error(error)
      }
   }
}
