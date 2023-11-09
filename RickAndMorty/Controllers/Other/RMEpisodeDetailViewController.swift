//
//  RMEpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 10/13/23.
//

import UIKit

/// VC to show details about single episode
final class RMEpisodeDetailViewController: UIViewController, RMEpisodeDetailViewViewModelDelegate, RMEpisodeDetailViewDelegate {
    
    // private let url: URL?
    private let viewModel: RMEpisodeDetailViewViewModel
    
    private let detailView = RMEpisodeDetailView()
    
    init(url: URL?) {
        // self.url = url // This needs to come before the super initializer is invoked.
        self.viewModel = .init(endpointUrl: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(detailView)
        addConstraints()
        detailView.delegate = self
        title = "Episode"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        
        viewModel.delegate = self
        viewModel.fetchEpisodeData()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc
    private func didTapShare() {
    }
    
    // MARK: - View Delegate
    func rmEpisodeDetailView(_ detailView: RMEpisodeDetailView, didSelect character: RMCharacter) {
        let vc = RMCharacterDetailViewController(viewModel: .init(character: character))
        vc.title = character.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - ViewModel Delegate
    
    // The Delegate MARK reminds us that we are implementing Delegate Functions.
    func didFetchEpisodeDetails() {
        detailView.configure(with: viewModel)
    }
}

/*


-> Character Episode Cell Section


RMCharacterDetailViewController's didSelectItemAt() Function is pushing to a new Controller.
This is that new Controller.

This Controller's initializer is going to take a URL which the RMCharacterDetailViewController will provide.

Head over to RMCharacterDetailViewController.


*/


/*


-> API Cache Layer Section


RMEpisodeDetailViewViewModel ) Coming from the RMService file, we are going to take the URL instance that our Controller is receiving from RMCharacterDetailViewController and we are going to create a ViewModel.

Within the ViewModels Group's CharacterDetail Group, we are going to create a Swift file called RMEpisodeDetailViewViewModel.
Head over to the RMEpisodeDetailViewViewModel file.



RMEpisodeDetailView ) Likewise, we need a View for which our RMEpisodeDetailViewViewModel will be configuring.
Within the Views Group's CharacterDetails Group, create a UIView Cocoa Touch Class called RMEpisodeDetailView.



init ) Returning RMEpisodeDetailView, we are going to create an instance of RMCharacterDetailViewController at the top of our Controller Class, instead of holding onto the URL instance passed in from RMCharacterDetailViewController.

Then, we are going to create that ViewModel instance within our initializer.
Once our ViewModel is created, we can will call RMEpisodeDetailViewViewModel's fetchEpisodeData() Function.

Head over to RMEpisodeDetailViewViewModel.


*/


/*


-> Improve Character Tab Section


detailView ) Coming from the RMEpisodeListViewViewModel, we will now build out our detail screen.
So, at the top of our RMEpisodeDetailViewController, we are going to create an instance of RMEpisodeDetailView and assign it to our detailView Constant.

We will then add it as a SubView of our Controller within the viewDidLoad() Function.

Head over to the RMEpisodeDetailView file.

Returning from the RMEpisodeDetailView, we implemented constraints to our RMDetailView instance.
Now, we want to implement a search buttom to the top right corner to the Characters, Locations, and Episodes screens.
To do so, we are going to create an addSearchButton() Function to the RMCharacterViewController.
That Function needs to be called in the viewDidLoad() Function.

We will follow the same process of implementing the addSearchButton for Locations and Episodes.
Head over to the RMCharacterViewController file.



RMSearchViewController ) Within the Other Group, we are going to create a UIViewController Cocoa Touch Class called RMSearchViewController.

This will be the Controller that we will use to provide the configuration for searching based on the kind of data that we want to retrieve from the Rick and Morty API.

After the RMSearchViewController is created, we are going to return to the RMCharacterViewController and within the didTapSearch() Function, we are going to instantiate an instance of RMSearchViewController with a `Type` of .character.

Once we've created our instance, we are going to push to it.

*/


/*


-> Episode Detail View Section


Coming from RMEpisodeDetailViewViewModel.
Currently, we are passing in an instance of RMEpisodeDetailViewViewModel to our RMEpisodeDetailViewController and we are creating an instance of RMEpisodeDetailView.

What we want to do now is assign our Delegate to the View via our ViewModel before we start fetching.
Meaning that we need to link our Delegate to our View, so that we can update it when our DispatchGroup is done running.

The edge cases that we are addressing is that our fetchEpisodeData() Function finishes before our RMEpisodeDetailViewViewModel's delegate property is assigned.

So, we are going to make the fetchEpisodeData() Function public, before it was private.



viewDidLoad ) Within the viewDidLoad() Function, we are going to access our viewModel's .delegate property and we are going to assign it a value of self, which will be the RMEpisodeDetailViewController Class.

To do so, our RMEpisodeDetailViewController Class will need to adopt the RMEpisodeDetailViewViewModelDelegate Protocol.
Once we've adopted the RMEpisodeDetailViewViewModelDelegate Protocol, we are going to call the .fetchEpisodeData() Function on our ViewModel.



didFetchEpisodeDetails ) To conform to the RMEpisodeDetailViewViewModelDelegate Protocol, we are going to implement the didFetchEpisodeDetails() Function at the bottom of our RMEpisodeDetailViewController Class.

Inside of the Function, we are going to call our detailView's .configure() Function and pass in our ViewModel.
Head over to the RMEpisodeDetailView file.


*/


/*


-> Finish Episode Details Section


delegate ) Coming from RMEpisodeDetailView, we are going to assign our RMEpisodeDetailView's delegate equal to self within viewDidLoad().
We need our Controller to adopt RMEpisodeDetailViewDelegate, so we will adopt it and we will conform to it by implementing the rmEpisodeDetailView() Function.

The last step we take after selecting a Character is create an RMCharacterDetailViewController with the selected RMCharacter instance.
The RMCharacterDetailViewController has an initializer that takes a viewModel, we are going to pass the RMCharacter instance that we are receiving from RMEpisodeDetailViewViewModel's dataTuple.

Before we push into the RMCharacterDetailViewController, we are going to set the title equal to the Character's name and set the .largetTitleDisplayMode equal to .never so that we stay consistent with our initial RMCharacterDetailViewController screen.

Once we have that in place, we need to push to the RMCharacterDetailViewController.

With this design, we are heavily reusing our ViewControllers, but it makes out application interactive.
This design is neat because we can cyclically continue in the same navigation pattern, meaning that we can continue tapping on Episodes and tapping on Characters and then tap on Episodes.


*/
