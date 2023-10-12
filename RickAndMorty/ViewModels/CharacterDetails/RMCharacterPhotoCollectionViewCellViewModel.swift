//
//  RMCharacterPhotoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 10/12/23.
//

import Foundation

final class RMCharacterPhotoCollectionViewCellViewModel {
    
    private let imageUrl: URL?
    
    init(imageUrl: URL?) {
        self.imageUrl = imageUrl
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let imageUrl = imageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        RMImageLoader.shared.downloadImage(url: imageUrl, completion: completion)
    }
}

/*


-> Character Photo Cell Section


imageUrl ) We created dummy ViewModels for our cells :

    private func setUpSections() {
        sections = [
            .photo(viewModel: .init()),
            .information(viewModels: [
                .init(),
                .init(),
                .init(),
                .init()
            ]),
            .episodes(viewModels: [
                .init(),
                .init(),
                .init(),
                .init()
            ])
        ]
    }

But the ViewModel that we are receiving from RMCharacterDetailViewController's dequeueReusableCell() Function is an RMCharacter Model which holds the data that we want to use in our CharacterDetails' ViewModel Classes.

For instance, in the RMCharacterPhotoCollectionViewCellViewModel we might only need the Character's URL.
To receive that URL, we will declare an imageUrl Constant in our Class and set the URL that we are receiving from the ViewModel as the value of our imageUrl Constant.

We will do the same for the other ViewModels.

When that's done we have to update our setUpSections() Funtion's sections Array.
Head over to RMCharacterDetailViewViewModel.



fetchImage ) Since we already downloaded the Character's image in the RMCharacterListView's collectionView, then we won't need to hit the endpoint again to download the image, instead we can just pull it from our NSCache.

To pull it from our NSCache, we are going to access RMImageLoader's shared .downloadImage() Function and pass in the url that we are receiving from RMCharacterDetailViewViewModel's setUpSections() Function.

Head over to RMCharacterPhotoCollectionViewCell.

*/
