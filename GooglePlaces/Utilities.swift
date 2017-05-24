//
//  Utilities.swift
//  GooglePlaces
//
//  Created by Ilya Belenkiy on 5/16/17.
//  Copyright © 2017 Ilya Belenkiy. All rights reserved.
//

import Foundation

enum GeneralError: Error {
   case noData(url: URL)
   case invalidData
   case callFailed
}

enum Result<T> {
   case success(T)
   case error(Error)
   
   func wrapped(or defaultValue: T) -> T {
      switch self {
      case .success(let value):
         return value
      case .error:
         return defaultValue
      }
   }
}
