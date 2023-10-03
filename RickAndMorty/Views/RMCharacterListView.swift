//
//  RMCharacterListView.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 9/28/23.
//

import UIKit

protocol RMCharacterListViewDelegate: AnyObject {
    func rmCharacterListView(_ characterListView: RMCharacterListView, didSelectCharacter character: RMCharacter)
}

/// View that handles showing list of characters, loader, etc.
final class RMCharacterListView: UIView {
    
    public weak var delegate: RMCharacterListViewDelegate?
    
    private let viewModel = RMCharacterListViewViewModel()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        // collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(
            RMCharacterCollectionViewCell.self,
            forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier
        )
        
        collectionView.register(
            RMFooterLoadingCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier
        )
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(collectionView, spinner)
        
        addConstraints()
        spinner.startAnimating()
        viewModel.delegate = self
        viewModel.fetchCharacters()
        setUpCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setUpCollectionView() {
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
    }
}

extension RMCharacterListView: RMCharacterListViewViewModelDelegate {
    func didSelectCharacter(_ character: RMCharacter) {
        delegate?.rmCharacterListView(self, didSelectCharacter: character)
    }
    
    func didLoadInitialCharacters() {
        spinner.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData() // Initial fetchCharacters()
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 1
        }
    }
}

/*


-> Character List View Section


RMCharacterListView ) RMCharacterListView is a UIView Cocoa Touch Class.
We could put our spinner inside of the ViewController, but that will make our code messy, instead we are going to create a dedicated View called RMCharacterListView inside of our Views Group.

From the get-go we are going to finalize the Class, so that no other Class can SubClass it.
Returning to our RMCharacterViewController, we are going to display this View on the screen.



Design ) This View is going to hold all of our UI logic, it will show the spinner, it is going to hold onto an instance of our ViewModel, etc. which means that our RMCharacterViewController is going to play a small part in displaying Characters on the screen.



private ) Notice that as we go along we are making everything private.
A good rule of thumb is if it does not need to be public, then it should be private.

Some developers will make it internal, which means they won't declare it public or private, but we are better off by using the appropriate Access Control from the get-go.



spinner ) We are using a block pattern to create our spinner, the block pattern is an Anonymous Closure.
We will use the block pattern often in our project.

We set .translatesAutoresizingMaskIntoConstraints equal to false because we will use AutoLayout.
To add our spinner on RMCharacterListView's screen, we are going to pass our instance of UIActivityIndicatorView into the addSubview() Function.

To put the spinner on the screen, we set our constraints.

The size of our spinner will be 100 by 100.
We will position our spinner in the middle of the screen, this is done by setting the centerXAnchor equal to the centerXAnchor of its parent View and the centerYAnchor equal to the centerYAnchor of its parent View.

The parent View is the current View we are in, that is the RMCharacterListView.



fetchCharacters ) Once our spinner is working, we want to return to call our ViewModel's .fetchCharacters() Function so that we can get the data that we want to display on the screen, this is done inside of our UIView's initializer.



Mechanics )This View needs a Grid and a notification that will notify this View to stop showing the spinner and display the data instead.



UICollectionView ) UICollectionView helps us model a Grid of Views that are equally sized and spaced out.
To create it, we are again going to use the block pattern.

When creating the UICollectionView instance, we are asked for the collectionViewLayout, that is why we need to declare the layout first.

By default, we want our collectionView to be hidden because there is no reason to show an empty View if we are showing a spinner, once we have the data, we make the spinner invisible.

We are setting the .alpha property of collectionView to zero, so that we can animate the collectionView onto the screen.

Once our collectioView is created, we need to set .translatesAutoresizingMaskIntoConstraints equal to false.
Then, we are going to register the cell that we want to show for each node in our Grid, for now we are going to register the base cell :

    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")



layout.sectionInset ) UICollectionViewFlowLayout lets us control our collectionView's insets.
We are going to give our left and right insets a value of 10 so that they push off from the edge of the screen.

We can also control the direction in which our cells scroll via layout.scrollDirection.



Order ) Notice that we changed the order in which we are adding our Views to the parent View.
addSubview() only allows us to add one View at a time, but we want to add more than one View at a time, so within our Resources Group, we are going to create a Swift file called Extensions.



Constraints ) We want to pin our collectionView to the top left and bottom of the screen, so we don't need to include view.safeAreaLayoutGuide like we did for our RMCharacterViewController



Delegate/DataSource ) A UICollectionView can take a Delegate and a DataSource.
The DataSource is responsible for giving our UICollectionView data.

The Delegate is responsible for handling events for our View.
An example of an event is a user tapping on a cell in our Grid, that action would require the Delegate to show a new screen or a pop-up.



setUpCollectionView ) After our addConstraints() Function, we set up a setUpCollectionView() Function.
It is legal to have our RMCharacterListView conform to the UICollectionView's Protocols, but instead we will have our RMCharacterListViewModel conform to those Protocols.

Once our RMCharacterListViewModel conforms to UICollectionViewDataSource, we can set the .dataSource property of our collectionView equal to our viewModel instance within the setUpCollectionView() Function.


Testing ) To test our User Interface, we are going to place a DispatchQueue inside of our setUpCollectionView() Function :

    DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
        self.spinner.stopAnimating()

        self.collectionView.isHidden = false
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 1
        }
    })

The purpose here is to go through the motions of how our cells are going to animate on the screen.



Delegate ) Currently, our cells aren't sized correctly and they are in a column of 6, so we are going to make our viewModel the .delegate of our collectionView.

Then, returning to our RMCharacterListViewViewModel, we are going to conform to UICollectionViewDelegate.



Summary ) We hard coded our cells, but the point was to set up the foundation for our RMCharacterListView.
We set up a ViewModel that fetches data and conforms to UICollectionViewDataSource and UICollectionViewDelegate, we created a basic View that displays a spinner if there is no data and a collectionView if data is provided.

*/


