//
//  RMEpisodeDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 10/17/23.
//

import Foundation

class RMEpisodeDetailViewViewModel {
    
    private let endpointUrl: URL?
    
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
        fetchEpisodeData()
    }
    
    private func fetchEpisodeData() {
        
        guard let url = endpointUrl, let request = RMRequest(url: url) else {
            return
        }
        
        RMService.shared.execute(request, expecting: RMEpisode.self) { result in
            switch result {
            case .success(let success):
                print(String(describing: success))
            case .failure(let failure):
                break
            }
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
