//
//  RMCharacterEpisodeCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 10/12/23.
//

import UIKit

protocol RMEpisodeDataRender {
    var name: String { get }
    var air_date: String { get }
    var episode: String { get }
}

final class RMCharacterEpisodeCollectionViewCellViewModel: Hashable, Equatable {
    
    private let episodeDataUrl: URL?
    private var isFetching = false
    private var dataBlock: ((RMEpisodeDataRender) -> Void)?
    
    public let borderColor: UIColor
    
    private var episode: RMEpisode? {
        didSet {
            guard let model = episode else {
                return
            }
            
            dataBlock?(model)
        }
    }
    
    init(episodeDataUrl: URL?, borderColor: UIColor = .systemBlue) {
        self.episodeDataUrl = episodeDataUrl
        self.borderColor = borderColor // Retains argument passed in by caller.
    }
    
    // MARK: - Public
    public func registerForData(_ block: @escaping (RMEpisodeDataRender) -> Void) {
        self.dataBlock = block
        
    }
    
    public func fetchEpisode() {
        
        guard !isFetching else {
            
            if let model = episode {
                dataBlock?(model)
            }
            
            return
        }
        
        guard let url = episodeDataUrl, let request = RMRequest(url: url) else {
            return
        }
        
        isFetching = true
        
        RMService.shared.execute(request, expecting: RMEpisode.self) { [weak self] result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self?.episode = model
                }
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.episodeDataUrl?.absoluteString ?? "")
    }
    
    static func == (lhs: RMCharacterEpisodeCollectionViewCellViewModel, rhs: RMCharacterEpisodeCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

/*


-> Episode Fetch Section


fetchEpisode ) The RMCharacterEpisodeCollectionViewCellViewModel receives a URL.
That URL sends us to another endpoint that has the information for a given episode.

The object that the initial URL points us to has properties such as id, name, air_date, etc.
Those properties are modeled by our RMEpisode Struct.

To populate that data, we will need to make an API request to the Episode endpoint.
For now, we are going to focus on dispatch groups and caching the data.

Within the fetchEpisode() Function, we want to begin by unwrapping the url that we are receiving from RMCharacterDetailViewController's cellForItemAt() Function.

Likewise, we want to create an instance of RMRequest with that unwrapped url.



configure ) As of now, our ViewModel is not printing correctly, so we will need to make changes to RMCharacterDetailViewController's cellForItemAt() Function.

Head over to RMCharacterDetailViewController.

We are experiecing a problem because we failed to call the fetchEpisode() Function from our RMCharacterEpisodeCollectionViewCell's configure() Function.

We have an interesting problem that we need to tackle.
The design we have so far dequeue's a cell from RMCharacterDetailViewController's cellForItemAt() Function, when a cell is dequeued, RMCharacterEpisodeCollectionViewCell's configure() Function is called, and in some cases it will be called upwards of 50 times depending on how many episodes the character has been featured in.

If the configure() Function is called over and over, then the device will be fetching the data over and over.

This problem can be solved by :

    ( 1 ) We can have a flag in the ViewModel that signals that we've already fetched the data for that episode.
    If the flag is false then we will fetch that data.

    ( 2 ) The other option is preempitvely dispatching a request for all the episodes up front behind the scenes via background fetches, that way we can have all of the data ready by the time that our cells are shown on screen.



isFetching ) In our case, we are going to use a flag and later on we will use dispatchGroups.
At the top we will declare a private Variable called isFetching with an initial value of false.

Then, in our fetchEpisode() Function, we are going to verify that isFetching has a value of false and if it is false then our Function will continue executing.

After our RMRequest instance is created, we are going to set isFetching equal to true.



episode ) Our RMCharacterEpisodeCollectionViewCellViewModel needs a way to save the information that we are receiving from fetchEpisode(), so we are going to declare a private Variable called episode of Type RMEpisode.

Then, in our fetchEpisode() Function, we are going to save the success case (data) in the episode Variable.



Publisher-Subscriber ) Once we have the data, we need to inform our View that it needs to refresh itself.
We can again use the Protocol-Delegate pattern, but we are going to use Publisher-Subscriber pattern instead.

Within the episode Variable, we are going to implement a didSet property setter.



registerForData ) We will also create a public Function called registerForData() which will take a block and return the name, air_date, and episode.

Instead of passing in all of those values, we are going to create a Protocol and return it in our completionHandler.
RMEpisodeDataRender is the Protocol that we are returning from our completion handler.

This approach allows us to hide RMEpisode's other properties.

To call the block, we will need to hang on to it in the global scope.
So, we are going to create a private Variable called dataBlock and its Type will be the same as the registerForData() Function's signature.

Then, in the registerForData() Function, we are going to assign the block argument as the value of dataBlock.



RMEpisodeDataRender ) At the top we are going to create a Protocol called RMEpisodeDataRender.
The Protocol is going to represent an episode rendering.

This Protocol is going to define the signature of the data we need.
In this case, we want that signature to be the name, air_date, and episode.

Those signatures are a subset of the RMEpisode properties, so we will have our RMEpisode conform to our RMEpisodeDataRender Protocol.

Head over to RMEpisode and adopt RMEpisodeDataRender.
We are printing our data to the console, but we are receiving all of the properties instead of just the ones we picked out in our RMEpisodeDataRender Protocol, the reasonning for this is because the complete object is an RMEpisode and we are just picking out the properties that we want to use.



didSet ) Once we assign a value to the episode, we will pass in the model we are receiving to the dataBlock Variable.
Head over to RMCharacterEpisodeCollectionViewCell.



Edge Case ) We have an unhadled edge case in our registerForData() Function :

    guard !isFetching else {
        return
    }

This is an edge case because if we've already fetched the data, and the user brings the cell back into the View, then we would need to manually call the dataBlock and pass in the model.

Meaning that if the model that we have for the Character reflects the model that we are receiving from
Head over to RMCharacterEpisodeCollectionViewCell.


*/


/*


-> Improve Character Tab Section


borderColor ) Coming from the RMCharacterEpisodeCollectionViewCell, we are going to implement a borderColor property within our RMCharacterEpisodeCollectionViewCellViewModel.

To begin, we are going to set another parameter to our RMCharacterEpisodeCollectionViewCellViewModel's initializer.
That parameter will be borderColor with a default value of .systemBlue.

Then, at the top, we are going to create a public Constant called borderColor of Type UIColor.
Doing so will prompt us to import UIKit at the top.

Head over to the RMEpisodeListViewViewModel file.

*/
