//
//  NetworkResponseDecoder.swift
//  NetworkModule
//
//  Created by Göksel Köksal on 25.11.2018.
//  Copyright © 2018 GK. All rights reserved.
//

import Foundation

public protocol NetworkResponseDecoderProtocol {
  associatedtype Model
  func decode(_ response: NetworkResponse<Data>) -> NetworkResponse<Model>
}
