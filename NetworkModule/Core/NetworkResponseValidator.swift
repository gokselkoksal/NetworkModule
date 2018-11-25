//
//  NetworkResponseValidator.swift
//  NetworkModule
//
//  Created by Göksel Köksal on 25.11.2018.
//  Copyright © 2018 GK. All rights reserved.
//

import Foundation

public protocol NetworkResponseValidatorProtocol {
    func validate(_ response: NetworkResponse<Data>) throws
}
