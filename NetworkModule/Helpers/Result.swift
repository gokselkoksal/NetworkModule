//
//  Result.swift
//  NetworkModule
//
//  Created by Göksel Köksal on 25.11.2018.
//  Copyright © 2018 GK. All rights reserved.
//

import Foundation

public enum GenericResult<Value> {
  case success(Value)
  case failure(Error)
}

public extension GenericResult {
  
  public var isSuccess: Bool {
    switch self {
    case .success(_):
      return true
    case .failure(_):
      return false
    }
  }
  
  public var value: Value? {
    switch self {
    case .success(let value):
      return value
    case .failure(_):
      return nil
    }
  }
  
  public var error: Error? {
    switch self {
    case .success(_):
      return nil
    case .failure(let error):
      return error
    }
  }
}

public extension GenericResult {
  
  public func map<T>(_ transform: (Value) -> T) -> GenericResult<T> {
    switch self {
    case .success(let value):
      let newValue = transform(value)
      return GenericResult<T>.success(newValue)
    case .failure(let error):
      return GenericResult<T>.failure(error)
    }
  }
  
  public func flatMap<T>(_ transform: (Value) -> GenericResult<T>) -> GenericResult<T> {
    switch self {
    case .success(let value):
      return transform(value)
    case .failure(let error):
      return GenericResult<T>.failure(error)
    }
  }
}

public extension GenericResult where Value == Void {
  static var success: GenericResult<Void> = GenericResult<Void>.success(())
}
