//
//  RMCharacterDetailView.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 10/2/23.
//

import UIKit

/// View for single character info
final class RMCharacterDetailView: UIView {

    public var collectionView: UICollectionView?
    
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
        backgroundColor = .systemBackground
        
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
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }
    
    private func createSection(for sectionIndex: Int) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 10)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(150)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
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


/*


-> Compositional Layout Section


NSCollectionLayoutSection ) The createSection() Function returns an instance of NSCollectionLayoutSection.
To satisfy the compiler, we need to create an instance of NSCollectionLayoutSection and return it.

So, at the bottom of the Function we are going to create an NSCollectionLayoutSection instance and we are going to assign it to the section Constant.

The NSCollectionLayoutSection initializer takes a group argument of Type NSCollectionLayoutGroup.

At the bottom of the Function we return our section Constant.
The section Constant is our NSCollectionLayoutSection.



NSCollectionLayoutGroup ) The NSCollectionLayoutGroup has a .vertical() Function.
The .vertical() Function has two parameters :

    ( 1 ) layoutSize
    The layoutsize argument is of Type NSCollectionLayoutSize

    ( 2 ) subitems
    The subitems argument is an Array of NSCollectionLayoutItem

Both of these objects will need to be declared before we pass them into NSCollectionLayoutGroup's .vertical() Function.



NSCollectionLayoutSize ) Above our group Constant, we created our NSCollectionLayoutSize object.



NSCollectionLayoutItem ) When creating our NSCollectionLayoutItem, we chose the NSCollectionLayoutItem(layoutSize:) initializer.
The NSCollectionLayoutItem(layoutSize:) takes an argument of Type NSCollectionLayoutSize.

To create the NSCollectionLayoutSize object, we will need to provide values for its widthDimension and heightDimension properties.
NSCollectionLayoutSize's widthDimension and heightDimension properties are of Type NSCollectionLayoutDimension.

NSCollectionLayoutDimension is an Enum with absolute, estimated, fractionalWidth, and fractionalHeight cases.

The absolute case allows us to specify a fixed width and height.
We can specify a percentile based on the width of its container because the iteam goes inside of a group or we can do it with the height.

For example, if we want 100 percent of the screen's height, then we will need to make our group the entire height of the screen and each item inside it will be the exact same height as well.



item ) We set the item Variable's widthDimension to .fractionalWidth(1.0) and .fractionalHeight(1.0) for its heightDimension.



group ) Likewise, we will assign the group Variable's widthDimension to .fractionalWidth(1.0), but we set its heightDimension equal to an absolute value of 150.



createCollectionView ) After running the simulator, we realized that we had not set .translatesAutoresizingMaskIntoConstraints equal to false within the createCollectionView() Function.



We also haven't assigned a DataSource/Delegate for the collectionView.
For the RMCharacterViewController, we placed all of our DataSource/Delegate logic within that section's ViewModels.

However, in this approach, we are going to go over the approach we would take to make the Controller our collectionView's DataSource/Delegate.

Both approaches are correct, but it is worth going over the ViewController approach.
Head over to the RMCharacterDetailViewController file.

Returning from the RMCharacterDetailViewController file, we are going to expose two properties at the top of our RMCharacterDetailView Class :

    ( 1 ) We are going to expose our collectionView Variable by making its declaration public instead of private.
    Once we've made our collectionView Variable public, we are going to head over to the RMCharacterDetailViewController.
    
    ( 2 )



NSDirectionalEdgeInsets ) Returning from the RMCharacterDetailViewController, we initialized an NSDirectionalEdgeInsets instance and assigned it to our item Variable's .contentInsets property.

The NSDirectionalEdgeInsets splits our item Constant into 20 sections.
The item Variable spans the entirety of the screen because we its widthDimension a value of .fractionalWidth(1.0) and its heightDimension a value of .fractionalWidth(1.0), that is why the item spans the entire screen.

We then assign our NSDirectionalEdgeInsets to our item Constant, this takes

*/
