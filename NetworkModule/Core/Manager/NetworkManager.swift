//
//  NetworkManager.swift
//  NetworkModule
//
//  Created by Göksel Köksal on 25.11.2018.
//  Copyright © 2018 Adaptics. All rights reserved.
//

import Foundation

public class NetworkManager {
  
  // TODO: Add stubbing.
  private let networkAdapter: NetworkAdapterProtocol
  private let interceptor: NetworkInterceptorProtocol?
  private let plugins: [NetworkManagerPluginProtocol]
  
  public init(
    networkAdapter: NetworkAdapterProtocol,
    interceptor: NetworkInterceptorProtocol? = nil,
    plugins: [NetworkManagerPluginProtocol] = [])
  {
    self.networkAdapter = networkAdapter
    self.interceptor = interceptor
    self.plugins = plugins
    
    self.networkAdapter.delegate = self
  }
  
  @discardableResult
  public func start<Decoder: NetworkResponseDecoderProtocol>(
    _ task: NetworkTaskDescriptor<Decoder>,
    completion: @escaping (NetworkResponse<Decoder.Model>) -> Void) -> Cancellable?
  {
    let cancellableWrapper = CancellableWrapper()
    
    func performActualTask(_ task: NetworkTaskDescriptor<Decoder>) {
      let requestToken = self.networkAdapter.send(task.request) { [weak self] (dataResponse) in
        guard let self = self else { return }
        
        do {
          try task.responseValidators.forEach({ try $0.validate(dataResponse) })
          let response = task.responseDecoder.decode(dataResponse)
          self.plugins.forEach({ $0.didDecodeResponse(response) })
          completion(response)
        } catch {
          let result = GenericResult<Decoder.Model>.failure(error)
          let response = dataResponse.updatingResult(result)
          completion(response)
        }
      }
      cancellableWrapper.token = requestToken
    }
    
    // Intercept request, if there's an interceptor:
    if let interceptor = interceptor {
      let token = interceptor.intercept(task) { (result) in
        switch result {
        case .success(let task):
          // Carry on with actual request:
          performActualTask(task)
        case .failure(let error):
          let response = NetworkResponse<Decoder.Model>.failure(error)
          completion(response)
        }
      }
      cancellableWrapper.token = token
    } else {
      // Carry on with actual request:
      performActualTask(task)
    }
    
    return cancellableWrapper
  }
}

extension NetworkManager: NetworkAdapterDelegate {
  
  public func prepareRequestForNetworkAdapter(_ request: URLRequest) -> URLRequest {
    return plugins.reduce(request) { (request, plugin) -> URLRequest in
      return plugin.prepareRequest(request)
    }
  }
  
  public func networkAdapterWillSendRequest(_ request: URLRequest) {
    plugins.forEach({ $0.willSendRequest(request) })
  }
  
  public func networkAdapterDidReceiveResponse(_ response: NetworkResponse<Data>) {
    plugins.forEach({ $0.didReceiveResponse(response) })
  }
}
