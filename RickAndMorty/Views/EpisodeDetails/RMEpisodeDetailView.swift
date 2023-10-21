//
//  RMEpisodeDetailView.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 10/17/23.
//

import UIKit

final class RMEpisodeDetailView: UIView {

    private var viewModel: RMEpisodeDetailViewViewModel? {
        didSet {
            spinner.stopAnimating()
            self.collectionView?.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.collectionView?.alpha = 1
            }
        }
    }
    
    private var collectionView: UICollectionView?
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        
        let collectionView = createCollectionView()
        addSubviews(collectionView, spinner)
        self.collectionView = collectionView
        addConstraints()
        
        spinner.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        // Our collectionView is Optional, so we have to unwrap it.
        guard let collectionView = collectionView else {
            return
        }
        NSLayoutConstraint.activate([
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
        ])
    }
    
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { section, _ in
            return self.layout(for: section)
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell") // Base cell for development
        return collectionView
    }
    
    // MARK: - Public
    
    public func configure(with viewModel: RMEpisodeDetailViewViewModel) {
        self.viewModel = viewModel
    }
}

extension RMEpisodeDetailView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .yellow
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true) // Unhighlights the cell selected.
    }
}

extension RMEpisodeDetailView {
    private func layout(for section: Int) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
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


/*


-> Episode Detail Layout Section


createCollectionView ) Within our createCollectionView() Function, we are going to declare our UICollectionViewCompositionalLayout and return the layout for the section we are receiving.

We will then initialize our UICollectionView and pass in our layout, set .translatesAutoresizingMaskIntoConstraints equal to false, and return the collectionView Constant.



layout ) Once that is set up, we are going to create the layout() Functions within an extension.
To do so, we will create our item, group, and section, then we will return the section.



collectionView ) When we create the collectionView in our initializer, it returns as non-Optional from our createCollectionView() Function, so we are going to assign its return Type to a Constant declared within the initializer and assign that Constant's value to our collectionView Variable declared at the top of the Class.



Delegate/DataSource ) It is required that our collectionView have a Delegate and a Datasource, so within the createCollectionView() Function we are going to set the .delegate and .datasource of our collectionView equal to self, self being the RMEpisodeDetailView Class.

Then, we are going to create another extension where we will have our RMEpisodeDetailView Class conform to UICollectionViewDelegate and UICollectionViewDataSource.

We are purposefully going over how to make the ViewModel or the Controller the Delegate and DataSource so that we have those variants in our tool belt.



didSet ) Once we've assigned our ViewModel to the RMEpisodeDetailView, we want to stop the spinner and show the collectionView.
This will be done with a didSet.

The reason that we stop the spinner and show the collectionView when the ViewModel has been assigned is because the ViewModel is holding the Episode/Character data.

Note that in order for our cells to show, we need to set the value of our RMEpisodeDetailView's viewModel equal to the viewModel that we are receiving from our configure() Function's caller.



We want out collectionView to show the name, air_data, and episode.
We also want another section that is going to show the Character's image.

Head over to the RMEpisodeDetailViewViewModel file.

*/