/*


-> Character Cell Section


RMCharacterCollectionViewCell ) We registered UICollectionViewCell.self as the cell of our collectionView with an id of cell, but this is not what we want.

We want a custom cell that is going to display information about a character such as an image or a name.
But before we start designing, we are going to create a UICollectionViewCell Cocoa Touch Class called RMCharacterCollectionViewCell inside of the Views Group.



register ) We are going to register RMCharacterCollectionViewCell as the cell of our collectionView.
Note that we are using our static Constant as the cell's identifier.



*/


/*


-> Showing Characters Section


extension ) Inside of our exetnsion, we are going to conform to our RMCharacterListViewViewModelDelegate Protocol.
To conform to the Protocol, we need to implement the didLoadInitialCharacters() Function.



didLoadInitialCharacters ) RMCharacterListViewViewModel is calling the didLoadInitialCharacters() Function inside of its fetchCharacters() Function.

When the fetchCharacters() Function runs, we will receive our initial characters.
We want to notify our adopter, RMCharacterListView, that it needs to reload its data.
To do so, we are going to call our collectionView's reloadData() Function.

The reloadData() Function is provided to us through UICollectionView.

Currently, we still have the code that we used for Testing in the previous section (Character List View Section), we will now delete that code from the setUpCollectionView() Function.

Then, inside of our didLoadInitialCharacters() Function, we are going to stop animating the spinner, reload the data, set the isHidden property equal to false, and we want the collectionView to fade onto the screen.

We are only going to call reloadData() for the initial fetch because we don't want to reload the whole view every time the user gets more Characters, we only want the Function to run when we retrieve the first batch of Characters.



*/


