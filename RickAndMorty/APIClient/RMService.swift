//
//  RMService.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 9/27/23.
//

import Foundation

/// Primary API service object to get RIck and Morty data
final class RMService {
    /// Shared singleton instance
    static let shared = RMService()
    
    /// Privatize Constructor
    private init() {}
    
    enum RMServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
    }
    
    public func execute<T: Codable>(
        _ request: RMRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void) {
            guard let urlRequest = self.request(from: request) else {
                completion(.failure(RMServiceError.failedToCreateRequest))
                return
            }
            
            let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(error ?? RMServiceError.failedToGetData))
                    return
                }
                
                // Decode response
                do {
                    let result = try JSONDecoder().decode(type.self, from: data)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    
    // MARK: - Private
    
    private func request(from rmRequest: RMRequest) -> URLRequest? {
        guard let url = rmRequest.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = rmRequest.httpMethod
        return request
    }
}

/*


-> Source Control Section


Singleton Pattern ) Our RMService Class will be responsible for making API calls.
To begin, we will use the singleton pattern.

We enforce the singleton pattern by making our Class's initializer private.

*/


/*


-> API Service Section


MARK ) MARK signals that we will create private utilities within our application.



request ) We are going to take the instance of RMRequest that we are receiving from execute() and we are going to create our URLRequest.

Our request() Function is going to take an RMRequest and return a URLRequest.
Before we pass our URL into the request() Function, we will a guard statement to check that the value we are receiving is valid. Our return Type, URLRequest?, must be Optional because our guard statement returns nil if no value is found within rmRequest.url.

Once we know that the value of our URL is valid, we are going to pass it into our URLRequest initializer.
Since RMRequest assembles our URL String, we don't have to do as much in our request() Function.



urlRequest ) Within our execute() Function we are going to call the request Function.
We can only call the request() Function from the RMService file.

Notice that we pass in the RMRequest we are receiving from the caller, that is request which was declared in the Function Signature, into .request(from:).

If we fail to make our URLRequest, then we are going to pass back a failure in our completion handler.



RMServiceError ) Within our RMService Class, we are going to declare custom errors that we will use within the completion handler of our execute() Function.



DataTask ) If our urlRequest Constant is valid, we are going to pass it into .dataTask(with:completionHandler:).
Our guard statement is checking two things, the first is to see that we have data, the second is checking that the error is nil. If we don't have data or if we have an error, then our program enters the curly braces.

Inside of the curly braces we are going to return a completion with the appropriate error.
If we are not given an error directly from .dataTask(), which is represented by error, then we are going to return failedToGetData which comes from our custom Error Enum. Basically, an error will either occur and our completion handler will return it, but in the case that we do not receive an error, then we know that we didn't receive data, so we return the failtedToGetData case.



DoCatch Test ) Our DoCatch statement is using the try keyword, therefore, within the catch statement we are going to catch the error and bubble it up via the completion handler.

We don't call the success case within the do statement right away, the reason being that we need to decode the data that we are receiving from .dataTask(with:completionHandler:) to the Type that the caller is expecting.

For testing purposes, we are going to print the JSON object to the console :

    do {
        let json = try JSONSerialization.jsonObject(with: data)
        print(String(describing: json))
    }
    catch {
        completion(.failure(error))
    }

We are going to test run our execute() Function within the RMCharacterViewController we are looking to see the JSON object printed to the console.



DoCatch Data ) Now that our logic is tested, we are going to decode the data we are receiving from .dataTask(with:completionHandler:).

Within the JSONDecoder().decode() Function we are going to enter type.self.
type.self is the argument that the caller passed into the execute() Function.
Once we have that we are going to pass in the result into our completion handler.

To recap, it is up to the caller, which we've used RMCharacterViewController as an example, to pass in an appropriate model, we are using that model as both the Generic Type and the expecting Type.

The expecting Type is the Type that the caller expects to get back.
Then, within our do statement we are again using the type that was passed into our execute() Function.
Notice that type.self is referring to type, which was declared in our Function Signature.

*/
