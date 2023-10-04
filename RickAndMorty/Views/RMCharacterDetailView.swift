//
//  RMCharacterDetailView.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 10/2/23.
//

import UIKit

/// View for single character info
final class RMCharacterDetailView: UIView {

    private var collectionView: UICollectionView?
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemPurple
        
        let collectionView = createCollectionView()
        self.collectionView = collectionView
        addSubviews(collectionView, spinner)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func addConstraints() {
        
        guard let collectionView = collectionView else {
            return
        }
        
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return self.createSection(for: sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }
    
    private func createSection(for sectionIndex: Int) -> NSCollectionLayoutSection {
        
    }
}

/*


-> Character Detail View Section


translatesAutoresizingMaskIntoConstraints ) We set translatesAutoresizingMaskIntoConstraints equal to false in our initializer because RMCharacterDetailViewController is going to set constraints for RMCharacterDetailView.



UICollectionViewCompositionalLayout ) UICollectionViewCompositionalLayout allows us to create a layout where every single element, section, and group might have a different dynamic size.

Apple uses UICollectionViewCompositionalLayout to build out carousels and dynamic Grids with different sizes.
The Pinterest app is a good example of UICollectionViewCompositionalLayout.

The UICollectionViewCompositionalLayout(sectionProvider:) option closure returns an Int and NSCollectionLayoutEnvironment.
We are going to set them to sectionIndex and we will enter an underscore for NSCollectionLayoutEnvironment.

The closure will return an NSCollectionLayoutSection.
NSCollectionLayoutSection has a group parameter, we will write our own Function and pass it in as the argument of group.



createSection ) Providing our UICollectionViewCompositionalLayout initializer a group can be intense, so we are going to abstract that logic into its own Function called createSection().



*/
