//
//  NetworkModuleTests.swift
//  NetworkModuleTests
//
//  Created by Göksel Köksal on 25.11.2018.
//  Copyright © 2018 GK. All rights reserved.
//

import XCTest
@testable import NetworkModule

class NetworkModuleTests: XCTestCase {
  
  private let api = JSONPlaceholderAPI()
  
  func testExample() {
    let adapter = AlamofireNetworkAdapter()
    let networkManager = NetworkManager(networkAdapter: adapter)
    
    let exp = expectation(description: "posts-request")
    networkManager.start(api.posts()) { (response) in
      switch response.result {
      case .success(let value):
        print(value)
      case .failure(let error):
        print(error)
      }
      exp.fulfill()
    }
    
    wait(for: [exp], timeout: 1.5)
  }
}
