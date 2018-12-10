//
//  JSONPlaceholderAPI.swift
//  NetworkModuleTests
//
//  Created by Göksel Köksal on 25.11.2018.
//  Copyright © 2018 GK. All rights reserved.
//

import Foundation
import NetworkModule

class JSONPlaceholderAPI: NetworkAPIProtocol {
  
  let baseURL: URL = URL(string: "https://jsonplaceholder.typicode.com")!
  let headers: [String : String] = ["accept": "application/json"]
  let responseValidators: [NetworkResponseValidatorProtocol] = [ResponseStatusCodeValidator(successCodeRange: 200..<300)]
  
  func posts() -> NetworkTaskDescriptor<DecodableNetworkResponseDecoder<[Post]>> {
    let decoder = DecodableNetworkResponseDecoder<[Post]>()
    return makeTask(
      path: "/posts",
      method: .get,
      operationType: .plainRequest,
      responseDecoder: decoder
    )
  }
}

struct Post: Decodable {
  let userId: Int
  let id: Int
  let title: String
  let body: String
}
