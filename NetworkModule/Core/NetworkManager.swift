//
//  NetworkManager.swift
//  NetworkModule
//
//  Created by Göksel Köksal on 25.11.2018.
//  Copyright © 2018 Adaptics. All rights reserved.
//

import Foundation

public protocol NetworkAdapterProtocol {
  func start(_ request: NetworkRequest, completion: @escaping (NetworkResponse<Data>) -> Void) -> URLSessionTask?
}

public class NetworkManager {
  
  // TODO: Add stubbing.
  private let networkAdapter: NetworkAdapterProtocol
  
  public init(networkAdapter: NetworkAdapterProtocol) {
    self.networkAdapter = networkAdapter
  }
  
  @discardableResult
  public func start<Decoder: NetworkResponseDecoderProtocol>(
    _ target: NetworkTarget<Decoder>,
    completion: @escaping (NetworkResponse<Decoder.Model>) -> Void) -> URLSessionTask?
  {
    return networkAdapter.start(target.request) { (dataResponse) in
      do {
        try target.responseValidators.forEach({ try $0.validate(dataResponse) })
        let response = target.responseDecoder.decode(dataResponse)
        completion(response)
      } catch {
        let result = GenericResult<Decoder.Model>.failure(error)
        let response = dataResponse.updatingResult(result)
        completion(response)
      }
    }
  }
}
