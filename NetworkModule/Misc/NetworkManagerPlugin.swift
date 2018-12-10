//
//  NetworkManagerPlugin.swift
//  NetworkModule
//
//  Created by Goksel Koksal on 10/12/2018.
//  Copyright © 2018 GK. All rights reserved.
//

import Foundation

public protocol NetworkPluginProtocol {
  
  /// Called to modify a request before sending.
  func prepareRequest(_ request: URLRequest) -> URLRequest
  
  /// Called immediately before a request is sent over the network (or stubbed).
  func willSendRequest(_ request: URLRequest)
  
  /// Called after a response has been received, but before the MoyaProvider has invoked its completion handler.
  func didReceiveResponse(_ response: NetworkResponse<Data>)
  
  func didDecodeResponse<Model>(_ response: NetworkResponse<Model>)
}

public extension NetworkPluginProtocol {
  
  public func prepareRequest(_ request: URLRequest) -> URLRequest {
    return request
  }
  
  public func willSendRequest(_ request: URLRequest) { }
  public func didReceiveResponse(_ response: NetworkResponse<Data>) { }
  public func didDecodeResponse<Model>(_ response: NetworkResponse<Model>) { }
}
