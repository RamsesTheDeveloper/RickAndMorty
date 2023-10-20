//
//  RMEpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 10/13/23.
//

import UIKit

/// VC to show details about single episode
final class RMEpisodeDetailViewController: UIViewController {
    
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
        title = "Episode"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
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
