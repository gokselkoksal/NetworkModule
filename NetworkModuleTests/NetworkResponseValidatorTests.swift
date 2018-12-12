//
//  NetworkResponseValidatorTests.swift
//  NetworkModuleTests
//
//  Created by Goksel Koksal on 12/12/2018.
//  Copyright © 2018 GK. All rights reserved.
//

import XCTest
import Nimble
import NetworkModule

class NetworkResponseValidatorTests: XCTestCase {
  
  private let api = JSONPlaceholderAPI()
  
  private var adapter: MockNetworkAdapter!
  private var manager: NetworkManager!
  
  override func setUp() {
    adapter = MockNetworkAdapter()
    adapter.result = .success(try! ResourceLoader.loadResource(name: "posts", extension: "json"))
    manager = NetworkManager(networkAdapter: adapter)
  }

  func testSingleValidator() {
    let statusCode = 203
    let validator = MockNetworkResponseValidator(errorStatusCodes: [statusCode])
    let task = api.posts().addingResponseValidators([validator])
    adapter.customStatusCode = statusCode
    
    waitUntil { (done) in
      self.manager.start(task) { (response) in
        expect(response.response?.statusCode).to(equal(statusCode))
        
        if let error = response.result.error as? MockNetworkResponseValidator.ValidationError {
          expect(error.statusCode).to(equal(statusCode))
        } else {
          fail("should receive validation error")
        }
        done()
      }
    }
  }
  
  func testMultipleValidators() {
    let statusCode = 204
    
    let validator1 = MockNetworkResponseValidator(errorStatusCodes: [203])
    let validator2 = MockNetworkResponseValidator(errorStatusCodes: [statusCode])
    
    let task = api.posts().addingResponseValidators([validator1, validator2])
    adapter.customStatusCode = statusCode
    
    waitUntil { (done) in
      self.manager.start(task) { (response) in
        expect(response.response?.statusCode).to(equal(statusCode))
        
        if let error = response.result.error as? MockNetworkResponseValidator.ValidationError {
          expect(error.statusCode).to(equal(statusCode))
        } else {
          fail("should receive validation error")
        }
        done()
      }
    }
  }
}

private class MockNetworkResponseValidator: NetworkResponseValidatorProtocol {
  
  struct ValidationError: Error {
    let statusCode: Int
  }
  
  var errorStatusCodes: [Int] = []
  
  init(errorStatusCodes: [Int]) {
    self.errorStatusCodes = errorStatusCodes
  }
  
  func validate(_ response: NetworkResponse<Data>) throws {
    guard let statusCode = response.response?.statusCode else { return }
    
    if errorStatusCodes.contains(statusCode) {
      throw ValidationError(statusCode: statusCode)
    }
  }
}
