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
    
    init(viewModel: RMCharacterDetailViewViewModel) {
        self.viewModel = viewModel
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
