//
//  MockNetworkAdapter.swift
//  NetworkModuleTests
//
//  Created by Goksel Koksal on 11/12/2018.
//  Copyright © 2018 GK. All rights reserved.
//

import Foundation
import NetworkModule
import Lightning

class MockNetworkAdapter: NetworkAdapterProtocol {
  
  weak var delegate: NetworkAdapterDelegate?
  
  var customStatusCode: Int?
  var result: GenericResult<Data> = GenericResult.success(Data())
  
  private(set) var latestResponse: NetworkResponse<Data>?
  
  func send(_ request: NetworkRequest, completion: @escaping (NetworkResponse<Data>) -> Void) -> Cancellable? {
    latestResponse = nil
    var urlRequest = try! makeURLRequest(from: request)
    urlRequest = delegate?.prepareRequestForNetworkAdapter(urlRequest) ?? urlRequest
    let response = try! makeResponse(for: request, urlRequest: urlRequest)
    latestResponse = response
    delegate?.networkAdapterWillSendRequest(urlRequest)
    delegate?.networkAdapterDidReceiveResponse(response)
    completion(response)
    return nil
  }
  
  private func makeStatusCode() -> Int {
    if let customStatusCode = customStatusCode {
      return customStatusCode
    } else {
      return result.isSuccess ? 200 : 404
    }
  }
  
  private func makeURLRequest(from request: NetworkRequest) throws -> URLRequest {
    return try URLRequestBuilder.make(request: request)
  }
  
  private func makeResponse(for request: NetworkRequest, urlRequest: URLRequest) throws -> NetworkResponse<Data> {
    let httpResponse = HTTPURLResponse(
      url: try urlRequest.url.unwrap(),
      statusCode: makeStatusCode(),
      httpVersion: nil,
      headerFields: nil
    )
    let response = NetworkResponse<Data>(
      request: urlRequest,
      response: httpResponse,
      data: result.value,
      result: result
    )
    return response
  }
}
