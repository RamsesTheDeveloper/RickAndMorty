//
//  RMCharacterStatus.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 9/27/23.
//

import Foundation

enum RMCharacterStatus: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case `unknown` = "unknown"
    
    var text: String {
        switch self {
        case .alive, .dead:
            return rawValue
        case .unknown:
            return "Unknown"
        }
    }
}

/*


-> Showing Characters Section


text ) Our unknown case is not capitalized, but the other Strings are.
So, to stay consistent, we are going to create a computed property called text which is going to switch on self, which is our RMCharacterStatus Enum, and we are going to return the raw value of the alive and dead cases, but for the unknown case we are going to return a capitalized String.

Keep in mind that the String can't be updated by capitalizing the raw value of unknown because those values are reflect the schema that we get back from our JSON, if we change it to capital, then it will break.

*/
