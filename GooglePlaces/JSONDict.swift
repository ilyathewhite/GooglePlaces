//
//  JSONDict.swift
//  GooglePlaces
//
//  Created by Ilya Belenkiy on 5/16/17.
//  Copyright © 2017 Ilya Belenkiy. All rights reserved.
//

import Foundation

typealias JSONDict = Dictionary<String, Any>

enum JSONDictError: Error {
   case missingKey(String)
   case conversionFailure(value: Any)
}

extension Dictionary where Key == String {
   func get<T>(key: Key) throws -> T {
      guard let res = self[key] else { throw JSONDictError.missingKey(key) }
      guard let converted = res as? T else { throw JSONDictError.conversionFailure(value: res) }
      return converted
   }
   
   func maybeGet<T>(key: Key) throws -> T? {
      guard let res = self[key] else { return nil }
      guard let converted = res as? T else { throw JSONDictError.conversionFailure(value: res) }
      return converted
   }
}