/*


-> Character Detail Screen


Debugging ) When we ran the simulator, we saw that the cells at the bottom where being cut off.
We fixed this problem by giving our collectionView's UIEdgeInsets object's bottom property a value of 10, before that it had a value of 0.



RMCharacterListViewDelegate ) We are in the RMCharacterListView, and we need to get the notification that we are receiving from RMCharacterListViewViewModelDelegate's didSelectCharacter() Function to the RMCharacterViewController.

To do so, we are going to continue using the Delegate-Protocol pattern.
At the top of this file, we are going to create a Protocol called RMCharacterListViewDelegate.

The Type of our Delegate interface will be AnyObject.
The reasoning for this Type is so that we can hold on to it in a weak capacity.
Notice that when we call our delegate instance, inside of the didSelectCharacter() Function, we are preceding the delegate with a question mark :

    delegate?.rmCharacterListView(self, didSelectCharacter: character)

We can preced our instance with a question mark because it is of Type AnyObject.

Our Delegate interface will have a Function called rmCharacterListView().
The rmCharacterListView() Function will take an argument of RMCharacterListView called rmCharacterListView.
The second argument is of Type RMCharacter.

We are following a naming convention when we choose the name of our Function and the names of our parameters.



delegate ) Inside of our RMCharacterListView Class, we are going to declare a RMCharacterListViewDelegate instance called delegate.



Conforming ) Currently, we have an error in our build because we need to implement the didSelectCharacter() Function that we declared in our RMCharacterListViewViewModelDelegate Protocol.

We need to implement the didSelectCharacter() Function inside of our RMCharacterListView's extension in order to conform to the RMCharacterListViewViewModelDelegate Protocol.

Inside of our didSelectCharacter() Function, we will access the delegate Variable that we created at the top of the RMCharacterListView Class and call our rmCharacterListView() Function to which we are going to pass in self for the first argument and we are going to pass in the RMCharacter object that we are receiving from our didSelectCharacter() Function.



Call Stack ) RMCharacterListView adopts the RMCharacterListViewViewModelDelegate Protocol.
The RMCharacterListViewViewModelDelegate Protocol has two Functions didLoadInitialCharacters() and didSelectCharacter().

We are using the didLoadInitialCharacters() to show the initial Characters and hide the spinner.
The didSelectCharacter() Function is used to pass the Character object, that our didSelectItemAt() Function accessed and saved, to the RMCharacterViewController, which is done by :

    ( 1 ) We declared the didSelectCharacter() Function inside of the RMCharacterListViewViewModelDelegate Protocol.
    
    ( 2 ) Our RMCharacterListViewViewModel has an instance of RMCharacterListViewViewModelDelegate.
    That instance is a Variable called delegate.

    ( 3 ) Inside of the didSelectItemAt() Function, we are accessing and saving the RMCharacter that the user tapped on.
    We are then passing that Character as the argument of our didSelectCharacter() Function which we declared in our RMCharacterListViewViewModelDelegate Protocol.

    ( 4 ) The RMCharacter that the user tapped on is being accessed and saved in the didSelectItemAt() Function.
    The RMCharactListView adopts the RMCharacterListViewViewModelDelegate Protocol.

    Since RMCharacterListView adopts the RMCharacterListViewViewModelDelegate Protocol, we receive a build error because we need to implement the didSelectCharacter() Function within our RMCharacterListView extension.

    ( 5 ) Before we receive the RMCharacter object from RMCharacterListViewViewModelDelegate, we created a new Protocol called RMCharacterListViewDelegate of Type AnyObject.

    That Protocol has a Function called rmCharacterListView().
    The rmCharacterListView() Function follows a naming convention.
    The naming convention is setting the external parameter name of the second argument (character) as didSelectCharacter.

    This naming convention helps our code be more readable because we will receive the RMCharacter object from our RMCharacterListViewViewModelDelegate's didSelectCharacter() Function.
    
    ( 6 ) After creating our RMCharacterListViewDelegate Protocol, we create an instance of it in our RMCharacterListView Class.
    The instance of RMCharacterListViewDelegate is a Variable called delegate.

    The delegate Variable is used inside of our extension to call the rmCharacterListView() Function.
    The rmCharacterListView() Function takes the RMCharacter object that our RMCharacterListViewViewModelDelegate is passing to use through its didSelectCharacter() Function.

    The purpose of implementing didSelectCharacter() in our extension is to take the RMCharacter object and pass it from the ViewModel to the View and finally to the Controller, which we will do next.

Head over to the RMCharacterViewController file.

*/

/*


-> Pagination Indicator Section


register ) Within our collectionView computed property, we are going to invoke .register(_ viewClass: ...) and we are going to pass in RMFooterLoadingCollectionReusableView.self.

The argument for the forSupplementaryViewOfKind parameter will be UICollectionView.elementKindSectionFooter.
This line of code resgisters a footer that shows up at the bottom of our collectionView.

If we want to dequeue our UICollectionReusableView, then we will need to inform the collectionView.
To do so, we need to implement the DataSource functionality for whether or not RMFooterLoadingCollectionReusableView should be shown, and that logic resiges in the RMCharacterListViewViewModel.

Head over to the RMCharacterListViewViewModel file.



*/
