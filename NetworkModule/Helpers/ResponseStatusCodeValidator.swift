//
//  ResponseStatusCodeValidator.swift
//  NetworkModule
//
//  Created by Göksel Köksal on 25.11.2018.
//  Copyright © 2018 GK. All rights reserved.
//

import Foundation

public class ResponseStatusCodeValidator: NetworkResponseValidatorProtocol {
  
  public enum Error: Swift.Error {
    case missingStatusCode
    case invalidStatusCode
  }
  
  private let successCodeRange: Range<Int>
  private let additionalSuccessCodes: [Int]?
  private let errorPayloadDecoder: ErrorPayloadDecoderProtocol?
  
  public init(successCodeRange: Range<Int>,
              additionalSuccessCodes: [Int]? = nil,
              errorPayloadDecoder: ErrorPayloadDecoderProtocol? = nil) {
    self.successCodeRange = successCodeRange
    self.additionalSuccessCodes = additionalSuccessCodes
    self.errorPayloadDecoder = errorPayloadDecoder
  }
  
  public func validate(_ response: NetworkResponse<Data>) throws {
    guard let statusCode = response.response?.statusCode else {
      throw Error.missingStatusCode
    }
    let rangeOK = successCodeRange.contains(statusCode)
    let additionalOK = additionalSuccessCodes?.contains(statusCode) ?? true
    
    if (rangeOK && additionalOK) == false {
      throw errorPayloadDecoder?.decode(response.data) ?? Error.invalidStatusCode
    }
  }
}

// MARK: - Error payload decoder

public protocol ErrorPayloadDecoderProtocol {
  func decode(_ data: Data?) -> Error
}
