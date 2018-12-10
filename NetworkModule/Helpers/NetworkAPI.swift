//
//  NetworkAPI.swift
//  NetworkModule
//
//  Created by Göksel Köksal on 25.11.2018.
//  Copyright © 2018 GK. All rights reserved.
//

import Foundation

public protocol NetworkAPIProtocol {
  var baseURL: URL { get }
  var headers: [String: String] { get }
  var responseValidators: [NetworkResponseValidatorProtocol] { get }
}

public extension NetworkAPIProtocol {
  
  public func makeTask<ResponseDecoder: NetworkResponseDecoderProtocol>(
    path: String,
    method: HTTPMethod,
    operationType: NetworkOperationType,
    responseDecoder: ResponseDecoder,
    additionalHeaders: [String: String]? = nil,
    additionalResponseValidators: [NetworkResponseValidatorProtocol]? = nil) -> NetworkTaskDescriptor<ResponseDecoder>
  {
    var headers = self.headers
    var responseValidators = self.responseValidators
    
    if let additionalHeaders = additionalHeaders {
      headers =  headers.merging(additionalHeaders, uniquingKeysWith: { (old, new) -> String in
        return new // Choose the new values when keys collide.
      })
    }
    
    if let additionalResponseValidators = additionalResponseValidators {
      responseValidators.append(contentsOf: additionalResponseValidators)
    }
    
    let request = NetworkRequest(
      baseURL: baseURL,
      path: path,
      method: method,
      operationType: operationType,
      headers: headers
    )
    
    return NetworkTaskDescriptor<ResponseDecoder>(
      request: request,
      responseValidators: responseValidators,
      responseDecoder: responseDecoder
    )
  }
}
