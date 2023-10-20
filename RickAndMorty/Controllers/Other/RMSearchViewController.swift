//
//  RMSearchViewController.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 10/20/23.
//

import UIKit

// Configurable controller to search
final class RMSearchViewController: UIViewController {

    struct Config {
        enum `Type` {
            case character
            case episode
            case location
        }
        
        let type: `Type`
    }
    
    private let config: Config
    
    init(config: Config) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported") // Hitting this line will crash the application.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        view.backgroundColor = .systemBackground
    }
}

/*


-> Improve Character Tab Section


Config ) This Controller will provide the configuration for the data set that the user will search through.
At the top of our RMSearchViewController, we are going to create a Struct called RMConfig.

Within the RMConfig Struct, we are going to select the `Type` of configuration that we will use.
To do so, we are going to declare an Enum called `Type` with cases character, episode, and location.

It is legal to put Enums in Structs.

Head over to the RMCharacterViewController file.


*/
