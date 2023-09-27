//
//  RMLocation.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 9/27/23.
//

import Foundation

struct RMLocation: Codable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: String
    let created: String
}

/*


-> Creating Models Section

Schema ) The schema for RMCharacter can be found at https://rickandmortyapi.com/documentation/#location-schema
 
*/
