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
        static let baseUrl = "https://rickandmortyapi.com/api"
    }
    
    /// Desired endpoint
    // private let endpoint: RMEndpoint
    let endpoint: RMEndpoint
    
    /// Path components for API, if any
    private let pathComponents: [String]
    
    /// Query arguments for API, if any
    private let queryParameters: [URLQueryItem]
    
    /// Constructed url for the api request in string format
    private var urlString: String {
        var string = Constants.baseUrl
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
    
    
    /// Attempt to create request
    /// - Parameter url: URL to parse
    convenience init?(url: URL) {
        let string = url.absoluteString
        if !string.contains(Constants.baseUrl) {
            return nil
        }
        
        let trimmed = string.replacingOccurrences(of: Constants.baseUrl + "/", with: "")
        
        if trimmed.contains("/") {
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
                let endpointString = components[0] // Endpoint
                
                var pathComponents: [String] = []
                
                if components.count > 1 {
                    pathComponents = components
                    pathComponents.removeFirst()
                }
                
                if let rmEndpoint = RMEndpoint(rawValue: endpointString) {
                    self.init(endpoint: rmEndpoint, pathComponents: pathComponents)
                    return
                }
            }
            
        } else if trimmed.contains("?") {
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty, components.count >= 2 {
                let endpointString = components[0]
                let queryItemsString = components[1]
                
                let queryItems: [URLQueryItem] = queryItemsString.components(separatedBy: "&").compactMap {
                    guard $0.contains("=") else {
                        return nil
                    }
                    
                    let parts = $0.components(separatedBy: "=")
                    
                    return URLQueryItem(name: parts[0], value: parts[1])
                }
                
                if let rmEndpoint = RMEndpoint(rawValue: endpointString) {
                    self.init(endpoint: rmEndpoint, queryParameters: queryItems)
                    return
                }
            }
        }
        
        return nil
    }
    
}

extension RMRequest {
    static let listCharactersRequests = RMRequest(endpoint: .character)
    static let listEpisodesRequest = RMRequest(endpoint: .episode) // RMEpisodeListViewViewModel
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


/*


-> Character Pagination Section


Convenienve Initializer ) RMCharacterListViewViewModel's fetchAdditionalCharacters() Function has a url parameter.
The scrollViewDidScroll() Function creates and passes a URL instance to the fetchAdditionalCharacters() Function.

Once the URL instance if within the fetchAdditionalCharacters() Function, we need to make a URLRequest which will ultimately be passed to the RMService's execute() Function.

As of now, we have an explicit initializer that has an endpoint (RMEndpoint) parameter, which is inconvenient.
Instead of our explicit initializer, we will use an Optional Convenience Initializer which will take a URL instance, that instance will be parsed with the goal of assembling an RMRequest instance.

Parsing the URL is something that we will need to Unit Test later on.



String Manipulation ) Our Convenience Initializer is made Optional by placing a question mark after the init keyword :

    convenience init?(url: URL) {
        let string = url.absoluteString
        if !string.contains(Constants.baseUrl) {
            return nil
        }

        let trimmed = string.replacingOccurrences(of: Constants.baseUrl + "/", with: "") // 1

        if trimmed.contains("/") { // 2
            let components = trimmed.components(separatedBy: "/") // 3
            if !components.isEmpty {
                let endpointString = components[0]
                if let rmEndpoint = RMEndpoint(rawValue: endpointString) {
                    self.init(endpoint: rmEndpoint)
                    return
                }
            }

        } else if trimmed.contains("?") { // 4
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty {
                let endpointString = components[0] // 4
                if let rmEndpoint = RMEndpoint(rawValue: endpointString) {
                    self.init(endpoint: rmEndpoint)
                    return
                }
            }
        }

        return nil
    }

In the Convenience Initializer, we begin by taking the URL instance we are receiving and accessing its value as an .absoluteString.
We will then check that the URL instance contains the baseUrl that we defined at the top of the file, if it does not contain the baseUrl, then we know that the API will not accept our RMService's URLRequest (RMRequest).

1. The trimmed Constant stores everything after https://rickandmortyapi.com/api/
We added a forward slash to our baseUrl because it does not have one.

2. When we operate on the trimmed Constant, we want to filter for path components first and query parameters second.
Therefore, in our first If Statement we are checking that the trimmed Constant has a forward slash which is a pattern unique to path components :

    baseUrl.com/abc/tim
    abc/tim

What we are doing is removing the baseUrl, then checking that the path has components.
In the example above, abc is the path and tim is the component, that is why we remove the baseUrl and then check that the remaining URL, stored in trimmed, does contain a forward slash.

3. In the third step, we are separating the components by a forward slash.
What we are doing here is taking all of the path components, separating them at the forward slash, and placing them in the components Constant, which happens to be an Array of String.

We then check that the Array of String is not empty.
If it is not empty, then we are going to access its first element which will be the path (abc).

4. We will then save the value of the first element in a Constant called endpointString.
We will then use it to initialize an instance of RMEndpoint.

The reason that we can use RMEndpoint(rawValue:) is because our RMEndpoint Enum has a raw value Type of String per its declaration.

We could possibly have an invalid value in our endpointString, so we will unwrap it with an If Statement, and if it passes, then we call our explicit initializer to create the RMRequest needed to run RMService's execute() Function.
 
That accomplishes what we set out to do, that is why we call the explicit initializer and return.
We accomplished what we set out to do because we can create an instance of RMRequest with just an RMEndpoint, or an RMEndpoint and pathComponents, or an RMEndpoint with queryParameters, and so on.



4. If the trimmed Constant does not contain a forward slash, but it does contain a question mark, then we will go through the same process for our queryParameters.

If our initializer can't find either path components or query parameters, then we are going to return nil.

Returning to RMCharacterListViewViewModel, we will create our RMRequest.
Head over to the RMCharacterListViewViewModel file.



Debugging ) We forgot to handle our Convenience Initializer's queryParameters, which caused an error.
To be safe, we are going to make sure that the count of our components is greater than or equal to 2 before we enter the curly braces :

    else if trimmed.contains("?") {
        let components = trimmed.components(separatedBy: "?")
        if !components.isEmpty, components.count >= 2 {
            let endpointString = components[0]
            let queryItemsString = components[1]

            let queryItems: [URLQueryItem] = queryItemsString.components(separatedBy: "&").compactMap {
                guard $0.contains("=") else {
                    return nil
                }

                let parts = $0.components(separatedBy: "=")

                return URLQueryItem(name: parts[0], value: parts[1])
            }

            if let rmEndpoint = RMEndpoint(rawValue: endpointString) {
                self.init(endpoint: rmEndpoint, queryParameters: queryItems)
                return
            }
        }
    }

We are going to transform all of the strings that we have in our queryItemsString into instances of URLQueryItem, but before we do, we will check that there is an equal sign between the name and value.

We will use the parts Constant to create the URLQueryItem.
If all goes well, then we are going to enter the queryItems into self.init().

Headover to RMCharactListViewViewModel.

*/


/*


-> Character Detail View Section


pathComponents ) After running our RMCharacterDetailViewViewModel's fetchCharacterData() Function, we realized that the pathComponents for our RMRequest instance were not showing up.

To create the path components, we need to pass in pathComponents to the RMEndpoint initializer.
Before we do, we will check that the value of our components Constant is greater than one.

We will save the objects in the components Array in the pathComponents Array and we will remove the first element in the Array because the first element in the Array represents the Character endpoint.






*/
