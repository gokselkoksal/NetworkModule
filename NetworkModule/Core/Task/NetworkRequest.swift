//
//  NetworkRequest.swift
//  NetworkModule
//
//  Created by Göksel Köksal on 25.11.2018.
//  Copyright © 2018 Adaptics. All rights reserved.
//

import Foundation

public class NetworkRequest {
  
  public let baseURL: URL
  public let path: String
  public let method: HTTPMethod
  public let operationType: NetworkOperationType
  public let headers: [String: String]?
  
  public init(baseURL: URL,
              path: String,
              method: HTTPMethod,
              operationType: NetworkOperationType,
              headers: [String: String]?)
  {
    self.baseURL = baseURL
    self.path = path
    self.method = method
    self.operationType = operationType
    self.headers = headers
  }
}

// MARK: - Network operation types

public enum NetworkOperationType {
  case plainRequest
  case requestWithURLParameters([String: Any]?)
  case requestWithParameters(parameters: [String: Any]?, encoding: HTTPParameterEncoding)
}
