//
//  RMCharacterInfoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 10/12/23.
//

import UIKit

final class RMCharacterInfoCollectionViewCellViewModel {
    
    private let type: `Type`
    private let value: String
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        // formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ" // fractional
        formatter.timeZone = .current
        return formatter
    }()
    
    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    public var title: String {
        type.displayTitle
    }
    
    public var displayValue: String {
        if value.isEmpty { return "None" }
        
        if let date = Self.dateFormatter.date(from: value),
            type == .created {
            print("Result: " + String(describing: date))
            print("Result: " + String(describing: Self.shortDateFormatter.string(from: date)))
            return Self.shortDateFormatter.string(from: date)
        }
        
        return value
    }
    
    public var iconImage: UIImage? {
        return type.iconImage
    }
    
    public var tintColor: UIColor {
        return type.tintColor
    }
    
    enum `Type`: String {
        case status
        case gender
        case type
        case species
        case origin
        case created
        case location
        case episodeCount
        
        var tintColor: UIColor {
            switch self {
            case .status:
                return .systemBlue
            case .gender:
                return .systemRed
            case .type:
                return .systemPurple
            case .species:
                return .systemGreen
            case .origin:
                return .systemOrange
            case .created:
                return .systemPink
            case .location:
                return .systemYellow
            case .episodeCount:
                return .systemMint
            }
        }
        
        var iconImage: UIImage? {
            switch self {
            case .status:
                return UIImage(systemName: "bell")
            case .gender:
                return UIImage(systemName: "bell")
            case .type:
                return UIImage(systemName: "bell")
            case .species:
                return UIImage(systemName: "bell")
            case .origin:
                return UIImage(systemName: "bell")
            case .created:
                return UIImage(systemName: "bell")
            case .location:
                return UIImage(systemName: "bell")
            case .episodeCount:
                return UIImage(systemName: "bell")
            }
        }
        
        var displayTitle: String {
            switch self {
            case .status,
                    .gender,
                    .type,
                    .species,
                    .origin,
                    .created,
                    .location:
                return rawValue.uppercased()
            case .episodeCount:
                return "EPISODE COUNT"
            }
        }
    }
    
    init( type: `Type`, value: String) {
        self.type = type
        self.value = value
    }
}

/*


-> Character Info ViewModel Section


`Type` ) We already know what ViewModels are being created because we are creating them directly in our RMCharacterDetailViewViewModel's setUpSections() Function.

The setUpSections() Function lists all of the possible kinds of data that we can receive from our API request.
Given that we know the kinds of data that we can receive, we are going to create an Enum called `Type` with backticks and we will list out all of the cases that we can expect to receive from our API request.



init ) With our `Type` Enum created, instead of our ViewModel taking in value and title directly, we can derive the title from the Enum and instead of passing in a title, we would pass in an Enum with its associated value.

Below is the initializer that we replaced :

    public let value: String
    public let title: String

    init(
        value: String,
        title: String
    ) {
        self.value = value
        self.title = title
    }



type ) Instead of passing a title into the initialzier, we are going to pass in the type Constant.



title ) The title property's value will be computed based on the `Type` that we pass into the initializer.
Meaning that the initializer will pick out a case from the Type Enum and that case will tell our computed Variable what our title should be.

We want the title computation to return a title that we will display on the screen, we will declare that title in the Type Enum.



displayTitle ) Within the `Type` Enum we are going to create the displayTitle Variable.
The displayTitle Variable is responsible for returning a value based on a given case.

After setting up our displayTitle, we need to make changes to RMCharacterDetailViewViewModel's setUpSections() Function.
Head over to RMCharacterDetailViewViewModel to update the instantiation of RMCharacterDetailViewViewModel's ViewModels.



displayValue ) We have our displayTitle, but we don't have our displayValue, so we are going to begin by privatizing our value Constant, then inside of our displayValue Variable, we are going to return our privatized value Constant.

We are restructuring the our value in this way because within the displayValue we are able to check whether or not the value is empty, if it is empty, then there is no reason to display an empty RMCharacterInfoCollectionViewCell.

Moreover, the displayValue can also be used to control what icon is shown on the screen.



iconImage ) Within the `Type` Enum, we are going to declare another Variable called iconImage of Type UIImage which will be Optional and at the top of the file we will need to import UIKit.

Next, we are going to copy the displayTitle's switch and begin to apply different icons based on the case.
Then, we are going to create a public Variable called iconImage that is going to return type.iconImage.
Remember that type is of Type `Type` which has access to the Variables we are declaring within the `Type` Enum.



tintColor ) Another computed property that we will create within the `Type` Enum is tintColor and like we did before, we will need to expose it by creating a public Variable named tintColor that returns type.tintColor.



Design ) The computed properties that we are creating will be used within RMCharacterInfoCollectionViewCell's configure() Function where we have declared valueLabel, titleLabel, and iconImageView.

Basically, we privatize the values that our initializer receives, we create an Enum with all possible cases, we create computed properties within that Enum, we create a privatized Constant that has access to the Enum's computed properties, and finally we create public Variables that have access to the Enum's computed properties via the privatized Constant.

Those public Variabes are used in the configure Function where we change what is being displayed in the cell based on the case.

Head over to the RMCharacterInfoCollectionViewCell.



rawValue ) The displayTitle is the same as the name of the case, so we are going to assign our Enum a raw value of String which will then allow us to minimize the work we have to do.

This is what we want to avoid :

    var displayTitle: String {
        switch self {
        case .status:
            return "Status"
        case .gender:
            return "Gender"
        case .type:
            return "Type"
        case .species:
            return "Species"
        case .origin:
            return "Something"
        case .created:
            return "Something"
        case .location:
            return "Something"
        case .episodeCount:
            return "Something"
        }
    }

However, we will need to manually return a value for .episodeCount.



format Date ) Inside of the displayValue public Variable, we will format the date within an If Statement.
Before we do, we will print the date to the console to get a better understanding of the date format we are working with.

This date :

    2017-11-04T18:48:46.250Z

Is known as ISO 8601 format.
To decipher this date, we will create a static date formatter.



ISO8601DateFormatter ) Our date formatter is static because initialzing date formatters is incredibly expensive in terms of performance overhead, that is why date formatters are commonly created in a static capacity.

There is a ISO8601DateFormatter() Function that is already built-in, which we will use in our dateFormatter.
Before we return the formatter, we are going to set the timezone on it.



displayValue ) After the dateFormatter has been created, we are going to return to displayValue's If Statement and we are going to use our dateFormatter with a capital Self because it is static.

The date that we are going to pass into the .date(from) Function is stored in the value that we are receiving when the ViewModel is initialized.

To test that it is working, we are going to print out the date.



DateFormatter ) We used the ISO8601DateFormatter, but it didn't work like we thought it would :

    static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = .current
        return formatter
    }()

So, we will now create our own DateFormatter.
To create our own DateFormatter, we need to specify a string with the appropriate format, which we are able to do with .dateFormat.

We can use nsdateformatter.com if we struggle to create our DateFormatter.

The Rick and Morty API uses fractional seconds, that is why we are having trouble printing the date to the console.



shortDateFormatter ) Now that our DateFormatter is working, we are going to create a static Constant called shortDateFormatter which will have a .dateStyle of .medium and a .timeStyle of .short, that way we won't show a long String on the cell.

Our shortDateFormatter will be in charge of creating a String from the date Constant that we created in our If Let Statement.
Notice that we are using the dateFormatter before we return the date displayValue.

The date being displayed in the simulator's cell is too big, so we are going to make changes to the cell.
Head over to RMCharacterInfoCollectionViewCell's valueLabel.

*/
