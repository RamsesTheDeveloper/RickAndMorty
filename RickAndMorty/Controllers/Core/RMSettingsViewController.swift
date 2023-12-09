//
//  RMSettingsViewController.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 9/27/23.
//

import SwiftUI
import UIKit

/// Controller to show various app options and settings
final class RMSettingsViewController: UIViewController {
    
    private var settingsSwiftUIController: UIHostingController<RMSettingsView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Settings"
        
        addSwiftUIController()

    }
    
    private func addSwiftUIController() {
        
        let settingsSwiftUIController = UIHostingController(
            rootView: RMSettingsView(
                viewModel: RMSettingsViewViewModel(
                    cellViewModels: RMSettingsOption.allCases.compactMap({
                        return RMSettingsCellViewModel(type: $0) { option in
                            print(option.displayTitle)
                        }
                    })
                ))
        )
        
        addChild(settingsSwiftUIController)
        settingsSwiftUIController.didMove(toParent: self)
        
        view.addSubview(settingsSwiftUIController.view)
        settingsSwiftUIController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            settingsSwiftUIController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsSwiftUIController.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            settingsSwiftUIController.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            settingsSwiftUIController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        self.settingsSwiftUIController = settingsSwiftUIController
    }
}

/*


-> Setting Screen ViewModels Section


SwiftUI ) Coming from the RMEpisodeDetailViewController, we are going to have a similar set up where we extract the View and ViewModel.
It is common to use a CollectionView or a TableView, we've used a CollectionView for the majority of this application, so we are going to use a SwiftUI View List.

Within our ViewModels Group, we are going to create a Group called Settings.
Within the Settings folder, we are going to create a Swift file called RMSettingsViewViewModel.

Each row in our List will have its own ViewModel.
For example, Rate App, Terms of Service, Privacy Policy, etc. will need a ViewModel.

Head over to RMSettingsViewViewModel.



RMSettingsCellViewModel ) We created a Struct called RMSettingsCellViewModel.
Each of the cells that we have for our Settings list is more or less going to have two pieces of information.
Each cell will need an image and a title.

When we tap on an item that in our list that we will create, we can either handle that directly in SwiftUI or we can use a Delegate/Closure to pass it back to UIKit.



RMSettingsOption ) We can create our RMSettingsViewViewModels imperatively and pass in an image and title one-by-one to create instances of RMSettingsCellViewModel, but the better design is to have a list of options that our Settings actually supports.

Within the Settings Group, we are going to create a Swift file called RMSettingsOption.
RMSettingsOption is going to be an Enum that lists out all of the cases for our Settings.

Our options are going to be in the order that we want them to appear, meaning that Rate App will be the first cell that appears in the list and View Code will be the last cell that appeas on the list.

We are going to make our Enum CaseIterable so that we can loop over all of the cases.
Inside of our Enum, we are going to compute the title and image of our cases.

Head over to RMSettingsOption.



viewModel ) Coming from RMSettingsCellViewModel, we are going to declare a private Constant at the top called viewModel of Type RMSettingsViewViewModel.

RMSettingsViewViewModel is created with a Collection of RMSettingsCellViewModel and in order to initialize an instance of RMSettingsCellViewModel, we need to provide an RMSettingsOption instance, in this case we are going to return allCases.

We want to compactMap .allCases, which means that we are going to loop over all of our cases and we are going to create an instance of RMSettingsCellViewModel for each case in our RMSettingsOption Enum.

This is done by passing in $0 as the argument of type.

The next section plugs the viewModel we've created in this step into its UIHostingController() initializer.
This is the viewModel that we created in this step :

    private let viewModel = RMSettingsViewViewModel(
        cellViewModels: RMSettingsOption.allCases.compactMap({
            return RMSettingsCellViewModel(type: $0)
        })
    )



Head over to RMSettingsOption.



*/


/*


-> SwiftUI Settings View Section


settingsSwiftUIController ) Coming from RMSettingsView, in order to interchangeably use UIKit and SwiftUI, we need to implement a Hosting View a.k.a Hosting View Controller.

UIHostingController() can be created with a rootView which in this case will be RMSettingsView.
Note that we are granted access to the rootView option when we import SwiftUI at the top of the file.

RMSettingsView needs a ViewModel in order to be initialized.
We are going to take the viewModel that we created in the previous section and we are going to plug it into UIHostingController's RMSettingsView instance.



addSwiftUIController ) Once we've created our UIHostingController() and stored it in settingsSwiftUIController, the next step is to integrate it into our UIKit based ViewController.

To do that, we are going to create a Function called addSwiftUIController() and call it inside of viewDidLoad().
We then invoke addChild() and pass in our UIHostingController instance.

We also notify RMSettingsViewController that our UIHostingController() instance is under its hierarchy, which means that the settingsSwiftUIController is a child of the RMSettingsViewController (the parent).

After we add the UIHostingController() to our ViewController's hierarchy, we are going to add our settingsSwiftUIController's View to the parent View.

We also need to set settingsSwiftUIController's View's .translatesAutoresizingMaskIntoConstraints to false and set our constraints.

Head over to RMSettingsView to debug.


*/


/*


-> Tap Setting Options Section


onTapHandler ) Coming from RMSettingsView, we are going to make our UIHostingController Optional and mutable by making Variable.
Then, we are going to take the code that we assigned to settingsSwiftUIController in the previous step and assign it to settingsSwiftUIController within the addSwiftUIController() Function with the small difference that it will be a Constant.

UIHostingController takes a Generic, <Content: View>, so we are going to specify that the UIHostingController that will be created in the future will be a HostingController for the RMSettingsView.

Meaning that we are making RMSettingsViewController's UIHostingController Optional and giving it a Type because UIHostingController requires us to do so, later on that UIHostingController is instantiated in our addSwiftUIController() Function.

We are refactoring our code because our goal is to introduce an additional parameter into our RMSettingsView.
That parameter will be used to notify our RMSettingsViewController that a cell in the List has been tapped.
We want that parameter to be a Closure that takes in the selected cell as an argument.

This is the code from the previous section :

    private let settingsSwiftUIController = UIHostingController(
        rootView: RMSettingsView(
            viewModel: RMSettingsViewViewModel(
                cellViewModels: RMSettingsOption.allCases.compactMap({
                return RMSettingsCellViewModel(type: $0)
            })
        ))
    )

Once it is added to the screen, we are going to retain the UIHostingController instance in the global scope.
We retain it by setting our settingsSwiftUIController Variable equal to our settingsSwiftUIController Constant within the addSwiftUIController() Function.

Head over to RMSettingsView.

Coming from RMSettingsCellViewModel, we are going to implement our onTapHandler in the form of a Closure within the addSwiftUIController() Function and we will print out the cell's displayTitle for now.

Head over to RMSettingsView.



Coming from RMSettingsView, 



*/
