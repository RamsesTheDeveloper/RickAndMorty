//
//  RMRequest.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 9/27/23.
//

import Foundation

/// Object that represents a single API call
final class RMRequest {
    /// API Constants
    private struct Constants {
        static let baseURL = "https://rickandmortyapi.com/api"
    }
    
    /// Desired endpoint
    private let endpoint: RMEndpoint
    
    /// Path components for API, if any
    private let pathComponents: [String]
    
    /// Query arguments for API, if any
    private let queryParameters: [URLQueryItem]
    
    /// Constructed url for the api request in string format
    private var urlString: String {
        var string = Constants.baseURL
        string += "/"
        string += endpoint.rawValue
        
        if !pathComponents.isEmpty {
            pathComponents.forEach {
                string += "/\($0)"
            }
        }
        
        if !queryParameters.isEmpty {
            string += "?"
            let argumentString = queryParameters.compactMap {
                guard let value = $0.value else { return nil }
                return "\($0.name)=\(value)"
            }.joined(separator: "&")
            
            string += argumentString
        }
        
        return string
    }
    
    /// Computed and constructed API url
    public var url: URL? {
        return URL(string: urlString)
    }
    
    /// Desired http method
    public let httpMethod = "GET"
    
    /// RMRequest constructor
    /// - Parameters:
    ///   - endpoint: Target endpoint
    ///   - pathComponents: Collection of Path components
    ///   - queryParameters: Collection of query parameters
    public init(endpoint: RMEndpoint, pathComponents: [String] = [], queryParameters: [URLQueryItem] = []) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
    
}

extension RMRequest {
    static let listCharactersRequests = RMRequest(endpoint: .character)
}

/*


-> Source Control Section


RMRequest ) RMRequest is a native Type that we will use to assemble our URL String that will ultimately pass to a URLRequest initializer.

An instance of RMRequest is going to represent a request, that instance will encapsulate the base URL, endpoint, path components, and query parameters.


*/


/*


-> RMRequest Section


url ) We are making the Type of our url Variable Optional because the URL constructor is failable :

 https://developer.apple.com/documentation/foundation/url/3126806-init



httpMethod ) The Rick and Morty API only has an HTTP method of GET, there are no UPDATE, DELETE, or CREATE methods.



Testing ) To test that our Functionality is working, we are going to open our RMCharacterViewController and create an RMRequest.



Set ) The instructor mentioned that if we gave pathComponents a Type of Set<String>, then our application would be optimizied because there would be no case in which the pathComponents could be charactercharacter or locationlocation becuase Sets hold unique instances while Arrays can hold the same instance.

But we do want pathComponents to be ordered, which Array accomodates for, so we will stick to Array of String.
Another option is NSOrderedSet.

*/


/*


-> API Service Section


extension ) Within our RMRequest extension, we are going to create a convenience object.
We are going to create some requests that we will convieniently use in our code.



listCharactersRequests ) The beauty of this design is that it improves readability.
For example, if we return to our RMCharacterViewController, we can now say :

    RMService.shared.execute(.listCharactersRequests, expecting: String.self) { result in
        switch result {
        case .success(let model):
            print(String(describing: model))
        case .failure(let error):
            print(String(describing: error))
        }
    }



*/
