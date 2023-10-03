//
//  RMCharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 9/28/23.
//

import UIKit

protocol RMCharacterListViewViewModelDelegate: AnyObject {
    func didLoadInitialCharacters()
    func didSelectCharacter(_ character: RMCharacter)
}

// struct RMCharacterListViewViewModel
/// View Model to handle character list view logic
final class RMCharacterListViewViewModel: NSObject {
    
    public weak var delegate: RMCharacterListViewViewModelDelegate?
    
    private var isLoadingMoreCharacters = false
    
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
    
    private var apiInfo: RMGetAllCharactersResponse.Info? = nil
    
    /// Fetch initial set of characters (20)
    public func fetchCharacters() {
        RMService.shared.execute(.listCharactersRequests, expecting: RMGetAllCharactersResponse.self) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                let info = responseModel.info
                
                self?.characters = results
                self?.apiInfo = info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    /// Paginate if additional characters are needed
    public func fetchAdditionalCharacters() {
        isLoadingMoreCharacters = true
        print("Fetch Function is running")
        // Fetch characters
        
    }
    
    public var shouldShowLoadMoreIndicator: Bool {
        // return false
        return apiInfo?.next != nil
    }
    
    
}

// MARK: - CollectionView

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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,
              let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier,
                for: indexPath
              ) as? RMFooterLoadingCollectionReusableView else {
            fatalError("Unsupported")
        }
        
        footer.startAnimating()
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width-30)/2
        
        return CGSize(width: width, height: width * 1.5)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = characters[indexPath.row]
        delegate?.didSelectCharacter(character)
    }
}

// MARK: - ScrollView

extension RMCharacterListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator, !isLoadingMoreCharacters else {
            return
        }
        
        let offset = scrollView.contentOffset.y
        let totalContentHeight = scrollView.contentSize.height
        let totalScrollViewFixedHeight = scrollView.frame.size.height
        
        if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
            fetchAdditionalCharacters()
        }
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



Reload ) Now that our logic is set up, we are going to open the RMCharacterListView file and inside of the overridden initializer we will set our viewModel's .delegate property equal to itself :

    viewModel.delegate = self
    viewModel.fetchCharacters()

Note that we need to set the delegate before we call the Function.
Note that the delegate property was not declared beforehand, we declared it after our RMCharacterListViewViewModelDelegate Protocol was declared.

For context, RMCharacterListViewViewModel (the file that we are currently in) conforms to UICollectionViewDelegate, that is why we can open RMCharacterListView and set the instance of RMCharacterListViewViewModel that we have as the delegat of itself.

Meaning that RMCharacterListView is responsible for displaying our data on the screen and RMCharacterListViewViewModel is responsible for providing the data to that screen.



RMCharacterListViewViewModelDelegate ) To follow the Protocol-Delegate pattern, we are going to declare a protocol at the top of the file, the naming convention is the name of the file suffixed by Delegate.

Inside of this Protocol, we are going to create a single Function called didLoadInitialCharacter().



delegate ) Inside of our RMCharacterListViewViewModel Class, we are going to have a reference to our Protocol.
Notice that we are declaring this Variable as weak, that is because we don't want our Class to retain a cyclical memory pointer.

Doing so (creating a reference to the Protocol), requires that we give our RMCharacterListViewViewModelDelegate Protocol a Type of AnyObject because our Protocol needs to be Class bound so that we can capture it in a weak capacity.



fetchCharacters ) Once we have our delegate property, we will use it inside of the fetchCharacters() Function to notify our delegate that the initial characters were loaded, which is done via the .didLoadInitialCharacters() Function.

The .didLoadInitialCharacters() Function was declared in the RMCharacterListViewViewModelDelegate Protocol.

We are going to call .didLoadInitialCharacters() on the Main Thread because it is going to trigger an update on our View.
Given that we will use the Main Thread, we are going to wrap our call to .didLoadInitialCharacters() inside of a DispatchQueue :

    DispatchQueue.main.async {
        self?.delegate?.didLoadInitialCharacters()
    }

The next step is having our RMCharacterListView conform to the RMCharacterListViewViewModelDelegate Protocol.

*/


