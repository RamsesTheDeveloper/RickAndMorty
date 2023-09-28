//
//  RMEpisode.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 9/27/23.
//

import Foundation

struct RMEpisode: Codable {
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
}

/*


-> Creating Models Section


Schema ) The schema for RMCharacter can be found at https://rickandmortyapi.com/documentation/#episode-schema

*/
