//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 10/2/23.
//

import Foundation

final class RMCharacterDetailViewViewModel {
    
    private let character: RMCharacter
    
    init(character: RMCharacter) {
        self.character = character
    }
    
    public var title: String {
        character.name.uppercased()
    }
}
