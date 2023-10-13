//
//  RMEpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 10/13/23.
//

import UIKit

final class RMEpisodeDetailViewController: UIViewController {
    
    private let url: URL?
    
    init(url: URL?) {
        self.url = url // This needs to come before the super initializer is invoked.
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
