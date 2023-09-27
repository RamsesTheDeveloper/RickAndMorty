//
//  RMEndpoint.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 9/27/23.
//

import Foundation

/// Represents unique API endpoint
@frozen enum RMEndpoint: String {
    /// Endpoint to get Character info
    case character
    /// Endpoint to get Location info
    case location
    /// Endpoint to get Episode info
    case episode
}

/*


-> Source Control Section


Endpoint ) Endpoints represent the various paths that we can request data from.


Enum ) We are using an Enum to Model our endpoints because we can switch between cases.
We want to represent our cases as Strings, so we are going to give our RMEndpoint Enum a raw value Type of String.


*/
