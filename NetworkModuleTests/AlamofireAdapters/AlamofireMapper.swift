//
//  AlamofireMapper.swift
//  NetworkModuleTests
//
//  Created by Goksel Koksal on 11/12/2018.
//  Copyright © 2018 GK. All rights reserved.
//

import Foundation
import NetworkModule
import Alamofire

class AlamofireMapper {
  
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

class AlamofireCustomEncoding: Alamofire.ParameterEncoding {
  
  private let networkModuleEncoder: HTTPParameterEncoderProtocol
  
  init(networkModuleEncoder: HTTPParameterEncoderProtocol) {
    self.networkModuleEncoder = networkModuleEncoder
  }
  
  func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
    return try networkModuleEncoder.encode(try urlRequest.asURLRequest(), with: parameters)
  }
}
