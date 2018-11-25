//
//  HTTPParameterEncoding.swift
//  NetworkModule
//
//  Created by Göksel Köksal on 25.11.2018.
//  Copyright © 2018 GK. All rights reserved.
//

import Foundation

public enum HTTPParameterEncoding {
  case urlEncoded
  case json
  case custom(HTTPParameterEncoderProtocol)
}

public protocol HTTPParameterEncoderProtocol {
  func encode(_ urlRequest: URLRequest, with parameters: [String: Any]?) throws -> URLRequest
}
