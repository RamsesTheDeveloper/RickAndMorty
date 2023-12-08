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
        List(viewModel.cellViewModels) { viewModel in
            HStack {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.red)
                        .padding(8)
                        .background(Color(viewModel.iconContainerColor))
                        .cornerRadius(6)
                }
                
                Text(viewModel.title)
                    .padding(.leading, 10)
            }
            .padding(.bottom, 3)
        }
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

The reason that we don't need to provide an id for our List() is because we made our RMSettingsCellViewModel adopt Identifiable.



#Preview ) Given that our View's initializer has an RMSettingsViewViewModel parameter, we need to provide example data that we can use during the development process.

To do so, we are going to initialize an RMSettingsCellViewModel within #Preview.

In order to run RMSettingsView in our simulator, we need to create an RMSettingsView in our RMSettingsViewController.

Head over to the RMSettingsViewController file.



Debug ) Coming from RMSettingsViewController, we are going to delete our ScrollView and leave our List because we can't put a List inside of a ScrollView since the List already has ScrollView functionality.



HStack ) For context, we are using .template because we want to modify our RMSettingsOption's image whereas .original would not allow us to modify the image.



*/
