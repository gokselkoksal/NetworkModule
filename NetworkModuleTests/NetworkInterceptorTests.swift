//
//  NetworkInterceptorTests.swift
//  NetworkModuleTests
//
//  Created by Goksel Koksal on 11/12/2018.
//  Copyright © 2018 GK. All rights reserved.
//

import XCTest
import Nimble
import Lightning
import NetworkModule

class NetworkInterceptorTests: XCTestCase {
  
  private let api = JSONPlaceholderAPI()
  
  private var adapter: MockNetworkAdapter!
  private var interceptor: MockNetworkInterceptor!
  private var manager: NetworkManager!

  override func setUp() {
    adapter = MockNetworkAdapter()
    adapter.result = .success(try! ResourceLoader.loadResource(name: "posts", extension: "json"))
    interceptor = MockNetworkInterceptor()
    manager = NetworkManager(networkAdapter: adapter, interceptor: interceptor)
  }

  func testSuccess() {
    let extraHeaders = ["Auth": "XXX"]
    interceptor.extraHeaders = extraHeaders
    
    waitUntil { (done) in
      _ = self.manager.start(self.api.posts()) { (response) in
        do {
          expect(response.result.isSuccess).to(beTrue())
          let requestHeaders = try response.request.unwrap().allHTTPHeaderFields.unwrap()
          for (key, value) in extraHeaders {
            expect(requestHeaders[key]).to(equal(value))
          }
        } catch {
          fail()
        }
        done()
      }
    }
  }
  
  func testFailure() {
    let extraHeaders = ["Auth": "XXX"]
    interceptor.extraHeaders = extraHeaders
    interceptor.shouldFail = true
    
    waitUntil { (done) in
      _ = self.manager.start(self.api.posts()) { (response) in
        expect(response.result.isSuccess).to(beFalse())
        expect(response.result.error is MockNetworkInterceptor.MockError).to(beTrue())
        done()
      }
    }
  }
}

private class MockNetworkInterceptor: NetworkInterceptorProtocol {
  
  struct MockError: Swift.Error { }
  
  var shouldFail: Bool = false
  var extraHeaders: [String: String]?
  
  func intercept<Decoder>(_ task: NetworkTaskDescriptor<Decoder>, completion: (GenericResult<NetworkTaskDescriptor<Decoder>>) -> Void) -> Cancellable? where Decoder : NetworkResponseDecoderProtocol {
    guard shouldFail == false else {
      completion(.failure(MockError()))
      return nil
    }
    
    if let extraHeaders = extraHeaders {
      let newRequest = task.request.appendingHeaders(extraHeaders)
      let newTask = task.updatingRequest(newRequest)
      completion(.success(newTask))
    } else {
      completion(.success(task))
    }
    
    return nil
  }
}
