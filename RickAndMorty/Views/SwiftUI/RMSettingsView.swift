//
//  RMSettingsView.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 12/7/23.
//

import SwiftUI

struct RMSettingsView: View {
    
    let viewModel: RMSettingsViewViewModel
    
    init(viewModel: RMSettingsViewViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    RMSettingsView(viewModel: .init(cellViewModels: RMSettingsOption.allCases.compactMap({
        return RMSettingsCellViewModel(type: $0)
    })))
}

/*


-> SwiftUI Settings View Section

SwiftUI ) In the last section we put together the Settings ViewModels and in this section we are going to build out the View in SwiftUI.

SwiftUI Settings View Section Within the Views Group, we are going to create a Group titled SwiftUI.

Within the SwiftUI Group, we are going to create a SwiftUI View file called RMSettings.



viewModel ) We are going to build out a View that can receive a Collection of ViewModels for all of our cells which should be able to populate a list of selectable cells.

At the top, we are going to create a constructor and we will hang on to the ViewModel by creating a Constant called viewModel.



ScrollView ) Within the body Variable, we are going to instantiate an instance of ScrollView with a value of .vertical.



#Preview ) Given that our View's initializer has an RMSettingsViewViewModel parameter, we need to provide example data that we can use during the development process.

To do so, we are going to initialize an RMSettingsCellViewModel within #Preview.



*/
