//
//  RMSettingsCellViewModel.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 11/9/23.
//

import UIKit

struct RMSettingsCellViewModel: Identifiable {
    
    let id = UUID()
    
    public let type: RMSettingsOption
    public let onTapHandler: (RMSettingsOption) -> Void
    
    // MARK: - Initializer
    
    init(type: RMSettingsOption, onTapHandler: @escaping (RMSettingsOption) -> Void) {
        self.type = type
        self.onTapHandler = onTapHandler
    }
    
    // MARK: - Public
    
    public var image: UIImage? {
        return type.iconImage
    }
    
    public var title: String {
        return type.displayTitle
    }
    
    public var iconContainerColor: UIColor {
        return type.iconContainerColor
    }
}

/*


-> Setting Screen ViewModels Section


initializer ) Coming from RMSettingsOption, each cell in our Settings list is going to have an Optional Image and a title.
For a given cell ViewModel, we are going to initialize it with a type and that type will be an RMSettingsOption.

To hang on to that type, we are going to declare a private Constant called type at the top of our Struct and inside of our initializer we are going to set the value of that type equal to the value of the type we are receiving from our caller.

Instead of our image and title being Constants, we are going to make them computed properties that return the value of type we are receiving from our caller.

Head over to RMSettingsViewController.



iconContainerColor ) Coming from RMSettingsOption, we are going to RMSettingsOption's iconContainerColor Variable.
To do that, we are going to create a computed property called iconContainerColor.



Identifiable ) We want our ViewModels to be identifiable because we want to loop over a Collection of ViewModels when interfacing with SwiftUI.
So, at the top of our Struct's declaration, we are going to adopt the Identifiable Protocol.

In order for our Struct to conform to the Identifiable Protocol, we need to declare a Constant called id.
In this case, we are going to call UUID() for an id value.

We are creating a unique id for each ViewModel instance that we create.
We will also make our Struct Hashable which works alongside it being Identifiable.

The purpose of having our Struct adopt Identifiable is so that when SwiftUI loops over them, it will be able to disambiguate between unique ViewModels.

Head over to RMSettingsView.



*/


/*


-> Tap Setting Options Section


onTapHandler ) Coming from RMSettingsView, we are going to add another parameter to our RMSettingsCellViewModel's initializer.
Our onTapHandler will be an escaping Closure that receives an argument of Type RMSettingsOption, our Enum.

At the top of our Class we are declaring an onTapHandler Constant and that onTapHandler Constant receives a value when our caller passes it in, once that value is received, it is assigned iniside of our initializer.

Head over to RMSettingsViewController.

*/
