//
//  RMSettingsOption.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 11/9/23.
//

import UIKit

enum RMSettingsOption: CaseIterable {
    case rateapp
    case contactUs
    case terms
    case privacy
    case apiReference
    case viewSeries
    case viewCode
    
    var displayTitle: String {
        switch self {
        case .rateapp:
            return "Rate App"
        case .contactUs:
            return "Contact Us"
        case .terms:
            return "Terms Of Service"
        case .privacy:
            return "Privacy Policy"
        case .apiReference:
            return "API Reference"
        case .viewSeries:
            return "View Video Series"
        case .viewCode:
            return "View App Code"
        }
    }
    
    var iconContainerColor: UIColor {
        switch self {
        case .rateapp:
            return .systemBlue
        case .contactUs:
            return .systemGreen
        case .terms:
            return .systemRed
        case .privacy:
            return .systemYellow
        case .apiReference:
            return .systemOrange
        case .viewSeries:
            return .systemPurple
        case .viewCode:
            return .systemPink
        }
    }
    
    var iconImage: UIImage? {
        switch self {
        case .rateapp:
            return UIImage(systemName: "star.fill")
        case .contactUs:
            return UIImage(systemName: "paperplane")
        case .terms:
            return UIImage(systemName: "doc")
        case .privacy:
            return UIImage(systemName: "lock")
        case .apiReference:
            return UIImage(systemName: "list.clipboard")
        case .viewSeries:
            return UIImage(systemName: "tv.fill")
        case .viewCode:
            return UIImage(systemName: "hammer.fill")
        }
    }
    
}

/*


-> Setting Screen ViewModels Section

 
displayTitle ) Coming from RMSettingsViewController, we are going to compute the title and image for each case in our Enum.
To do so, we are going to import UIKit at the top of the file.

The goal of implementing this design is so that we can abstract all of the logic associated with each case in our list that way we can derive a ViewModel from a single case. Meaning that we will select a case elsewhere in our code and that case will present a displayTitle and iconImage that will be used to create a ViewModel.

Head over to RMSettingsCellViewModel.



iconContainerColor ) Coming from RMSettingsViewController, the iPhone Settings app's list has a square around its UIImage instances.
We want to mimick that look in our application, so we are going to set a color for each of case in our RMSettingsOption Enum.

To do so, we are going to create another computed property called iconContainerColor.
For now we are going to return a random color in our Switch statement.

Since we've added this scheme, we need to expose it on the RMSettingsCellViewModel.

Head over to RMSettingsCellViewModel.



*/
