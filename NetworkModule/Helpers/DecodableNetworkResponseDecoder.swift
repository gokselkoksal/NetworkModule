//
//  DecodableNetworkResponseDecoder.swift
//  NetworkModule
//
//  Created by Göksel Köksal on 25.11.2018.
//  Copyright © 2018 GK. All rights reserved.
//

import Foundation

public class DecodableNetworkResponseDecoder<Model: Decodable>: NetworkResponseDecoderProtocol {
  
  private let decoder: JSONDecoder
  
  public init(decoder: JSONDecoder = JSONDecoder()) {
    self.decoder = decoder
  }
  
  public func decode(_ response: NetworkResponse<Data>) -> NetworkResponse<Model> {
    let finalResult: GenericResult<Model>
    
    switch response.result {
    case .success(let data):
      do {
        let model = try decoder.decode(Model.self, from: data)
        finalResult = .success(model)
      } catch {
        finalResult = .failure(error)
      }
    case .failure(let error):
      finalResult = .failure(error)
    }
    
    let finalResponse = response.updatingResult(finalResult)
    return finalResponse
  }
}
