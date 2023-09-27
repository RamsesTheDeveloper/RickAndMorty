//
//  RMService.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 9/27/23.
//

import Foundation

/// Primary API service object to get RIck and Morty data
final class RMService {
    /// Shared singleton instance
    static let shared = RMService()
    
    /// Privatize Constructor
    private init() {}
    
    public func execute(_ request: RMRequest, completion: @escaping () -> Void) {}
}

/*


-> Source Control Section


Singleton Pattern ) Our RMService Class will be responsible for making API calls.
To begin, we will use the singleton pattern.

We enforce the singleton pattern by making our Class's initializer private.

*/
