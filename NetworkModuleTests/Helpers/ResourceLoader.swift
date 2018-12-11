//
//  ResourceLoader.swift
//  NetworkModuleTests
//
//  Created by Goksel Koksal on 11/12/2018.
//  Copyright © 2018 GK. All rights reserved.
//

import Foundation
import Lightning

class ResourceLoader {
  
  private init() { }
  
  static func loadResource(name: String, extension ext: String) throws -> Data {
    let bundle = Bundle.test
    let url = try bundle.url(forResource: name, withExtension: ext).unwrap()
    let data = try Data(contentsOf: url)
    return data
  }
}

private extension Bundle {
  class Dummy { }
  static let test = Bundle(for: Dummy.self)
}
