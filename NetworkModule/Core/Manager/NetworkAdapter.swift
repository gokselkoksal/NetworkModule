//
//  NetworkAdapter.swift
//  NetworkModule
//
//  Created by Goksel Koksal on 11/12/2018.
//  Copyright © 2018 GK. All rights reserved.
//

import Foundation

public protocol NetworkAdapterProtocol: class {
  var delegate: NetworkAdapterDelegate? { get set }
  func send(_ request: NetworkRequest, completion: @escaping (NetworkResponse<Data>) -> Void) -> Cancellable?
}

public protocol NetworkAdapterDelegate: class {
  func prepareRequestForNetworkAdapter(_ request: URLRequest) -> URLRequest
  func networkAdapterWillSendRequest(_ request: URLRequest)
  func networkAdapterDidReceiveResponse(_ response: NetworkResponse<Data>)
}
