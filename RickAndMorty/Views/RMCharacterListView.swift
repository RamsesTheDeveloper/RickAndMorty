//
//  RMCharacterListView.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 9/28/23.
//

import UIKit

/// View that handles showing list of characters, loader, etc.
final class RMCharacterListView: UIView {
    
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
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(collectionView, spinner)
        
        addConstraints()
        spinner.startAnimating()
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
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
            self.spinner.stopAnimating()
            
            self.collectionView.isHidden = false
            UIView.animate(withDuration: 0.4) {
                self.collectionView.alpha = 1
            }
        })
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
