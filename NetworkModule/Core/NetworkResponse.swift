//
//  NetworkResponse.swift
//  NetworkModule
//
//  Created by Göksel Köksal on 25.11.2018.
//  Copyright © 2018 Adaptics. All rights reserved.
//

import Foundation

public class NetworkResponse<Model> {
  
  public let request: URLRequest?
  public let response: HTTPURLResponse?
  public let data: Data?
  public let result: GenericResult<Model>
  
  public init(request: URLRequest?, response: HTTPURLResponse?, data: Data?, result: GenericResult<Model>) {
    self.request = request
    self.response = response
    self.data = data
    self.result = result
  }
}

public extension NetworkResponse {
  
  public func updatingResult<Model>(_ result: GenericResult<Model>) -> NetworkResponse<Model> {
    return NetworkResponse<Model>(request: request, response: response, data: data, result: result)
  }
}
