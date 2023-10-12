//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 10/2/23.
//

import UIKit

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
    
    // MARK: - Layouts
    
    public func createPhotoSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.5)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    public func createInfoSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(150)
            ),
            subitems: [item, item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    public func createEpisodeSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 8)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.8),
                heightDimension: .absolute(150)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
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


/*


-> Create CollectionView Layouts Section


public ) Abstracting our layout Functions requires that this file import UIKit, so at the top we will import UIKit.
We also need to make the Functions public instead of private because they are being called within the RMCharacterDetailView.


*/
