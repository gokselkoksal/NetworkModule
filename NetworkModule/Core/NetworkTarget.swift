//
//  NetworkTarget.swift
//  NetworkModule
//
//  Created by Göksel Köksal on 25.11.2018.
//  Copyright © 2018 GK. All rights reserved.
//

import Foundation

public class NetworkTarget<Decoder: NetworkResponseDecoderProtocol> {
  
  public let request: NetworkRequest
  public let responseDecoder: Decoder
  public let responseValidators: [NetworkResponseValidatorProtocol]
  
  public init(
    request: NetworkRequest,
    responseDecoder: Decoder,
    responseValidators: [NetworkResponseValidatorProtocol])
  {
    self.request = request
    self.responseDecoder = responseDecoder
    self.responseValidators = responseValidators
  }
}
