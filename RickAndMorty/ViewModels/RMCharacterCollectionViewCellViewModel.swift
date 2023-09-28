//
//  RMCharacterCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 9/28/23.
//

import Foundation

final class RMCharacterCollectionViewCellViewModel {
    public let characterName: String
    private let characterStatus: RMCharacterStatus
    private let characterImageUrl: URL?
    
    // MARK: - Initializer
    
    init(characterName: String, characterStatus: RMCharacterStatus, characterImageUrl: URL?) {
        self.characterName = characterName
        self.characterStatus = characterStatus
        self.characterImageUrl = characterImageUrl
    }
    
    public var characterStatusText: String {
        return characterStatus.rawValue
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        // TODO: Abstract to Image Manager
        guard let url = characterImageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            
            completion(.success(data))
        }
        task.resume()
    }
}

/*


-> Character Cell Section


initializer ) Our Class's initializer needs to reflect the imageView, nameLabel, and statusLabel Constants that we declared inside of our RMCharacterCollectionViewCell Class.



Properties ) We also need to make them properties, so that whenever an instance of RMCharacterCollectionViewCellViewModel is created, we are required to provide values for those properties.

At first we privatized all of our properties, but the instructor considered making characterImageUrl public in the case that our View might need to know about it, but it doesn't, it just wants to retrieve an image given an RMCharacter.

Then, we made our characterName public because we will need to assign it directly, meaning that a caller will need access to the characterName property.



characterStatusText ) This desing would make others think that our characterStatus is another Data Type, but we only want to expose the text.

To do so, we are create a public computed property called characterStatusText that returns the raw value of our chracterStatus property.



fetchImage ) We need a Function to fetch and return the image contents from a given URL.
fetchImage() is going to be a Function with a completion handler that will either have the Data or an Error.

It is likely that we will need resue this Function over and over in our application, so we are going to write the logic here and then move into its own file.

This is the Function :

    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        // TODO: Abstract to Image Manager
        guard let url = characterImageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }

            completion(.success(data))
        }
        task.resume()
    }

Before we abstract the Function, we will need to test that it works and is displaying an image on the screen, that is why we added a TODO comment.



Testing ) To illustrate that the above Function is working, we are going to create a single ViewModel, manually, to illustrate how it is going to work.

Our RMCharacterListViewViewModel's cellForItemAt() Function creates and casts our cell, this is how we will test our fetchImage() Function.



@escaping ) @escaping means that our closure/callback can escape the context of another async task.

*/
