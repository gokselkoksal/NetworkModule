//
//  LiveNetworkManagerTests.swift
//  NetworkModuleTests
//
//  Created by Göksel Köksal on 25.11.2018.
//  Copyright © 2018 GK. All rights reserved.
//

import XCTest
import Nimble
import NetworkModule

class LiveNetworkManagerTests: XCTestCase {
  
  private let api = JSONPlaceholderAPI()
  private let adapter = AlamofireNetworkAdapter()
  
  private var manager: NetworkManager!
  
  override func setUp() {
    manager = NetworkManager(adapter: adapter)
  }
  
  func testExample() {
    waitUntil(timeout: 1.5) { (done) in
      self.manager.start(self.api.posts()) { (response) in
        switch response.result {
        case .success(let posts):
          expect(posts.count).to(beGreaterThan(0))
        case .failure(let error):
          XCTFail(error.localizedDescription)
        }
        done()
      }
    }
  }
}
