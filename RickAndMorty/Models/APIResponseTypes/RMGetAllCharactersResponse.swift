//
//  RMGetAllCharactersResponse.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 9/28/23.
//

import Foundation

struct RMGetAllCharactersResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let info: Info
    let results: [RMCharacter]
    
    
}

/*


-> API Service Section


Schema ) The schema for RMGetAllCharactersResponse can be found at https://rickandmortyapi.com/documentation/#get-all-characters



pages ) We will use the pages property to implement unlimited scrolling.



Paging ) The Rick and Morty API will only give us 20 results back at a time, we can't get every entry in the database.
Therefore, we will need to load more data as the user scrolls down.

We made the next and prev properties Optional because there may or may not be a page available when we make a request to the API.



results ) The results property is nothing more than the RMCharacter DataType that we already created.



Testing ) Within our RMCharacterViewController, we tested our RMGetAllCharactersResponse Model.

*/
