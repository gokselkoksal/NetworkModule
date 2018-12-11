//
//  NetworkManagerPluginTests.swift
//  NetworkModuleTests
//
//  Created by Goksel Koksal on 11/12/2018.
//  Copyright © 2018 GK. All rights reserved.
//

import XCTest
import NetworkModule
import Nimble
import Lightning

class NetworkManagerPluginTests: XCTestCase {
  
  private let api = JSONPlaceholderAPI()
  
  private var manager: NetworkManager!
  private var adapter: MockNetworkAdapter!
  private var plugin1: MockNetworkPlugin!
  private var plugin2: MockNetworkPlugin!

  override func setUp() {
    adapter = MockNetworkAdapter()
    plugin1 = MockNetworkPlugin()
    plugin2 = MockNetworkPlugin()
    manager = NetworkManager(networkAdapter: adapter, interceptor: nil, plugins: [plugin1, plugin2])
  }

  func testCallbacks() throws {
    let task = self.api.posts()
    let expectedData = try ResourceLoader.loadResource(name: "posts", extension: "json")
    adapter.result = .success(expectedData)
    
    waitUntil(timeout: 1.5) { (done) in
      self.manager.start(task) { [weak self] (response) in
        guard let self = self else { return }
        
        do {
          let expectedResponse = try self.adapter.latestResponse.unwrap()
          let expectedURLRequest = try expectedResponse.request.unwrap()
          let expectedPosts = try task.responseDecoder.decode(expectedResponse).result.value.unwrap()
          
          expect(self.plugin1.events.count).to(equal(4))
          expect(self.plugin2.events.count).to(equal(4))
          
          switch try self.plugin1.events.element(at: 0) {
          case .prepareRequest(let request):
            expect(request).to(equal(expectedURLRequest))
          default:
            fail("should be prepareRequest")
          }
          
          switch try self.plugin1.events.element(at: 1) {
          case .willSendRequest(let request):
            expect(request).to(equal(expectedURLRequest))
          default:
            fail("should be willSendRequest")
          }
          
          switch try self.plugin1.events.element(at: 2) {
          case .didReceiveResponse(let response):
            expect(response.request).to(equal(expectedResponse.request))
            expect(response.data).to(equal(expectedResponse.data))
            expect(response.result.value).to(equal(expectedResponse.result.value))
            expect(response.result.error).to(beNil())
          default:
            fail("should be didReceiveResponse")
          }
          
          switch try self.plugin1.events.element(at: 3) {
          case .didDecodeResponse(let response):
            expect(response.request).to(equal(expectedResponse.request))
            expect(response.data).to(equal(expectedResponse.data))
            
            switch response.result {
            case .success(let value):
              let posts = try (value as? [Post]).unwrap()
              expect(posts).to(equal(expectedPosts))
            case .failure:
              fail("should be success")
            }
          default:
            fail("should be didDecodeResponse")
          }
          done()
        } catch {
          fail(error.localizedDescription)
          done()
        }
      }
    }
  }
  
  func testPrepareRequest() throws {
    let task = self.api.posts()
    let expectedData = try ResourceLoader.loadResource(name: "posts", extension: "json")
    adapter.result = .success(expectedData)
    
    let header1 = (key: "plugin1", value: "value1")
    let header2 = (key: "plugin2", value: "value2")
    
    plugin1.prepareRequestAction = { request in
      var request = request
      request.addValue(header1.value, forHTTPHeaderField: header1.key)
      return request
    }
    
    plugin2.prepareRequestAction = { request in
      var request = request
      request.addValue(header2.value, forHTTPHeaderField: header2.key)
      return request
    }
    
    waitUntil(timeout: 1.5) { (done) in
      self.manager.start(task) { (response) in
        expect(response.request?.allHTTPHeaderFields?[header1.key]).to(equal(header1.value))
        expect(response.request?.allHTTPHeaderFields?[header2.key]).to(equal(header2.value))
        done()
      }
    }
  }
}

private class MockNetworkPlugin: NetworkManagerPluginProtocol {
  
  enum Event {
    case prepareRequest(URLRequest)
    case willSendRequest(URLRequest)
    case didReceiveResponse(NetworkResponse<Data>)
    case didDecodeResponse(NetworkResponse<Any>)
  }
  
  var events: [Event] = []
  
  var prepareRequestAction: ((URLRequest) -> URLRequest)?
  
  func prepareRequest(_ request: URLRequest) -> URLRequest {
    var request = request
    
    if let requestAction = prepareRequestAction {
      request = requestAction(request)
    }
    
    events.append(.prepareRequest(request))
    return request
  }
  
  func willSendRequest(_ request: URLRequest) {
    events.append(.willSendRequest(request))
  }
  
  func didReceiveResponse(_ response: NetworkResponse<Data>) {
    events.append(.didReceiveResponse(response))
  }
  
  func didDecodeResponse<Model>(_ response: NetworkResponse<Model>) {
    let anyResult = response.result.map({ $0 as Any })
    let anyResponse = response.updatingResult(anyResult)
    events.append(.didDecodeResponse(anyResponse))
  }
}
