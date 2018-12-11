//
//  NetworkManagerPlugin.swift
//  NetworkModule
//
//  Created by Goksel Koksal on 10/12/2018.
//  Copyright © 2018 GK. All rights reserved.
//

import Foundation

public protocol NetworkManagerPluginProtocol {
  
  /// Called to modify a request before sending.
  ///
  /// - Parameter request: Request to prepare.
  func prepareRequest(_ request: URLRequest) -> URLRequest
  
  /// Called immediately before a request is sent over the network (or stubbed).
  ///
  /// - Parameter request: Request to be sent.
  func willSendRequest(_ request: URLRequest)
  
  /// Called after a response has been received, but before the network manager has invoked its completion handler.
  ///
  /// - Parameter response: Raw response.
  func didReceiveResponse(_ response: NetworkResponse<Data>)
  
  /// Called after a response has been decoded, but before the network manager has invoked its completion handler.
  ///
  /// - Parameter response: Decoded response.
  func didDecodeResponse<Model>(_ response: NetworkResponse<Model>)
}
