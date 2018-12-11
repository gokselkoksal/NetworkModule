//
//  Cancellable.swift
//  NetworkModule
//
//  Created by Goksel Koksal on 10/12/2018.
//  Copyright © 2018 GK. All rights reserved.
//

import Foundation

/// Represents a cancel token.
public protocol Cancellable: class {
  var isCancelled: Bool { get }
  func cancel()
}

// MARK: - CancellableToken

public final class CancellableToken: Cancellable {
  
  public private(set) var isCancelled = false
  private var lock: DispatchSemaphore = DispatchSemaphore(value: 1)
  private let token: AnyObject?
  private let cancelAction: (() -> Void)
  
  public func cancel() {
    _ = lock.wait(timeout: DispatchTime.distantFuture)
    defer { lock.signal() }
    guard !isCancelled else { return }
    isCancelled = true
    cancelAction()
  }
  
  public init(token: AnyObject?, cancelAction: @escaping (() -> Void)) {
    self.token = token
    self.cancelAction = cancelAction
  }
}

public extension CancellableToken {
  
  public convenience init(urlSessionTask: URLSessionTask?) {
    self.init(token: urlSessionTask) {
      urlSessionTask?.cancel()
    }
  }
}

// MARK: - CancellableWrapper

final class CancellableWrapper: Cancellable {
  
  var token: Cancellable?
  
  var isCancelled: Bool {
    return token?.isCancelled ?? false
  }
  
  internal func cancel() {
    token?.cancel()
  }
}