/*


-> Character Detail Screen Section


didSelectItemAt ) When we tap on a RMCharacterCollectionViewCell, we want notify our Controller that a detail page should open.
Our collectionView's Delegate is where we will do that because we have extended our RMCharacterListViewViewModel so that it conforms to UICollectionViewDelegate.

So far, we've implemented DataSource Function's in our extension such as numberOfItemsInSection(), cellForItemAt(), and sizeForItemAt().

Now we are going to implement the didSelectItemAt() Function.
The first step we take is deselecting the cell that was selected by calling the .deselectItem() Function.
The .deselectItem() Function takes an input, we are going to pass the indexPath because that is the cell being selected.

We then need to identify which object the user selected (which Character).
To do that, we will access our RMCharacter Array (characters) and subscript it to find the RMCharacter object.
To find the RMCharacter object, we need to place indexPath.row inside of the subscript.

We can access the indexPath because it is an inbound argument to the didSelectItemAt() Function.



Purpose ) The purpose of implementing the didSelectItemAt() Function is to access and hold on to the object selected.
We need to hold on to that object because when we notify our Controller that it needs to open a detail page, the Controller will need to know which object will be displayed in the detail page.



didSelectCharacter ) To notify RMCharacterViewController that it needs to open the detail page, we are going to use our RMCharacterListViewViewModelDelegate Protocol.

Inside of the RMCharacterListViewViewModelDelegate Protocol (declared at the top of this file), we are going to declare a new Function called didSelectCharacter().

The didSelectCharacter() Function is going to take an instance of RMCharacter, which is the Character that we are accessing and holding on to in our didSelectItemAt() Function.

Once our didSelectCharacter() Function is declared in the Protocol, we are going to return to the didSelectItemAt() Function and call the didSelectCharacter() Function on our delegate.

Note that the delegate Variable was declared at the top of the RMCharacterListViewViewModel Class.
Notice how we are passing in the Character object that we accessed in the previous line :

    collectionView.deselectItem(at: indexPath, animated: true)
    let character = characters[indexPath.row]
    delegate?.didSelectCharacter(character)

Once this is implemented, RMCharacterListView will have a build error.
Head over to the RMCharacterListView.



shouldShowLoadMoreIndicator ) We need to know whether we should show the loading indicator on the screen.
To do so, we are going to create a public Function called shouldShowLoadMoreIndicator() within our RMCharacterListViewViewModel Class.

From the UIView's perspective, we need to know whether a loading indicator should be shown.
We are going to leverage a footer to determine whether a loading indicator should be shown.

Once we've created our apiInfo Variable, we are going to return Boolean value based on the following computation :

    return apiInfo?.next != nil

This translates to if the .next value of apiInfo is not nil, then proceed because we have another URL with the results of the next page of Characters, which would come from a URL like so :

    https://rickandmortyapi.com/api/character/?page=2

The value of our shouldShowLoadMoreIndicator is relevant because we are using it in our scrollViewDidScroll() Function within our guard statement.



fetchAdditionalCharacters ) If shouldShowLoadMoreIndicator() returns a value of true, then we will need to show more characters.
Our fetchAdditionalCharacters() Function is responsible for getting additional characters after we've retrieved the initial 20.



UIScrollView ) To get the scroll position, we are going to accesse the position of our UIScrollView.
Our RMCharacterListView's collectionView is a UICollectionView instance.

UICollectionView inherits from UIScrollView.
UIScrollView has a Delegate on it that lets us access information about the scroll poisiton of that ScrollView.



scrollViewDidScroll ) Within another extension, we will have RMCharacterListViewViewModel adopt UIScrollViewDelegate.
Inside of the extension, we are going to implement the scrollViewDidScroll() Function.

Inside of the scrollViewDidScroll() Function, we are going to access the shouldShowMoreIndicator Variable.
Our guard statement is checking that the shouldShowLoadeMoreIndicator is true, if it is not true then we are going to return out of the Function.



apiInfo ) The RMGetAllCharactersResponse Type has an info property.
Up to this point, we haven't used the info property, but we are going to use it now.
Within the fetchCharacters() Function's .success case, we are going to save the responseModel.info to a Constant.

We want to use the info Constant in scrollViewDidScroll() Function, so we are going to save the data that we are getting back from info inside of a private Variable called apiInfo.

By default the apiInfo Variable is nil and it is a mutable Variable.
Once we have our apiInfo Variable, we are going to return to the fetchCharacters() Function's .success case and we will save the data in stored by our info Constant inside apiInfo.



*/


