//
//  RMImageLoader.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 10/3/23.
//

import Foundation

final class RMImageLoader {
    static let shared = RMImageLoader()
    
    private var imageDataCache = NSCache<NSString, NSData>()
    
    private init() {}
    
    
    /// Get image content with URL
    /// - Parameters:
    ///   - url: Source url
    ///   - completion: Callback
    public func downloadImage(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let key = url.absoluteString as NSString
        if let data = imageDataCache.object(forKey: key) {
            print("Reading from cache: \(key)")
            completion(.success(data as Data))
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            
            let value = data as NSData
            self?.imageDataCache.setObject(value, forKey: key)
            completion(.success(data))
        }
        
        task.resume()
    }
}

/*


-> Image Loader Section


NSCache ) NSCache handles getting rid of caches in our session when our memory is getting low.
The NSCache declaration shows us that it takes a KeyType and an ObjectType.

Our KeyType will be NSString, and the object that we will be saving will be NSData.



imageDataCache ) Once we have our NSCache, we are going to cast the url.absoluteString as NSString and save it in the key Constant.
We will do the same for data.

We will then access our imageDataCache and invoke the .setObject() Function, which takes an argument of NSData for a key of Type NSString.

Essentially, we are caching an NSObject that is similar to a Swift Dictionary with the data for a given URL.
In this case the NSCache has Functions for assigning objects and removing them, whereas a Swift Dictionary uses subscriptiing :

    d[1]



Caching ) Before we run our URLRequest, we will look inside of our imageDataCache and return an the image data if it is stored in our NSCache instance.

Notice that we have to cast back and forth from Swift Types and Objective-C Types.



Alternatives ) We can also write the entire image to disk, but there are drawbacks with that approach because reading and writing from disk is expesnive (heavy performance).


*/
