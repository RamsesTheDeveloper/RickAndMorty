//
//  RMEpisodeListViewViewModel.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 10/20/23.
//

import UIKit

protocol RMEpisodeListViewViewModelDelegate: AnyObject {
    func didLoadInitialEpisodes()
    func didLoadMoreEpisodes(with newIndexPaths: [IndexPath])
    func didSelectEpisode(_ episode: RMEpisode)
}

/// View Model to handle episode list view logic
final class RMEpisodeListViewViewModel: NSObject {
    
    public weak var delegate: RMEpisodeListViewViewModelDelegate?
    
    private var isLoadingMoreCharacters = false
    
    private let borderColors: [UIColor] = [
        .systemGreen,
        .systemBlue,
        .systemOrange,
        .systemPink,
        .systemPurple,
        .systemRed,
        .systemYellow,
        .systemIndigo,
        .systemMint
    ]
    
    private var episodes: [RMEpisode] = [] {
        didSet {
            // print("Creating ViewModels")
            for episode in episodes {
                
                let viewModel = RMCharacterEpisodeCollectionViewCellViewModel(
                    episodeDataUrl: URL(string: episode.url),
                    borderColor: borderColors.randomElement() ?? .systemBlue
                )
                
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    
    // private var cellViewModels: [RMEpisodeCollectionViewCellViewModel] = []
    private var cellViewModels: [RMCharacterEpisodeCollectionViewCellViewModel] = []
    private var apiInfo: RMGetAllEpisodesResponse.Info? = nil
    
    /// Fetch initial set of episodes (20)
    public func fetchEpisodes() {
        RMService.shared.execute(.listEpisodesRequest, expecting: RMGetAllEpisodesResponse.self) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                let info = responseModel.info
                
                self?.episodes = results
                self?.apiInfo = info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialEpisodes()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    /// Paginate if additional episodes are needed
    public func fetchAdditionalEpisodes(url: URL) {
        guard !isLoadingMoreCharacters else {
            return
        }
        isLoadingMoreCharacters = true
        print("Fetching more characters")
        guard let request = RMRequest(url: url) else {
            isLoadingMoreCharacters = false
            print("Failed to create RMRequest instance")
            return
        }
        
        print("Fetch Function is running")
        RMService.shared.execute(
            request,
            expecting: RMGetAllEpisodesResponse.self) { [weak self] result in
                guard let strongSelf = self else {
                    return
                }
                switch result {
                case .success(let responseModel):
                    let moreResults = responseModel.results
                    let info = responseModel.info
                    strongSelf.apiInfo = info
                    
                    // Helps calculate the collectionView's indexPath
                    let originalCount = strongSelf.episodes.count
                    let newCount = moreResults.count
                    let total = originalCount + newCount
                    
                    let startingIndex = total - newCount
                    
                    // Create an Array of IndexPath with the given range, transform it, and return an IndexPath with a row and sec
                    let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap {
                        return IndexPath(row: $0, section: 0)
                    }
                    
                    // print(indexPathsToAdd)
                    
                    strongSelf.episodes.append(contentsOf: moreResults)
                    DispatchQueue.main.async {
                        strongSelf.delegate?.didLoadMoreEpisodes(with: indexPathsToAdd)
                        strongSelf.isLoadingMoreCharacters = false
                    }
                case .failure(let failure):
                    print(String(describing: failure))
                    strongSelf.isLoadingMoreCharacters = false
                }
            }
    }
    
    public var shouldShowLoadMoreIndicator: Bool {
        // return false
        return apiInfo?.next != nil
    }
    
    
}

// MARK: - CollectionView

extension RMEpisodeListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? RMCharacterEpisodeCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        
        // let viewModel = cellViewModels[indexPath.row]
        // cell.configure(with: viewModel)
        
        cell.configure(with: cellViewModels[indexPath.row]) // This is a shorthand of the two lines above.
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,
              let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier,
                for: indexPath
              ) as? RMFooterLoadingCollectionReusableView else {
            fatalError("Unsupported")
        }
        
        footer.startAnimating()
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // let bounds = UIScreen.main.bounds
        let bounds = collectionView.bounds // Other approach
        let width = (bounds.width-20)
        
        return CGSize(width: width, height: 100)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let selection = episodes[indexPath.row]
        delegate?.didSelectEpisode(selection)
    }
}

// MARK: - ScrollView

extension RMEpisodeListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator,
              !isLoadingMoreCharacters,
              !cellViewModels.isEmpty,
              let nextUrlString = apiInfo?.next,
              let url = URL(string: nextUrlString) else {
            return
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                self?.fetchAdditionalEpisodes(url: url)
            }
            
