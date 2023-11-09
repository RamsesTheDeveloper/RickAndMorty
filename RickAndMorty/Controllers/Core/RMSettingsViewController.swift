//
//  RMSettingsViewController.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 9/27/23.
//

import UIKit

/// Controller to show various app options and settings
final class RMSettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Settings"

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

*/
