//
//  RMCharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 9/28/23.
//

import UIKit

// struct RMCharacterListViewViewModel
final class RMCharacterListViewViewModel: NSObject {
    
    private var characters: [RMCharacter] = [] {
        didSet {
            for character in characters {
                let viewModel = RMCharacterCollectionViewCellViewModel(
                    characterName: character.name,
                    characterStatus: character.status,
                    characterImageUrl: URL(string: character.image)
                )
                
                cellViewModels.append(viewModel)
            }
        }
    }
    
    private var cellViewModels: [RMCharacterCollectionViewCellViewModel] = []
    
    public func fetchCharacters() {
        RMService.shared.execute(.listCharactersRequests, expecting: RMGetAllCharactersResponse.self) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                self?.characters = results
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

extension RMCharacterListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? RMCharacterCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        
        // let viewModel = cellViewModels[indexPath.row]
        // cell.configure(with: viewModel)
        
        cell.configure(with: cellViewModels[indexPath.row]) // This is a shorthand of the two lines above.
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
        // print(String(describing: model))
        print("Total: " + String(model.info.count))
        print("Page amount: " + String(model.info.pages))
        print("Page result count: " + String(model.results.count))
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

/*


-> Showing Characters Section


numberOfItemsInSection ) Currently, we are hard coding the amount of cells that we have (20), but the cells should populate dynamically as we get data and paginate.



cellForItemAt ) We hard coded a ViewModel inside of our cellForItemAt() Function by creating it and returning it.
We want to refactor our code so that we are getting our ViewModels from RMService.

Currently, we are calling viewModel.fetchCharacters() from our RMCharacterListView, but we are running .execute() from our RMCharacterListViewViewModel and handling the result here.

The reason that we are calling .execute() from this file and not RMCharacterListView is because we don't want to handle a call back from inside of RMCharacterListView's initializer.



Delegate Pattern ) We will use the Delegate pattern to update our UICollectionView's data.
The Delegate pattern will be responsible for notifying View to reload the collectionView because the data changed.



characters ) Within our ViewModel, we are going to create a Collection (Array) of RMCharacter, which will be empty by default.
Within our fetchCharacters() Function, we are going to reference our characters Collection.

We will reference self in a weak capacity within our completion handler, so that we don't cause a retain cycle.

We are going to take the data that we are receiving from execute() and we will assign it to our characters Collection.



Update UI ) Once the data we are receiving from execute() is assigned to our characters Collection, we want to update the UI.
We need our UIView to refresh the data in our collectionView (reload the DataSource data).

The



execute ) Within our execute() Function's .success case we have one result, which we will name responseModel.
ResponseModel holds all of the Characters from our list listCharactersRequests path which we declared in RMRequest's extension.

We will save all of the Characters that we are receiving from the API inside of the results Constant.
The results Constant represents the collection of results that we have.

Remember that the Data Type we are using is RMGetAllCharactersResponse, which has both a results and info property.
The info property is important because it has an Optional String, which is the URL to get more results from the API.

Therefore, we will want to retain both info and results when the application runs.



cellViewModels ) Currently, the numberOfItemsInSection() Function is displaying 20 cells, but we want the cells to reflect the number of Characters that we are receiving from the execute() Function.

However, instead of having our numberOfItemsInSection() Function getting the cells from our characters Collection directly, we are going to create a Collection of ViewModels.

The Collection of ViewModels can go in two ways :

    ( 1 ) The Collection of ViewModels can be created over and over, which is to say that the Collection will be recreated everytime we receive data from the API.

    ( 2 ) The Collection can be created once and then updated whenever we receive data from the API.


The reason that we want to hang on to our ViewModels is because we don't want to recreate them every time we get more data, as was proposed in the first approach.

The first approach is flawed because if we scroll down and download 60 characters, then it is not the best use of the device's resources to recompute those ViewModels over and over.

We want to hold onto the ViewModels because later on we will paginate and loading new data constantly.



didSet ) Whenever the value of our characters Collection is assigned (whenever it receives data from results), we are going to loop over all of our RMCharacter objects, create a ViewModel for each object in the Collection, and we are going to fill in that ViewModel.

Once that is done, we are going to append that one ViewModel to our Collection of ViewModels (cellViewModels).



Design ) The process begins in RMCharacterListView :

    ( 1 ) RMCharacterListView has an RMCharacterListViewViewModel.
    That ViewModel has a fetchCharacters() method.
    
    We are calling the fetchCharacters() method inside RMCharacterListView's overridden initializer.

    ( 2 ) RMCharacterListViewViewModel's fetchCharacters() method is calling RMService's execute() method.

    We are passing into the execute() method the .listCharactersRequests path, which we defined in our RMRequest Type.

    Another thing to point out is that we passed in a Type of RMGetAllCharactersResponse into the execute() method.
    
    RMGetAllCharactersResponse is a data Type that we created.
    That data Type has an info and results property that we will use in our logic.

    ( 3 ) The data that we receive from the execute() Function is stored in our characters Collection.
    The characters Collection is an Array of Type RMCharacter.

    The characters Collection is called in two places :
    
        ( 1 ) We are using the characters Collection inside of the characters' didSet method.
        
        ( 2 ) The second place that it is being used is in the fetchCharacters() Function.
        The characters Collection is used in the fetchCharacters() Function to save the results that we are getting back from calling execute().

    ( 4 ) Whenever our characters Collection receives data, that action will cause didSet to run.
    When didSet runs, we are going to iterate over every RMCharacter object in our characters Collection and create a viewModel, and that viewModell will be appended to our cellViewModels Collection of Type RMCharacterCollectionViewCellViewModel.

    ( 5 ) Those intances of RMCharacterCollectionViewCellViewModel are responsible for the name of the Character, the status of the Character, and the URL used to retrieve the Character's image.

    ( 6 ) The instances of RMCharacterCollectionViewCellViewModel that are created in the characters' Collection didSet method are saved to our cellViewModels Collection

    ( 7 ) The cellViewModells Collection is used to :

        ( 1 ) Tell the numberOfItemsInSection() Function how many cells we will have in our Collection.

        ( 2 ) Tell the cellForItemAt() Function which ViewModel we need to retrieve data for, which is to say that we are passing the entries inside of our cellViewModels collection to RMCharacterCollectionViewCell's configure() method, we want to download the data for those entries and those entries are holding the Character's name, status, and the URL which we need for downloading the Character's image.

    ( 8 ) As of now, the configure() method is the last step in our process.
    The configure() method is responsible for setting the values of our nameLabel, statusLabel, and imageView properties.

    The configure() method also fires off a call to our fetchImage() Function, which is declared in the RMCharacterCollectionViewCellViewModel, that Function takes an input of Type URL?, which our ViewModel provides because it has a url property.

    Note that within the fetchImage() Function we are creating a URLRequest that we are executing inside of a dataTask and the data from the dataTask is sent back to our RMCharacterCollectionViewCell's imageView to display the image.

    ( 9 ) RMCharacterCollectionViewCell is of Type UICollectionViewCell and is responsible for configuring our UILabels and UImageView and giving them constraints on the screen.



numberOfItemsInSection ) cellViewModels also has another purpose, we are going to use it in our numberOfItemsInSection() Function to determine how many cells should be shown un our collectionView.



cellForItemAt ) Also, instead of creating a ViewModel inside of our cellForItemAt() Function, we are going to read it at the given position of our existing Collection :

    cellViewModels[indexPath.row]

indexPath is an inbound argument to our cellForItemAt() Function, and it has a row and section property.
We are going to focus on row because we only have one section of data.

We could logically separate the indexPath into multiple sections if we have any, but we don't, so there is no need to do that.



Reload ) Now that our logic is set up, we will move on to xxxfile where we will tell our collectionView to reload once the data has been updated. Left off at 2:32:00


*/
