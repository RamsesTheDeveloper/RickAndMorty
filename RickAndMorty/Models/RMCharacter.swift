//
//  RMCharacter.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 9/27/23.
//

import Foundation

struct RMCharacter: Codable {
    let id: Int
    let name: String
    let status: RMCharacterStatus
    let species: String
    let type: String
    let gender: RMCharacterGender
    let origin: RMOrigin
    let location: RMSingleLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

/*


-> Creating Models Section

Schema ) The schema for RMCharacter can be found at https://rickandmortyapi.com/documentation/#character-schema


Separate Files ) Putting our Models in different files helps readability and testability.
Look through iOSSoftware for more explanation.


Filter ) Since RMCharacter has properties like RMCharacterStatus, when we receive an RMCharacter object from RMService, we will be able to implement some logic in a ViewModel that will filter out a Collection of chracters that are Alive, Dead, or unknown.

*/
