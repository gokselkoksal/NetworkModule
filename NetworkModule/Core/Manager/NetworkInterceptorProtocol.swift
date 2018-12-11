//
//  NetworkInterceptorProtocol.swift
//  NetworkModule
//
//  Created by Goksel Koksal on 10/12/2018.
//  Copyright © 2018 GK. All rights reserved.
//

import Foundation

public protocol NetworkInterceptorProtocol {
  
  /// Called before network manager performs each given task.
  ///
  /// - Parameters:
  ///   - task: Task on the queue.
  ///   - completion: Completion to call after interception.
  /// - Returns: Cancel token.
  func intercept<Decoder: NetworkResponseDecoderProtocol>(
    _ task: NetworkTaskDescriptor<Decoder>,
    completion: (GenericResult<NetworkTaskDescriptor<Decoder>>) -> Void) -> Cancellable?
}
