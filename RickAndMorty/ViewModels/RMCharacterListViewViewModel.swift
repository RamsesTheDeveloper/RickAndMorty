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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemGreen
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



Subjective ) It is subjective to have the ViewModel be the data source or the Controller, etc. but in our application we will have our ViewModel be the data source.



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
