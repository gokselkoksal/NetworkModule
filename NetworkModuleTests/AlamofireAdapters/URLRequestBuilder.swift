//
//  URLRequestBuilder.swift
//  NetworkModuleTests
//
//  Created by Goksel Koksal on 11/12/2018.
//  Copyright © 2018 GK. All rights reserved.
//

import Foundation
import NetworkModule
import Alamofire

class URLRequestBuilder {
  
  static func make(url: Alamofire.URLConvertible,
                   method: Alamofire.HTTPMethod,
                   parameters: Alamofire.Parameters?,
                   encoding: Alamofire.ParameterEncoding,
                   headers: Alamofire.HTTPHeaders?) throws -> URLRequest
  {
    let request = try URLRequest(url: url, method: method, headers: headers)
    return try encoding.encode(request, with: parameters)
  }
  
  static func make(request: NetworkRequest) throws -> URLRequest {
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
    
    return try make(url: url, method: method, parameters: parameters, encoding: encoding, headers: headers)
  }
}