            t.invalidate()
        }
    }
}

/*


-> Create Episode Tab Section


cellViewModels ) We will be reusing the same Episode Cell that we've created for our RMCharacterDeatilView.
So, in place of RMEpisodeCollectionViewCellViewModel, we are going to enter in RMCharacterEpisodeCollectionViewCellViewModel.


*/


/*


-> Episode List View Section


didSet ) In order for our didSet property to be able to iterate over an Array of RMCharacterEpisodeCollectionViewCellViewModel, the ViewModel will need to conform to Hashable and Equatable.

So, open the RMCharacterEpisodeCollectionViewCellViewModel file and have the ViewModel adopt Hashable and Equatable.
Then, at the bottom of the file, we will need to implement our hash(into:) Function.




fetchEpisodes ) Our fetchEpisodes() Function's execute() Function requires that we provide a Model that reflects what is being received from the Rick and Morty API.

That Model needs to reflect the cells in our EpisodeListView, so within the APIResponseTypes Group, we are going to create a Swift file called RMGetAllEpisodesResponse.



RMGetAllEpisodesResponse ) We will copy the RMGetAllCharactersResponse Struct and paste it into the RMGetAllEpisodesResponse file.
In this case, the model will be an Array of RMEpisode, instead of an Array of RMCharacter.



.listEpisodesRequests ) At the moment, fetchEpisodes() Function's execute() Function is using the .listCharacterRequests, but what we want is a request for Episodes.

So, within RMRequest's extension, we are going to set a Static Constant called listEpisodesRequest, which holdes an instance of RMRequest created with .episode instead of .character.

Head over to the RMEpisodeListView file.
Note that we changed the cell of the .register() Function within RMEpisodeListView's collectionView Constant.
That cell is now the same as the one being displayed at the bottom of our RMCharacterDetailView.



Recap ) We essentially copied and pasted all of the elements for the Character List such as the ViewModel, the list, and the Controller and renamed them.

The most important bit is the business logic that we implemented in our RMEpisodeListViewViewModel.
In particular, the logic that goes into fetching the initial set of Episodes, as well as fetching additional episodes.

*/


/*


-> Improve Character Tab Section


sizeForItemAt ) Currently, the cells that we are displaying in our collectionView are cutting off the text.
So, we are going to make some changes to our collectionView's sizeForItemAt() Function.

In this case we want to subtract 20 from the width of the cell instead of subtracting 30 and dividing it by 2.
We want the height to be fixed, so we will set it to 100 instead of multuplying it by 0.8.

We want to display a different color for each cell in our collectionView.
To do so, we will make changes to the RMCharacterEpisodeCollectionViewCell.
Headover to the RMCharacterEpisodeCollectionViewCell file.



didSet ) Returning from the RMCharacterEpisodeCollectionViewCell file, we can see that our ViewModels are being created within the didSet property.

So, we are going to call the borderColor argument we just set in RMCharacterEpisodeCollectionViewCell and we will set the value of the color by creating an Array of borderColors.

Then, we are going to pass in the borderColors Array and invoke the .randomElement() Function.
The .randomElement() Function returns an Optional so we will set a coalescent value in case of a nil value.

With that out of the way, we will now build out our Episode Detail screen.
Head over to the RMEpisodeDetailViewController.

To configure our search funtionality, we are going to create a global search Controller that will be configured based on the Type we are searching, which would either be Character, Location, and Episode.

*/
