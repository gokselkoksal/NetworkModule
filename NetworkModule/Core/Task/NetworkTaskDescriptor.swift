//
//  NetworkTarget.swift
//  NetworkModule
//
//  Created by Göksel Köksal on 25.11.2018.
//  Copyright © 2018 GK. All rights reserved.
//

import Foundation

public class NetworkTaskDescriptor<Decoder: NetworkResponseDecoderProtocol> {
  
  public let request: NetworkRequest
  public let responseValidators: [NetworkResponseValidatorProtocol]
  public let responseDecoder: Decoder
  
  public init(
    request: NetworkRequest,
    responseValidators: [NetworkResponseValidatorProtocol],
    responseDecoder: Decoder)
  {
    self.request = request
    self.responseDecoder = responseDecoder
    self.responseValidators = responseValidators
  }
}

public extension NetworkTaskDescriptor {
  
  public func updatingRequest(_ request: NetworkRequest) -> NetworkTaskDescriptor<Decoder> {
    return NetworkTaskDescriptor(
      request: request,
      responseValidators: responseValidators,
      responseDecoder: responseDecoder
    )
  }
}
