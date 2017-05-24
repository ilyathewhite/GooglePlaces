//
//  PlacesAPI.swift
//  GooglePlaces
//
//  Created by Ilya Belenkiy on 4/28/17.
//  Copyright © 2017 Ilya Belenkiy. All rights reserved.
//

import Foundation

fileprivate extension Place {
   struct Geometry {
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
   
   init(json: JSONDict) throws {
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
}

protocol PlacesAPIProtocol {
   func getPlaces(_ completion: @escaping (Result<[Place]>) -> ())
}

class PlacesAPI {
   private static var latestTask: URLSessionDataTask?
   static func getPlaces(_ query: String, _ completion: @escaping (Result<[Place]>) -> ()) {
      latestTask?.cancel()
      
      guard let queryArg = query.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
         return completion(.error(GeneralError.callFailed))
      }
      
      let googlePlacesKey = ""
      guard let url = URL(string: "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(queryArg)&sensor=false&key=\(googlePlacesKey)") else {
         return completion(.error(GeneralError.callFailed))
      }
      
      let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
         func finish(_ result: Result<[Place]>) {
            DispatchQueue.main.async {
               completion(result)
            }
         }
         
         if let error = error {
            if (error as NSError).code == NSURLErrorCancelled {
               return
            }
            else {
               return finish(.error(error))
            }
         }
         
         guard let data = data else {
            return finish(.error(GeneralError.noData(url: url)))
         }
         
         guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) else {
            return finish(.error(GeneralError.invalidData))
         }
         
         guard let jsonDict = jsonData as? JSONDict else {
            return finish(.error(GeneralError.invalidData))
         }
         
         do {
            finish(.success(try Place.getPlaces(from: jsonDict)))
         }
         catch {
            finish(.error(error))
         }
      }
      
      latestTask = task
      task.resume()
   }
}
