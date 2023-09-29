//
//  RMCharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 9/28/23.
//

import UIKit

// struct RMCharacterListViewViewModel
final class RMCharacterListViewViewModel: NSObject {
    func fetchCharacters() {
        RMService.shared.execute(.listCharactersRequests, expecting: RMGetAllCharactersResponse.self) { result in
            switch result {
            case .success(let model):
                // print(String(describing: model))
                print("Total: " + String(model.info.count))
                print("Page amount: " + String(model.info.pages))
                print("Page result count: " + String(model.results.count))
                print("Example image url: " + String(model.results.first?.image ?? "No image"))
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

extension RMCharacterListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? RMCharacterCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        
        
        let viewModel = RMCharacterCollectionViewCellViewModel(
            characterName: "Kurt",
            characterStatus: .unknown,
            characterImageUrl: URL(string: "https://cdn.britannica.com/82/101882-050-9FA7F900/Kurt-Cobain-Nirvana-1993.jpg")
        )
        
        cell.configure(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width-30)/2
        
        return CGSize(width: width, height: width * 1.5)
        
    }
}

/*


-> Character List View Section


RMCharacterListViewViewModel ) RMCharacterListViewViewModel is a Swift file, not a Cocoa Touch Class.
We are going to take the test code from RMCharacterViewController's API Service Section and we are going to integrate into this ViewModel.

We preceded ViewModel with ListView, that is intentional.



ViewModel ) ViewModels fit between the View, the Controller, and all other business logic needed to make that screen work.

We want our Controller to be as minimal as possible.
We want our Views, ViewModels, and all other objects to have one or a handful of responsibilites, such that we can keep our code nimble in terms of our controller sizes.



Subjective Design ) It is subjective to have the ViewModel be the data source or the Controller, etc. but in our application we will have our ViewModel be the data source.



NSObject ) In order for our ViewModel to have permission to adopt UICollectionViewDataSource, it must first be a Class and have a Type of NSObject.



UICollectionView ) RMCharacterListViewViewModel is going to be the UICollectionViewDataSource and UICollectionViewDelegate of our RMCharacterListView's UICollectionView.

In order to extend UICollectionViewDataSource, we need to import UIKit.
The Functions numberOfItemsInSection() and cellForItemAt() must be implemented in order to conform to UICollectionViewDataSource.



 UICollectionViewDelegateFlowLayout ) We conformed to UICollectionViewDelegateFlowLayout because it gives us access to the sizeForItemAt() Function.

This Function allows us to specify a size.
There's different approaches that we can take for specifying the size, but we are going to use CGSize to set a width and a height for a particular cell.

Instead of using constants, we are going to use the UIScreen.main.bounds of the current screen because the width and height of iPhones and iPads varies.

We are going to take the bounds, subtract 30 pixel and divide the whole by two because we want two columns.



Margins ) Currently our cells don't have a margin, so they are being pushed to the leading and trailing edges of the screen.

To fix this, we are going to open our RMCharacterListView and make changes to our collectionView's layout Constant.
Go inside of the comments and look for layout.sectionInset.

*/


/*


-> Character Cell Section


RMCharacterCollectionViewCell ) We are going to enter RMCharacterCollectionViewCell's static Constant as the identifier for the cellForItemAt() Function.

This is the code we are replacing and it is also the code we used while developing our RMCharacterListViewViewModel :

    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    cell.backgroundColor = .systemGreen
    return cell



Design Change ) Later on, we are going to abstract the DataSource and Delegate logic to our ViewController because our ViewController is small as of now.

This change is subjective, but it is worth seeing both approaches.



Testing ) We are going to test our RMCharacterCollectionViewCellViewModel's fetchImage() Function within RMCharacterListViewViewModel's cellForItemAt() Function :


To test fetchImage(), we cast our deque cell as RMCharacterCollectionViewCell.

Now, RMCharacterCollectionViewCell has a configure() Function that asks for a ViewModel of Type RMCharacterCollectionViewCellViewModel.

So, we are going to create that ViewModel and pass it into the RMCharacterCollectionViewCell's configure() Function.

In order to test that our cell is working, we need to open the RMCharacterCollectionViewCell and set up the contraints for the imageView, nameLabel, and statusLabel on the paernt View.



Valid Image ) To get a valid image, we are going to print it to the console :

RMService.shared.execute(.listCharactersRequests, expecting: RMGetAllCharactersResponse.self) { result in
    switch result {
    case .success(let model):
        print("Example image url: " + String(model.results.first?.image ?? "No image"))
    case .failure(let error):
        print(String(describing: error))
    }
}


Then, take that URL and enter it into our cellForItemAt() Function's hard coded ViewModel :

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? RMCharacterCollectionViewCell else {
            fatalError("Unsupported cell")
        }

        let viewModel = RMCharacterCollectionViewCellViewModel(
            characterName: "Rick",
            characterStatus: .alive,
            characterImageUrl: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
        )

        cell.configure(with: viewModel)
        return cell
    }

*/
