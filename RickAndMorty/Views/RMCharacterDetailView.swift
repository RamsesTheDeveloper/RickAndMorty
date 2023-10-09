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
    
    private let viewModel: RMCharacterDetailViewViewModel
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    // MARK: - Initializer
    
    init(frame: CGRect, viewModel: RMCharacterDetailViewViewModel) {
        self.viewModel = viewModel
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
        
        let sectionTypes = viewModel.sections
        
        switch sectionTypes[sectionIndex] {
        case .photo:
            return createPhotoSectionLayout()
        case .information:
            return createInfoSectionLayout()
        case .episodes:
            return createEpisodeSectionLayout()
        }
    }
    
    private func createPhotoSectionLayout() -> NSCollectionLayoutSection {
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
    
    private func createInfoSectionLayout() -> NSCollectionLayoutSection {
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
    
    private func createEpisodeSectionLayout() -> NSCollectionLayoutSection {
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

We then assign our NSDirectionalEdgeInsets to our item Constant, its initializer takes a top, leading, bottom, and trailing argument.

In our case, we want to push the sections 10 points away from its trailing edge and 10 points away from its bottom edge.



TableView ) Our simulator is showing a list of cells, compositional layouts allow us to mold our cells in various ways which is why our simulator seems to be displaying a TableView when it is displaying a collectionView.



SectionType ) Our compositional layout design allows us to specify a different section layout based on the index, which is to say that one section in our collectionView can be molded into a group of squares while the subsequent section is a rectangle.

In our case, we want to have three different sections of data, but using integers to identify the sections is untidy, so we will create some objects that will help us represent the different types of sections.

Head over to the RMCharacterDetailViewViewModel file.



configure ) Returning from RMCharacterDetailViewViewModel, we are going to create an instance of RMCharacterDetailViewViewModel within our RMCharacterDetailView.

To do so, at the bottom of our Class, we are going to implement a configure() Function.
The configure() Function will take a viewModel of Type RMCharacterDetailViewViewModel as input, then it will assign it to RMCharacterDetailView's viewModel Variable.



viewModel ) Notice that our viewModel's Type is Optional, that's because we will give it a value inside of the configure() Function.



Redesign ) Our initializer creates the collectionView when the RMCharacterDetailView Class comes into existence.
Our configure() Function expects a viewModel to be passed in after the Class is initialized.

Therefore, our current design would cause a crash :

    private var viewModel: RMCharacterDetailViewViewModel?
    ...
    public func configure(with viewModel: RMCharacterDetailViewViewModel) {
        self.viewModel = viewModel
    }

In place of our configure() Function, we are going to add another parameter to our Class's initializer :

    private var viewModel: RMCharacterDetailViewViewModel

    init(frame: CGRect, viewModel: RMCharacterDetailViewViewModel) {
        self.viewModel = viewModel
        ...
    }

Notice that the viewModel's Type is no longer Optional.

Then, in our RMCharacterDetailViewController, we are going to create our RMCharacterListView with the appropriate ViewModel.
Head over to RMCharacterDetailViewController.



sectionTypes ) Once our viewModel is created in the RMCharacterDetailViewController and passed into an instance of RMCharacterDetailView, we are going to assign RMCharacterDetailViewViewModel's sections Constant to our createSection() Function's sectionTypes Constant.

Our sectionTypes Constant allows us to switch on the cases that we laid out in the SectionType Enum.
We will use the switch functionality to pick out the correction Function to call.

With this design, our createSection() Function is expecting an NSCollectionLayoutSection to be returned, which is exactly what the Layout Functions return.



createPhotoSectionLayout ) To keep our code organized, we are going to move our NSCollectionLayoutSection code into a Function called createPhotoSectionLayout.

We will then copy and paste that code two more times in order to have a layout for each case in our SectionType Enum.

*/
