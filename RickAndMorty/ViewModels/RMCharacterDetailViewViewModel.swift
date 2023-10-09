//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 10/2/23.
//

import Foundation

final class RMCharacterDetailViewViewModel {
    
    private let character: RMCharacter
    
    enum SectionType: CaseIterable {
        case photo
        case information
        case episodes
    }
    
    public let sections = SectionType.allCases
    
    // MARK: - Initializer
    
    init(character: RMCharacter) {
        self.character = character
    }
    
    private var requestUrl: URL? {
        return URL(string: character.url)
    }
    
    public var title: String {
        character.name.uppercased()
    }
}


/*


-> Character Detail View Section


requestUrl ) The RMCharacter Type has a url property, that property gives us the endpoint for that Character.
So, we will create a public Variable that will return a URL instance witht that Character's url property.

Since our fetchCharacterData() Function is using the requestUrl, we are going to make the urlRequest Variable private.



Testing ) We added a print() statement to our fetchCharacterData() Function because it is likely that the URL instance being created does not have an id at the end, which is the case :

    https://rickandmortyapi.com/api/character

This is the URL printed to the console.
This URL is wrong because we need the id of that Character in order to get the information we need.
Head over to the RMRequest file.

There was no point in building out the fetchCharacterData() Function because our RMCharacterDetailViewViewModel is already receiving an RMCharacter instance from its initializer, but this is what we built :

    public func fetchCharacterData() {
        print(character.url)

        guard let url = requestUrl,
        let request = RMRequest(url: url) else {
            return
        }
        // print(request.url)

        RMService.shared.execute(request, expecting: RMCharacter.self) { result in
            switch result {
            case .success(let success):
                print(String(describing: success))
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
    }

This Function is not returning a trimmed down version of model, instead it is returning the entire Character model.

*/


/*


-> Compositional Layout Section


SectionType ) Our RMCharacterDetailView's compositional layout is going to adapt to the case that we chose from our SectionType Enum.

In order to incorporate SectionType's cases into our RMCharacterDetailView, we will have our Enum adopt CaseIterable.
Then, we are going to make a public sections Constant, which we will use in our RMCharacterDetailView Class.

*/
