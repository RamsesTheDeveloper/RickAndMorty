//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 10/2/23.
//

import UIKit

final class RMCharacterDetailViewViewModel {
    
    private let character: RMCharacter
    
    public var episodes: [String] {
        character.episode
    }
    
    enum SectionType {
        case photo(viewModel: RMCharacterPhotoCollectionViewCellViewModel)
        
        case information(viewModels: [RMCharacterInfoCollectionViewCellViewModel])
        
        case episodes(viewModels: [RMCharacterEpisodeCollectionViewCellViewModel])
    }
    
    public var sections: [SectionType] = []
    
    // MARK: - Initializer
    
    init(character: RMCharacter) {
        self.character = character
        setUpSections()
    }
    
    private func setUpSections() {
        sections = [
            .photo(viewModel: .init(imageUrl: URL(string: character.image))),
            .information(viewModels: [
                .init(type: .status, value: character.status.text),
                .init(type: .gender, value: character.gender.rawValue),
                .init(type: .type, value: character.type),
                .init(type: .species, value: character.species),
                .init(type: .origin, value: character.origin.name),
                .init(type: .location, value: character.location.name),
                .init(type: .created, value: character.created),
                .init(type: .episodeCount, value: "\(character.episode.count)"),
            ]),
            .episodes(viewModels: character.episode.compactMap({
                return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0))
            }))
        ]
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


/*


-> Character Detail ViewModels Section


Associated ) We are going to use associated values with our Enum cases.
The goal of using associated values is to bring in the UICollectionViewCell's we created in the CharacterDetails Group into our collectionView, but to do so we also need to take into account the ViewModels that we created in the CharacterDetails Group, which resides within the ViewModels Group.

Each of our cases is going to have an associated value of one or more ViewModels.

The photo case has only one ViewModel because we will only display one image on the screen.
The information and episodes cases will be an Array of ViewModels because there will be more than one cell in that SectionType section.



sections ) We can no longer conform to CaseIterable if our cases have associated values.
Since our Enum no longer conforms to CaseIterable, we can no longer access .allCases.

So, we will need to create sub associated values in order to create our Colletion of sections manually.
To do so, we are going to change our sections Constant to a sections Variable and we will give it a Type of SectionType Array which will have an initial value of empty Array.



setUpSections ) Our setUpSections() Function will set the value of our sections Variable by accessing the SectionType cases, it can access the SectionType cases because it is of Type SectionTypeArray.

For each case we will call that ViewModels initializer.

We will then call the setUpSections() Function in the initializer.

Once we've made these changes, we need to go into our DataSource and make changes to our numberOfItemsInSection() Function because we hard coded how many items we put in each section.

The DataSource is located in the RMCharacterDetailViewController.
Head over to the RMCharacterDetailViewController file.

*/

/*


-> Character Photo Cell Section


sections ) Coming from RMCharacterDetailViewViewModel, we are going to pass in the data that the RMCharacterDetailViewViewModel initializer is expecting.

In this case, it is expecting a URL, so we are going to pass in the Character's .image property.

RMCharacter has status, gender, type, species, origin, location, created, and episodes properties, we want to our RMCharacterInfoCollectionViewCellViewModel to have access to those properties, so we are going to pass them into our initializer.

We don't want to hard code the values for our .episodes case because the data that we will receive will be dynamic based on the Character, so we are going to invoke the .compactMap(), return a RMCharacterEpisodeCollectionViewCellViewModel, and we will pass in a URL via dollar zero.

When we run our simulator, we will have the appropriate number of cells for our UICollectionViewCells because we've funneled the appropriate data to our ViewModels that drive the Views.

Head over to RMCharacterPhotoCollectionViewCell.

*/


/*


-> Character Info ViewModel Section


setUpSections ) After creating our `Type` Enum in the RMCharacterInfoCollectionViewCellViewModel, we are going to make changes to setUpSections() .information case.

We will replace :

    private func setUpSections() {
        sections = [
            .photo(viewModel: .init(imageUrl: URL(string: character.image))),
            .information(viewModels: [
            .init(value: character.status.text, title: "Status"),
            .init(value: character.gender.rawValue, title: "Gender"),
            .init(value: character.type, title: "Type"),
            .init(value: character.species, title: "Species"),
            .init(value: character.origin.name, title: "Origin"),
            .init(value: character.location.name, title: "Location"),
            .init(value: character.created, title: "Created"),
            .init(value: "\(character.episode.count)", title: "Total Episodes"),
            ]),
            .episodes(viewModels: character.episode.compactMap({
                return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0))
            }))
        ]
    }

The change we need to make is deleting the title and placing the type in front of the value.

Head over to the RMCharacterInfoCollectionViewCellViewModel file.


*/


/*


-> Character Episode Cell Section


episodes ) We need to expose our the Character's episodes so that RMCharacterDetailViewController's didSelectItemAt() Function can push to a new screen.

Head over to RMCharacterDetailViewController.


*/
