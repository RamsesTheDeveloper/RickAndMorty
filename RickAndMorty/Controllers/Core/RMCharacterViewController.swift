//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 9/27/23.
//

import UIKit

/// Controller to show and search for Characters
final class RMCharacterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"
        
    }
}


/*


-> Introduction Section


view.backgroundColor ) We are going to support both light mode and dark mode, so we are going to set the value of view.backgroundColor equal to .systemBackground.



title ) The title property is used to set the title of the ViewController's NavigationBar.


*/


/*


-> RMRequest Section


Testing Endpoints ) To test our endpoints, we ran this code inside of RMCharacterViewController's viewDidLoad() Function :

    let request = RMRequest(endpoint: .location)
    print(request.url)

Note that we ran this test for all of our cases, not just .location.



Testing RMRequest ) To test our RMRequest Type, we ran this code inside of RMCharacterViewController's viewDidLoad() Function :

    let request = RMRequest(endpoint: .character, pathComponents: ["1"])
    print(request.url)
 
    let request = RMRequest(endpoint: .character, queryParameters: [
    URLQueryItem(name: "name", value: "rick"),
    URLQueryItem(name: "status", value: "Alive")]
    )
    print(request.url)


Testing RMService ) To test RMService's execute Function, we ran this code inside of RMCharacterViewController's viewDidLoad() Function :

    let request = RMRequest(endpoint: .character, queryParameters: [
        URLQueryItem(name: "name", value: "rick"),
        URLQueryItem(name: "status", value: "alive")
    ])

    RMService.shared.execute(request, expecting: RMCharacter.self) { result in
        switch result {
        case .success(RMCharacter)
        }
    }

Notice that we passed in the Type that we were expecting to the execute() Function, in this case that Type is RMCharacter.self.

When we receive our result in the .success case, we are given an RMCharacter.
The reason that our execute() Function asks for the Type we are expecting and returns that Type is because we passed a Generic into the execute() Function.


*/
