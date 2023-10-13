//
//  RMAPICacheManager.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 10/13/23.
//

import Foundation

/// Manages in memory session scoped API caches
final class RMAPICacheManager {
    
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



cacheDictionary ) In our RMAPICacheManager's initializer, we want to loop over all of our endpoints and create a pointer from each endpoint to the NSCache instance.

So, at the top of the Class we are going to create an empty Dictionary called cacheDictionary of Type NSCache<NSString, NSData>().
Although it is empty 6:39:00.


*/
