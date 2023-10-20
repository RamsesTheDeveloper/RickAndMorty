//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 9/27/23.
//

import UIKit

/// Controller to show and search for Characters
final class RMCharacterViewController: UIViewController, RMCharacterListViewDelegate {
    
    private let characterListView = RMCharacterListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"
        
        setUpView()
        addSearchButton()
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc private func didTapSearch() {
        let vc = RMSearchViewController(config: .init(type: .character))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setUpView() {
        characterListView.delegate = self
        view.addSubview(characterListView)
        
        NSLayoutConstraint.activate([
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            characterListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    // MARK: - RMCharacterListViewDelegate
    
    func rmCharacterListView(_ characterListView: RMCharacterListView, didSelectCharacter character: RMCharacter) {
        // Open detail controller for that character
        let viewModel = RMCharacterDetailViewViewModel(character: character)
        let detailVC = RMCharacterDetailViewController(viewModel: viewModel)
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
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


/*


-> API Service Section


DoCatch Test ) We are testing that our do statement is running correctly, the do statement was created within our RMService's execute() Function.

The do statement should print a JSON object to the console when the execute() Function runs.
We are going to switch on the result and break on the success case, if we receive and error, we are going to print out a String describing that failure :

    let request = RMRequest(endpoint: .character, queryParameters: [
        URLQueryItem(name: "name", value: "rick"),
        URLQueryItem(name: "status", value: "alive")
    ])

    print(request.url)

    RMService.shared.execute(request, expecting: RMCharacter.self) { result in
        switch result {
        case .success:
            break
        case .failure(let error):
            print(String(describing: error))
        }
    }

The reason that we are breaking in the success case instead of doing something with the data is because we are testing to see if our do statement is going to print out a JSON object.

The test succeeded.



RMGetAllCharactersResponse ) To test out the RMGetAllCharactersResponse Model, we ran this code inside of the viewDidLoad() Function :

    RMService.shared.execute(.listCharactersRequests, expecting: RMGetAllCharactersResponse.self) { result in
        switch result {
        case .success(let model):
            // print(String(describing: model))
            print("Total: " + String(model.info.count))
            print("Page amount: " + String(model.info.pages))
            print("Page result count: " + String(model.results.count))
        case .failure(let error):
            print(String(describing: error))
        }
    }

*/


/*


-> Character List View Section


characterListView ) To display RMCharacterListView on the screen, we need to create an instance of it in our RMCharacterViewController.

To add our instance of RMCharacterListView to RMCharacterViewController's View, we need to pass it into view.addSubview().

To put RMCharacterListView on the screen, we need to create constraints.

After running the simulator, notice that if we turn the simulator from protrait mode to landscape mode, the title of this ViewController adapts, that's because in our RMTabBarController we set .largeTitleDisplayMode to .automatic.



setUpView ) To keep our code organized, we are going to remove our constraints from the viewDidLoad() Function and place it inside of a Function caled setUpView(), setUpView() will be called from viewDidLoad().


*/


/*


-> Character Detail Screen Section


Conforming ) Our RMCharacterViewController is going to conform to the RMCharacterListViewDelegate Protocol with the goal of receiving the RMCharacter that RMCharacterListViewViewModel's didSelectItemAt() Funtion accessed and saved.

Our RMCharacterViewController has an RMCharacterListView instance called characterListView.
Inside of the setUpView() Function we are going to give RMCharacterListView'a delegate Variable a value of self, which tells the compiler that our RMCharacterViewController will be the Delegate of our RMCharacterListView.

This requires that our RMCharacterViewController Class adopt the RMCharacterListViewDelegate in its declaration.



rmCharacterListView ) Adopting the RMCharacterListViewDelegate requires that we implement the rmCharacterListView() Function.
Inside of the rmCharacterListView() Function, we are going to open the detail View Controller for that Character.

For now, we are going to create a UIViewController Cocoa Touch Class called RMCharacterDetailViewController.

That ViewController will go inside of the Controlls Group within a Group called Other.

Within the rmCharacterListView() Function, we create an instance of RMCharacterDetailViewViewModel and pass in the character argument that we are receiving from the didSelectCharacter() Function.

After the RMCharacterDetailViewController and its components are created, we create an instance of RMCharacterDetailViewController inside of the rmCharacterListView() Function and we pass in the viewModel that we created in the previous step.



RMTabBarController ) Once we've created the viewModel and the RMCharacterDetailViewController instance, we can then push to that screen via navigationController's .pushViewController() Function.

We have access to the .pushViewController() Function because we wrapped all of our ViewController instances in a UINavigationController when we initialized them in the RMTabBarController file.

That is why we are able to call .pushViewController() on navigationController.

We glossed over all of the Funtionality that UINavigationController gives us, but one of the abilities that it gives us is being able to slide one screen onto another, which is what we want for our detail screen.



Stack ) Pushing and popping from a stack is similar to working with a ZStack where we are able to put one element above another at a given time.



title ) The title on our detail screen is too large, so within the rmCharacterListView() Function, we are going to set the detailVC's .largeTitleDisplayMode equal to .never.



Unlimited Scroll ) When we scroll down on our characterListView, we need two pieces of information :

    ( 1 ) We need to know when the use has scrolled down to the bottom.

    ( 2 ) We need to know if we have more Characters to download.

We are going to add all of that business logic to our RMCharacterListViewViewModel.
Head over to the RMCharacterListViewViewModel file.

*/
