//
//  RMEpisodeDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 10/17/23.
//

import Foundation

protocol RMEpisodeDetailViewViewModelDelegate: AnyObject {
    func didFetchEpisodeDetails()
}

final class RMEpisodeDetailViewViewModel {
    
    private let endpointUrl: URL?
    
    private var dataTuple: (RMEpisode, [RMCharacter])? {
        didSet {
            delegate?.didFetchEpisodeDetails()
        }
    }
    
    public weak var delegate: RMEpisodeDetailViewViewModelDelegate?
    
    // MARK: - Initializer
    
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
        fetchEpisodeData()
    }
    
    // MARK: - Public
    
    /// Fetch backing episode model
    public func fetchEpisodeData() {
        
        guard let url = endpointUrl, let request = RMRequest(url: url) else {
            return
        }
        
        RMService.shared.execute(request, expecting: RMEpisode.self) { [weak self] result in
            switch result {
            case .success(let model):
                // print(String(describing: success))
                self?.fetchRelatedCharacters(episode: model)
            case .failure:
                break
            }
        }
    }
    
    // MARK: - Private
    
    private func fetchRelatedCharacters(episode: RMEpisode) {
        let requests: [RMRequest] = episode.characters.compactMap({
            return URL(string: $0)
        }).compactMap({
            return RMRequest(url: $0)
        })
        
        let group = DispatchGroup()
        var characters: [RMCharacter] = []
        for request in requests {
            group.enter()
            RMService.shared.execute(request, expecting: RMCharacter.self) { result in
                defer {
                    group.leave()
                }
                
                switch result {
                case .success(let model):
                    characters.append(model)
                case .failure:
                    break
                }
            }
        }
        
        group.notify(queue: .main) {
            self.dataTuple = (episode, characters)
        }
    }
}


/*


-> API Cache Layer Section


fetchEpisodeData ) Once the RMEpisodeDetailViewViewModel instance is created within the RMEpisodeDetailViewController Class, we are going to call the fetchEpisodeData() Function.

Notice that the fetchEpisodeData() Function is being called within the constructor, which means that it will run right after the ViewModel is created.
 
 Even though we are dispatching another request with the endpointUrl that is passed into the ViewModel, we aren't creating a network call, we are instead using our cache.

If we wanted to make the application more performant, we could write the data that we are receiving from our execute() Function directly to disk in the case that the data does not change.

For example, if a Character was only featured in one Episode, then it would make sense to write that data to disk because that Character will not appear in any other episodes.

*/


/*


-> Episode Detail View Section


Coming from RMEpisodeDetailViewController.
Our Episode Detail screen is shown when the user clicks on a cell in the Episodes tab or when the user cilcks on the Episode cell at the bottom of the RMCharacterDetailView.

When that happens, we want to show the details about that particular Episode.
The Rick and Morty API path for the "single episode" request returns an id, name, air_date, episode, characters, url, and created JSON objects.

The most interesting is the characters JSON object because we will use it to show the images of the Characters that appear in that Episode. Note that the characters JSON object returns an Array of URLs that point to an RMCharacter instance.



fetchEpisodeData ) As of now, we are printing out the Episode data to the console.
However, we want to hang on to that Episode data, and we want to fetch information about all the Characters that appear in that Episode.



fetchRelatedCharacters ) To receive the characters JSON object from our API request, we are going to declare a private Function called fetchRelatedCharacters() which will take an RMEpisode object.

We will call the fetchRelatedCharacters() Function inside of our execute() Function's success case.
In that case, we are going to pass in the model holding the data we are receiving from our API request.
To avoid a retention cycle, we are going to capture self in a weak capacity.

At the top of the Function, we will declare a Constant called characterUrls of Type Array of URL.
We want to access the characters property of our RMEpisode data Type, which matches our declared Type.

We will call .compactMap() on the characters property so that we can take their values and pass them into the URL initializer.
.compactMap() will return an Array of URL which we will assign to the characterUrls Constant.



requests ) Now that we have Character URL instances, we want to convert them to requests.
To do that, we will need to kick off a request for each of our Characters.

In the CharacterDetailView, we made requests to the Rick and Morty API once the user scrolled horizontally on the Episode cells.
However, in some cases we will need to batch all of the data upfront.

Our requests Constant, will be a Collection of RMRequest instances.
We will again use .compactMap() to loop over the instances of URL in characterUrls and we will return an instance of RMRequest for that URL instance.

To shorthand this :

    private func fetchRelatedCharacters(episode: RMEpisode) {
        let characterUrls: [URL] = episode.characters.compactMap {
            return URL(string: $0)
        }

        let requests: [RMRequest] = characterUrls.compactMap {
            return RMRequest(url: $0)
        }
    }

We :

    private func fetchRelatedCharacters(episode: RMEpisode) {
        let requests: [RMRequest] = episode.characters.compactMap({
            return URL(string: $0)
        }).compactMap({
            return RMRequest(url: $0)
        })
    }

Here, the first .compactMap() is creating a Collection of URLs from the characters property and then it loops over the URL instances created to instantiate RMRequest objects that are assigned to the requests Constant.



DispatchGroup ) Once we have our requests, we are going to leverage a Dispatch Group.
Conceptually, Dispatch Groups let us kick off parallel requests which send out a notification when they have completed executing.

Essentially, we send out all of the requests at the same time and we wait until all of the data has been returned.

To do so, we are going to create an instance of DispatchGroup.
Then, we are going to loop over our requests Collection, start the group by calling .enter(), and we will pass in the request index into RMService's .execute() Function.



characters ) We expect to get a Collection of RMCharacter from our .execute() Function, so outside of the For Loop, we are going to declare a characters Variable of Type Array of RMCharacter.



defer ) The defer block holds the lase line(s) of code that will run before the program's execution exits the scope of .execute().
Under the hood, group.enter() is incrementing our operation by 1 and group.leave() is decrementing it by 1 as well.

Meaning that when group.leave() catches up to group.enter(), then our program will know that it can stop executing.



dataTuple ) Once we know that our DispatchGroup is done executing, we are going to call the .notify() Function on our DispatchGroup instance and we will notify our program on the .main queue and we will specify a closure.

The closure will tell our fetchRelatedCharacters() Function what to do once the DispatchGroup is done executing.
At the top of our RMEpisodeDetailViewViewModel Class, we are going to declare a Variable called dataTuple.
Our dataTuple will be of Type RMEpisode for the Episode object and the Collection of RMCharacter objects.

Our dataTuple will be Optional.
Our dataTuple represents the two elements that we want in our global space, but we are going to make the dataTuple private and expose it with a better API later on.

Now that we have our dataTuple, we are going to call it via self and we are going to assign it the RMEpisode instance that we are receiving from the caller and the characters Variable Collection that we put together in the Function.



RMEpisodeDetailViewViewModelDelegate ) To make use of the notification that we are receiving from our DispatchGroup, we are going to leverage the Protocol-Delegate pattern.

At the top of our file we are going to declarate a Protocol called RMEpisodeDetailViewViewModelDelegate of Type AnyObject.
Inside of the RMEpisodeDetailViewViewModelDelegate Protocol, we are going to declare a Function called didFetchEpisodeDetails().
Then, we are going to create an instance within our RMEpisodeDetailViewViewModel Class.



didSet ) Once the group.notify() Function fires off, we will update our View with didSet.
Inside of didSet, we are going to call our delegate's didFetchEpisodeDetails() Function.

Head over to the RMEpisodeDetailViewController file.

*/
