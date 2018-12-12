//
//  NetworkRequest.swift
//  NetworkModule
//
//  Created by Göksel Köksal on 25.11.2018.
//  Copyright © 2018 Adaptics. All rights reserved.
//

import Foundation

public class NetworkRequest {
  
  public enum OperationType {
    case plainRequest
    case requestWithURLParameters([String: Any]?)
    case requestWithParameters(parameters: [String: Any]?, encoding: HTTPParameterEncoding)
  }
  
  public let baseURL: URL
  public let path: String
  public let method: HTTPMethod
  public let operationType: OperationType
  public let headers: [String: String]?
  
  public init(baseURL: URL,
              path: String,
              method: HTTPMethod,
              operationType: OperationType,
              headers: [String: String]?)
  {
    self.baseURL = baseURL
    self.path = path
    self.method = method
    self.operationType = operationType
    self.headers = headers
  }
}

public extension NetworkRequest {
  
  public func updatingHeaders(_ headers: [String: String]) -> NetworkRequest {
    return NetworkRequest(
      baseURL: baseURL,
      path: path,
      method: method,
      operationType: operationType,
      headers: headers
    )
  }
  
  public func appendingHeaders(_ newHeaders: [String: String]) -> NetworkRequest {
    var mergedHeaders = headers ?? [:]
    mergedHeaders.merge(newHeaders) { (_, new) -> String in
      return new
    }
    return updatingHeaders(mergedHeaders)
  }
}
