//
//  RMGetAllEpisodesResponse.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 10/20/23.
//


struct RMGetAllEpisodesResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let info: Info
    let results: [RMEpisode]
    
    
}
