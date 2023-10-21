//
//  RMEpisodeDetailView.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 10/17/23.
//

import UIKit

final class RMEpisodeDetailView: UIView {

    private var viewModel: RMEpisodeDetailViewViewModel?
    
    private var collectionView: UICollectionView?
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .red
        self.collectionView = createCollectionView()
        
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
        ])
    }
    
    private createCollectionView() -> UICollectionView {
        
    }
    
    // MARK: - Public
    
    public func configure(with viewModel: RMEpisodeDetailViewViewModel) {
        
    }
}

/*


-> Episode Detail View Section


Coming from RMEpisodeDetailViewController.
The way that our pattern works is by telling our ViewModel that we need to start fetching data, which we did within RMEpisodeDetailViewController's viewDidLoad() Function.

Once we've fetched the Episode data and .configure() Function is called, we are going to pass the RMEpisodeDetailViewViewModel to our RMEpisodeDetailView while that process is going on, our View needs to show a spinner on the screen.

We are going to use a UICollectionView to show the data that we are receiving from our RMEpisodeDetailViewViewModel on the screen.
We will once again use a compositional layout.



collectionView ) At the top of our Class we are going to initialize an instance of UICollectionView and assign it to the collectionView Variable.

Then, inside of the initializer, we are going to assign the collectionView Variable the return of the createCollectionView() Function.


*/
