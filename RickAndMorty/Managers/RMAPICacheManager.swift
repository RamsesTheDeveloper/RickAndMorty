//
//  RMAPICacheManager.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 10/13/23.
//

import Foundation

/// Manages in memory session scoped API caches
final class RMAPICacheManager {
    
    // API URL: Data
    
    private var cacheDictionary: [
        RMEndpoint: NSCache<NSString, NSData>
    ] = [:]
    
    init() {
        setUpCache()
    }
    
    // MARK: - Public
    
    public func cachedResponse(for endpoint: RMEndpoint, url: URL?) -> Data? {
        guard let targetCache = cacheDictionary[endpoint], let url = url else {
            return nil // returning nil because the return object is Data
        }
        
        let key = url.absoluteString as NSString
        return targetCache.object(forKey: key) as? Data
    }
    
    public func setCache(for endpoint: RMEndpoint, url: URL?, data: Data) {
        guard let targetCache = cacheDictionary[endpoint], let url = url else {
            return
        }
        
        let key = url.absoluteString as NSString
        targetCache.setObject(data as NSData, forKey: key)
    }
    
    // MARK: - Private
    
    private func setUpCache() {
        RMEndpoint.allCases.forEach { endpoint in
            cacheDictionary[endpoint] = NSCache<NSString, NSData>()
        }
    }
}

/*


-> API Cache Layer Section


RMAPICacheManager ) We want to cache the prior API responses in case we need to reuse it.
At the moment, we are making redundant calls for our RMCharacterEpisodeCollectionViewCell.

We can save the API responses to to Core Data, write it to disk via SQL, but instead of doing that heavy work, we are going to hold it in an in-memory cache.

It is absured to load the details for episodes every time we go into a RMCharacterDetailView.

That's one small instance of inefficiency, but the larger problem lies in the episodes tab.

The episodes tab will need to load in episodes in the same way that RMCharacterDetailViewController has to.

So, we are going to leverage a new object called RMAPICacheManager, which we will save under the Managers Group.

Our goal is to hold an instance of NSCache which we will use to determine whether or not we have particular object before we make a request to the Rick and Morty API.

Head over to the RMService file.



cache ) We are going to cache by the API URL that we are hitting and the data that is returned from that URL.
At the top of our Class we are going to create an instance of NSCache.

Since NSCache automatically handles vacating data when a low memory warning comes about, then if we have multiple NSCache instances, then we can reduce the amount of data that is purged from the cache.

Meaning that it is reasonable to create caches for separate pieces of data like images, episodes, and locations because if we only have one cache, then everything saved in that cache will be purged at random.

Conversely, if our caches our separate, then they will be purged when they are no longer being used, which is to say that if we download an image it will be saved to the cache, if we use that image in a DetailView, then it will persist and only be taken off the cache if we move to a screen that no longer needs it.

If we have one single cache, then we will never understand what is being purged from the cache.



cacheDictionary ) In our RMAPICacheManager's initializer, we want to loop over all of our endpoints and create a pointer from each endpoint to an NSCache instance.

So, at the top of the Class we are going to create an empty Dictionary called cacheDictionary of Type NSCache<NSString, NSData>().
Our Dictionary has a String key and an NSCache value.



RMEndpoint ) We are going to instantiate our NSCaches based on our RMEndpoints.
Instead of setting our cacheDictionary's key are String, we can have our RMEndpoint Enum inherit from Hashable.

We also need the ability to loop over all of the cases of our RMEndpoint Enum, so we will make it adopt CaseIterable.
Head over to RmEndpoint and have it adopt Hashable and CaseIterable.



setUpCache ) Returning from RMEndpoint, we are going to set the value of our cacheDictionary by looping over all of the cases of RMEndpoint which will return an element that can go inside of our Dictionary.

To make this process simple, we are going to create a Function called setUpCache(), which we will call inside of our constructor.

Within our .forEach() Loop, we will Subscript values into our cacheDictionary, the endpoint of our Loop represents each case in our RMEndpoint Enum.

We will set the value of the key as a brand new NSCache object.
Therefore, for each case in the Enum, there is an NSCache object.



cachedResponse ) We also want a public Function that we can use to check that something is available within the cache.
To do that, we are going to declare a public Function called cachedResponse().

Our cachedResponse() Function will take an endpoint of Type RMEndpoint and an instance of URL.
Our Function will have an Optional return Type of Data.



targetCache ) Our targetCache will be located by looking for the key that the caller of the cachedResponse() Function provided.
Once we have the targetCache (the caches are broken up into Character, Episode, and Location, so we need to select the right one), we are going to get the right object by calling NSCache's .object(forKey:) Function and we are going to pass in our unwrapped URL instance.

In this case, we need to cast our URL instance into an NSString, so that it pairs with NSCache.

This works because NSCache's declaration has object(forKey:) and setObject(obj:forKey:) Functions, in our case we are going to call .object(forKey:).

The object that the .object(forKey:) Function returns is NSData, so we need to cast it into Data.



setCache ) We also need a Function that adds an object to our NSCache instance, and in this case we are going to call the .setObject(obj:forKey:) Function instead of .object(forKey:).

The setCache() Function's signature will have a data object that the caller will need to pass in when it invokes the setCache() Function.



RMService ) Once our public Functions have been created, we will use them in our RMService Class.
Head over to the RMService file.

*/