/*


-> Pagination Indicator Section


Footer ) We are going to create a UICollectionReusableView Cocoa Touch Class called RMFooterLoadingCollectionReusableView within our Views Group.

Long, descriptive names are better than abbreviations most of the time.
Head over to the RMFooterLoadingCollectionReusableView file.



viewForSupplementaryElementOfKind ) To dequeue our UICollectionReusableView from the collectionView, we need to specify the size of the footer as well as the Function which will dequeue the footer itself.

Inside of our CollectionView extension, we are going to implement the viewForSupplementaryElementOfKind() Function.
We don't have a use for the indexPath, but this Function is relevant because it returns a UICollectionResuableView.

We will use a Guard Statement to ensure that the UICollectionReusableView being returned is a footer :

    guard kind == UICollectionView.elementKindSectionFooter else {
        return UICollectionReusableView()
    }

Otherwise, we are going to return a base UICollectionReusableView.

If our logic is correct, then we are going to dequeue that particular View that we created.
This is done by calling .dequeueResuableSupplementaryView() on our collectionView and saving the result to a footer Constant.

Finally, we return the footer Constant.



referenceSizeForFooterInsection ) The referenceSizeForFooterInsection() Function specifies the size of our footer, which is the footer that is being returned by viewForSupplementaryElementOfKind().

To start, we are going to set the with of the CGSize object to that of the collectionView and hard code the height to 100.



shouldShowLoadMoreIndicator ) Currently, our Guard Statement is only testing for the Type of UICollectionView, but we also want to test that shouldShowLoadMoreIndicator is true.

shouldShowLoadMoreIndicator is a public Variable that we declared in this file.



Debugging ) The current code causes a crash.
Our simulator crashed because we didn't dequeue UICollectionReusableView correctly within the viewForSupplementaryElementOfKind() Function.

The compiler isn't content because we instantiated (shown in our Guard Statement excerpt above) an instance of UICollectionReusableView instead of returning it appropriately.

To statisfy the compiler, we are going to return a fatalError() within our viewForSupplementaryElementOfKind() Function's Guard Statement, and in the referenceSizeForFooterInsection() Function we are going to set the size of the footer equal to .zero if shouldShowLoadMoreIndicator is not true.

Setting the size of our footer equal to .zero makes it invisible.

When we run the application, it works now, we see that the backgroundColor of RMFooterLoadingCollectionReusableView is no longer being returned because we set the size of footer equal to .zero.



shouldShowLoadMoreIndicator ) Note that in order to test the above logic, we had to set the value of our shouldShowLoadMoreIndicator equal to false :

    public var shouldShowLoadMoreIndicator: Bool {
        return false //apiInfo?.next != nil
    }

The commented out code is show the blue backgroundColor for RMFooterLoadingCollectionReusableView.
The size for that background color can be found in the referenceSizeForFooterInsection() Function :

    return CGSize(width: collectionView.frame.width, height: 100)



spinner ) To show our spinner, we are going to cast our footer Constant to an instance of RMFooterLoadingCollectionResuableView within the viewForSupplementaryElementOfKind() Function.

Then, we are going to call the .startAnimating() Function, which we defined in the RMFooterLoadingCollectionResuableView Class.
We have access to the .startAnimating() Class because we casted our footer Constant to an instance of RMFooterLoadingCollectionResuableView.

However, now our footer Constant is an Optional, so we are going to make our footer Constant a Guard Let Statement :

    let footer = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier,
            for: indexPath
        ) as? RMFooterLoadingCollectionReusableView
        footer?.startAnimating()

    return footer

The better approach is to combine both of our Guard Statements into one :

    guard kind == UICollectionView.elementKindSectionFooter else {
        fatalError("Unsupported")
    }

    guard let footer = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier,
        for: indexPath
    ) as? RMFooterLoadingCollectionReusableView
    footer?.startAnimating() else {
        fatalError("Unsupported")
    }

    return footer



Debugging ) We had a small issue with the spinner not being shown on the simulator.
The issue was that we did not set the value of apiInfo, within shouldShowLoadMoreIndicator, equal to not nil.



scrollViewDidScroll ) Once our indicator is showing, we will return to the scrollViewDidScroll() Function and access the scrollView.contentOffset.y and save it in the offset Constant.

We will also get the scrollView.contentSize.height and save it in the totalContentHeight Constant.
Note that the content is inside of the scrollView, which is to say that the cells that populate inside of the contentView have a height and the totalContentHeight Constant is storing that height.

We accessed the scrollView.frame.size.height and saved it to the totalScrollViewFixedHeight Constant, this is the height of the entire scrollView.

When we run the simulator, we get back the following :

    Offset: 11.66...
    totalContentHeight: 2922.5
    totalScrollViewFixedHeight: 619.33..

    Offset: 21.66...
    totalContentHeight: 2922.5
    totalScrollViewFixedHeight: 654.33...

    Offset: 31.0
    totalContentHeight: 2922.5
    totalScrollViewFixedHeight: 671.33...

    Offset: 36.33...
    totalContentHeight: 2922.5
    totalScrollViewFixedHeight: 671.33...

These numbers printed because we were scrolling in the simulator.
Notice that the totalContentHeight stayed the same, that's because the cells do not change shape.

Also notice that the offset changes the totalScrollViewFixedHeight, that's because our NavigationController has a NavigationBar that shrinks whenever the user scrolls past a certain offset.

However, after a certain offset value is passed, the totalScrollViewHeight stays consistent.
This is the code that we ran in the scrollViewDidScroll() Function :

    guard shouldShowLoadMoreIndicator else {
        return
    }

    let offset = scrollView.contentOffset.y
    let totalContentHeight = scrollView.contentSize.height
    let totalScrollViewFixedHeight = scrollView.frame.size.height

    print("Offset: \(offset)")
    print("totalContentHeight: \(totalContentHeight)")
    print("totalScrollViewFixedHeight: \(totalScrollViewFixedHeight)")

When we scroll to the bottom, our offset prints our 2251.



If ) With an If Statement, we are going to take the height of the content and subtract the height of the content by the fixed height and subtract it by another 120.

We are subtracting an additional 120 because our spinner has a height of 100, which is adding to the total height and an additional 20 for the purpose of a buffer.
If the value of that arithmetic operation is greater than or equal to the offset, then we will print out :

    guard shouldShowLoadMoreIndicator else {
        return
    }

    let offset = scrollView.contentOffset.y
    let totalContentHeight = scrollView.contentSize.height
    let totalScrollViewFixedHeight = scrollView.frame.size.height

    if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
        print("Should start fetching more")
    }
    

This works because we already know that we have more Characters to load because that is what we check first in the scrollViewDidScroll() Function.

We added a breakpoint to show that our code is running as expected.
With a breakpoint, if the path of execution reaches the breakpoint, then our simulator will stop running and we will return to Xcode, which represents a successful exit.



Dynamic Updating ) Our logic within the scrollViewDidScroll() Function was implemented well because as we load more content, the contentOffset and contentSize.height will be dynamically updated and managed by the ScrollView (collectionView).



Edge Case ) Currently, we are printing the "Should start fetching more" String over and over in the simulator.
Those prints represent the device doing unnecessary work, that work being making a call to the API over and over.

To control the amount of times our code executes a call, we are going to create a private Variable called isLoadingMoreCharacters of Type Bool, by default the value of isLoadMoreCharacters will be false.

Then, we are going to test, with our Guard Statement, that the isLoadingMoreCharacters indicator is not true.
Finally, we will set the value to true if the offset is greater than or equal to the arithmetic operation we implemented :

    guard shouldShowLoadMoreIndicator, !isLoadingMoreCharacters else {
        return
    }

    let offset = scrollView.contentOffset.y
    let totalContentHeight = scrollView.contentSize.height
    let totalScrollViewFixedHeight = scrollView.frame.size.height

    if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
        print("Should start fetching more")
        isLoadingMoreCharacters = true
    }



Refactor ) We no longer need to print to the console, so we are going to call the fetchAdditionalCharacters() Function within our scrollViewDidScroll() Function's If Statement and we are going to take the isLoadingMoreCharacters equal to true code and move it into the fetchAdditionalCharacters() Function.

*/
