//
//  RMCharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 10/2/23.
//

import UIKit

/// Controller to show info about single character
final class RMCharacterDetailViewController: UIViewController {
    
    private let viewModel: RMCharacterDetailViewViewModel
    
    private let detailView: RMCharacterDetailView
    
    // MARK: - Initializer
    
    init(viewModel: RMCharacterDetailViewViewModel) {
        self.viewModel = viewModel
        self.detailView = RMCharacterDetailView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.title
        view.addSubview(detailView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        addConstraints()
        // viewModel.fetchCharacterData()
        
        detailView.collectionView?.delegate = self
        detailView.collectionView?.dataSource = self
    }
    
    @objc
    private func didTapShare() {
        
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

// MARK: - CollectionView

extension RMCharacterDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        if indexPath.section == 0 {
            cell.backgroundColor = .systemPink
        } else if indexPath.section == 1 {
            cell.backgroundColor = .systemGreen
        } else {
            cell.backgroundColor = .systemBlue
        }
        
        return cell
    }
}

/*


-> Character Detail Screen Section


Lifecycle ) The instructor made a MARK above the viewDidLoad() Function because they are known as Lifecycle Functions.


That is the pattern, we have a View and that View has a ViewModel which our Controller interacts with.



initializer ) Our initializer will take a viewModel as input.
That ViewModel will be of Type RMCharacterDetailViewViewModel.

The steps to building out the ViewController are :

    ( 1 ) Create the ViewController.
    We created a UIViewController Cocoa Touch Class called RMCharacterDetailViewController.

    ( 2 ) Create the View.
    We created a UIView Cocoa Touch Class called RMCharacterDetailView within the Views Group.

    ( 3 ) Create the ViewModel.
    We created a Swift file called RMCharacterDetailViewViewModel inside of the ViewModels Class and gave it a default initializer.

    ( 4 ) Create the ViewController initializer.
    Once RMCharacterDetailViewViewModel was given an initializer, we created our ViewController's initializer and set a parameter called viewModel of Type RMCharacterDetailViewViewModel.

This is the pattern, we have a View and that View has a ViewModel which our Controller interacts with by creating a parameter for that viewModel.

Our initializer needs to know which Character we are showing the detail screen for, that means that the ViewModel needs to pass in the Character.

This is accomplished by giving our RMCharacterDetailViewViewModel's initializer a parameter called character of Type RMCharacter.
We also need to declare a character Constant within the RMCharacterDetailViewViewModel Class.

Once that's done head over to the RMCharacterViewController.



title ) We want to show the title of the Character when we pop to the detail screen.
To do so, we need to retain the viewModel that we are receiving from RMCharacterViewController, so we created a Constant at the top called viewModel of Type RMCharacterDetailViewViewModel.

That Constant does not have a value until we assign the value that we are receiving from our initializer to the Constant, which is what we did when we called self.viewModel.

Then, we accessed that viewModel's .title property.
Currently, the title is too big, so head over to the RMCharacterViewController file.


*/


/*


-> Character Detail View Section


RMCharacterDetailView ) The Rick and Morty API provides a schema/path for getting a single Character.
The schema has keys for the episodes that the character appears in and the location of that Character among other data.

To build out our detail screen, we are going to leverage a UICollectionView.
However, we are going to use a Compositional Layout.

Head over to the RMCharacterDetailView file.



UIBarButtonItem ) We want to place a share button at the top right of our RMCharacterDetailView, so inside of RMCharacterDetailViewController's viewDidLoad() Function we are going to assign a UIBarButtonItem to navigationItem.rightBarButtonItem.

The initializer we chose for UIBarButtonItem requires a selector, we created the Function for the selector with an @objc annotation.

Head over to the RMCharacterDetailViewViewModel file.



fetchCharacterData ) The RMCharacterDetailView has a public urlRequest Variable which stores a URL instance.
We are going to call RMCharacterDetailViewViewModel's fetchCharacterData() Function to retrieve the Character at that URL.

The fetchCharacterData() Function will fetch the information for the Character that our RMCharacterDetailViewViewModel is presenting for us.

The urlRequest Variable was made private.

The fetchCharacterData() Function will be called from the viewDidLoad() Function, it requires that we invoke it on the viewModel.
 There was no point in building out the fetchCharacterData() Function because our RMCharacterDetailViewViewModel is already receiving an RMCharacter instance from its initializer, so we will comment out the call to the Function from the viewDidLoad() Function.





*/


/*


-> Compositional Layout Section


DataSource/Delegate ) Towards the bottom of the file, we are going to extend the RMCharacterDetailViewController Class.
After we'll have the Controller adopt the UICollectionViewDataSource and UICollectionViewDelegate Protocols.

For now, within the extension, we are going to call the numberOfItemsInSection() Function and return 20.
Then, we are going to call the cellForItemAt() Function and create a default cell like we did in previous section.

Head over to the RMCharacterDetailView file.

Returning from the RMCharacterDetailView file, within the viewDidLoad() Function, we are going to set our collectionView's .delegate property equal to self (RMCharacterDetailViewController Class) and we will do the same for the .dataSource.



NSDirectionalEdgeInsets ) When we run our simulator, a pink block is diplayed on screen.
Our 20 cells are present in that block, but we must provide a value to the .contentInsets Variable, within RMCharacterDetailView's createSection() Function, in order to see our sections on the screen.



Initializer ) Since our RMCharacterDetailView requires a viewModel, we can no longer instantiated at the top of our Class like so :

    private let detailView = RMCharacterDetailView()

Instead, we won't instantiate it and we will create an instance of RMCharacterDetailView within RMCharacterDetailViewController's initializer after the RMCharacterDetailViewViewModel is created.

The reason this works is because our Controller is required to create a viewModel and our RMCharacterDetailView needs a viewModel in order to be instantiated, therefore this approach kills two birds with one stone.

Returning to RMCharacterListView, we are going to use the viewModel we are passing in here, in the createSection() Function.



numberOfSections ) The numberOfSections() Function is going to return our viewModel's .sections.count.
We will also change the number of cells being returned in the numberOfItemsInSection() Function from 20 to 10.

We are doing this because we want to have some gummy data to work with.



cellForItemAt ) In order to develop the cases of our SectionType, we are going to create an If Statement that will change the color of the cells in our RMCharacterDetailView based on the case :

    let cell = collectionView.dequequeReusableCell(withReuseIdentifier: "cell", for: indexPath)

    if indexPath.section == 0 {
        cell.backgroundColor = .systemPink
    } else if indexPath.section == 1 {
        cell.backgroundColor = .systemGreen
    } else {
        cell.backgroundColor = .systemBlue
    }
    
    return cell

For now, the simulator is showing all of the colors on the screen, but our goal is to change what is being shown based on the SectionType case.

*/
