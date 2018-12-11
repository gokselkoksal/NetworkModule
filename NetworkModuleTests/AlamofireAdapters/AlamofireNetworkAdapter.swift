//
//  AlamofireNetworkAdapter.swift
//  NetworkModuleTests
//
//  Created by Göksel Köksal on 25.11.2018.
//  Copyright © 2018 GK. All rights reserved.
//

import Foundation
import Alamofire
import NetworkModule

class AlamofireNetworkAdapter: NetworkAdapterProtocol {
  
  enum Error: Swift.Error {
    case invalidRequest
  }
  
  weak var delegate: NetworkAdapterDelegate?
  private let session: SessionManager
  
  init() {
    session = SessionManager.default
  }
  
  func send(_ request: NetworkRequest, completion: @escaping (NetworkResponse<Data>) -> Void) -> Cancellable? {
    guard var urlRequest = try? URLRequestBuilder.make(request: request) else {
      let response = NetworkResponse<Data>.failure(Error.invalidRequest)
      completion(response)
      return nil
    }
    
    urlRequest = delegate?.prepareRequestForNetworkAdapter(urlRequest) ?? urlRequest
    delegate?.networkAdapterWillSendRequest(urlRequest)
    
    let alamofireRequest = session.request(urlRequest)
    alamofireRequest.responseData { [weak self] (dataResponse) in
      guard let self = self else { return }
      
      let response = AlamofireMapper.mapResponse(dataResponse)
      self.delegate?.networkAdapterDidReceiveResponse(response)
      completion(response)
    }
    
    return CancellableToken(urlSessionTask: alamofireRequest.task)
  }
}
