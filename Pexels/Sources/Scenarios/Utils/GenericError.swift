//
//  GenericError.swift
//  Pexels-Production
//
//  Created by An Tran on 10/1/22.
//

import Foundation

struct GenericError: Error, LocalizedError {
    let description: String
    
    var errorDescription: String? {
        description
    }
}
