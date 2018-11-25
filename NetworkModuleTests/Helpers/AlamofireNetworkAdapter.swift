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
  
  private let session: SessionManager
  
  init() {
    session = SessionManager.default
  }
  
  func start(_ request: NetworkRequest, completion: @escaping (NetworkResponse<Data>) -> Void) -> URLSessionTask? {
    let url = request.baseURL.appendingPathComponent(request.path)
    let method = AlamofireMapper.mapMethod(request.method)
    let headers = request.headers
    let parameters: [String: Any]?
    let encoding: Alamofire.ParameterEncoding
    
    switch request.operationType {
    case .plainRequest:
      parameters = nil
      encoding = URLEncoding()
    case .requestWithURLParameters(let urlParameters):
      parameters = urlParameters
      encoding = URLEncoding()
    case .requestWithParameters(parameters: let requestParameters, encoding: let requestEncoding):
      parameters = requestParameters
      encoding = AlamofireMapper.mapEncoding(requestEncoding)
    }
    
    let alamofireRequest = session.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
    
    alamofireRequest.responseData { (dataResponse) in
      let response = AlamofireMapper.mapResponse(dataResponse)
      completion(response)
    }
    
    return alamofireRequest.task
  }
}

// MARK: - Alamofire helpers

private class AlamofireMapper {
  
  static func mapMethod(_ method: NetworkModule.HTTPMethod) -> Alamofire.HTTPMethod {
    return Alamofire.HTTPMethod(rawValue: method.rawValue)!
  }
  
  static func mapEncoding(_ encoding: HTTPParameterEncoding) -> Alamofire.ParameterEncoding {
    switch encoding {
    case .json:
      return JSONEncoding()
    case .urlEncoded:
      return URLEncoding()
    case .custom(let encoder):
      return AlamofireCustomEncoding(networkModuleEncoder: encoder)
    }
  }
  
  static func mapResult<Value>(_ result: Alamofire.Result<Value>) -> NetworkModule.GenericResult<Value> {
    switch result {
    case .success(let value):
      return .success(value)
    case .failure(let error):
      return .failure(error)
    }
  }
  
  static func mapResponse(_ dataResponse: Alamofire.DataResponse<Data>) -> NetworkResponse<Data> {
    return NetworkResponse(
      request: dataResponse.request,
      response: dataResponse.response,
      data: dataResponse.data,
      result: mapResult(dataResponse.result))
  }
}

private class AlamofireCustomEncoding: Alamofire.ParameterEncoding {
  
  private let networkModuleEncoder: HTTPParameterEncoderProtocol
  
  init(networkModuleEncoder: HTTPParameterEncoderProtocol) {
    self.networkModuleEncoder = networkModuleEncoder
  }
  
  func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
    return try networkModuleEncoder.encode(try urlRequest.asURLRequest(), with: parameters)
  }
}
