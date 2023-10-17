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
        title = "Episode"
        view.backgroundColor = .systemGreen
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
