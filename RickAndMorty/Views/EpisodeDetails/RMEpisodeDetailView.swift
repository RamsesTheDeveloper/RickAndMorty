//
//  RMEpisodeDetailView.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 10/17/23.
//

import UIKit

protocol RMEpisodeDetailViewDelegate: AnyObject {
    func rmEpisodeDetailView(
        _ detailView: RMEpisodeDetailView,
        didSelect character: RMCharacter
    )
}

final class RMEpisodeDetailView: UIView {
    
    public weak var delegate: RMEpisodeDetailViewDelegate?

    private var viewModel: RMEpisodeDetailViewViewModel? {
        didSet {
            spinner.stopAnimating()
            self.collectionView?.reloadData()
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
        // collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell") // Base cell for development
        collectionView.register(
            RMEpisodeInfoCollectionViewCell.self,
            forCellWithReuseIdentifier: RMEpisodeInfoCollectionViewCell.cellIdentifier
        )
        
        collectionView.register(
            RMCharacterCollectionViewCell.self, 
            forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier
        )
        
        return collectionView
    }
    
    // MARK: - Public
    
    public func configure(with viewModel: RMEpisodeDetailViewViewModel) {
        self.viewModel = viewModel
    }
}

extension RMEpisodeDetailView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.cellViewModels.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = viewModel?.cellViewModels else {
            return 0
        }
        
        let sectionType = sections[section]
        
        switch sectionType {
        case .information(let viewModels):
            return viewModels.count
        case .characters(let viewModels):
            return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sections = viewModel?.cellViewModels else {
            fatalError("No ViewModel")
        }
        
        let sectionType = sections[indexPath.section]
        
        switch sectionType {
        case .information(let viewModels):
            
            let cellViewModel = viewModels[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMEpisodeInfoCollectionViewCell.cellIdentifier, 
                for: indexPath
            ) as? RMEpisodeInfoCollectionViewCell else {
                fatalError()
            }
            
            cell.configure(with: cellViewModel)
            return cell
            
        case .characters(let viewModels):
            let cellViewModel = viewModels[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? RMCharacterCollectionViewCell else {
                fatalError()
            }
            
            cell.configure(with: cellViewModel)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true) // Unhighlights the cell selected.
        
        guard let viewModel = viewModel else {
            return
        }
        
        let sections = viewModel.cellViewModels
        let sectionType = sections[indexPath.section]
        
        switch sectionType {
        case .information:
            break
        case .characters:
            guard let character = viewModel.character(at: indexPath.row) else {
                return
            }
            delegate?.rmEpisodeDetailView(self, didSelect: character)
        }
    }
}

extension RMEpisodeDetailView {
    func layout(for section: Int) -> NSCollectionLayoutSection {
        guard let sections = viewModel?.cellViewModels else {
            return createInfoLayout()
        }
        
        switch sections[section] {
        case .information:
            return createInfoLayout()
        case .characters:
            return createCharacterLayout()
        }
    }
    
    func createInfoLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    func createCharacterLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0))
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 5,
            leading: 10,
            bottom: 5,
            trailing: 10
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0), 
                heightDimension: .absolute(260)
            ),
            subitems: [item, item]
        )
        
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


/*


-> Episode Detail Cells Section

reloadData ) Coming from RMEpisodeDetailViewViewModel, we are calling the .reloadData() Function on our collectionView.
Calling the .reloadData() Function within our didSet property setter will cuase our UICollectionViewDelegate and UICollectionViewDataSource Functions to run again.

Meaning that the Functions in our extension are going to run whenever our RMEpisodeDetailViewViewModel's dataTuple receives data.
dataTuple receives data and uses that data to create ViewModels, those ViewModels are passed from RMEpisodeDetailViewViewModel to the RMEpisodeDetailViewController which uses the ViewModels it receives to configure its RMEpisodeDetailView instance via the configure() Function, and the configure() Function is declared in RMEpisodeDetailView and it assigns the ViewModel to its viewModel instance that reloads the Episode detail screen.



numberOfSections ) For our numberOfSections() Function, we are going to return the count of our cellViewModels or zero.



numberOfItemsInSection ) Within the numberOfItemsInSection() Function, we are going to create a sections Constant and assign it the cellViewModels we are receiving and then we are going to create a sectionType Constant.

sectionType will receive a value by accessing the cellViewModels that are stored in the sections Constant and passing in the section that we are receiving from the numberOfItemsInSection() Function.

We will then switch on the sectionType and we will return count of the viewModels for the characters case and the information case.
To summarize, we are getting the sections from the ViewModel, we are unwrapping them because the ViewModel is optional, we get the sectionType and based on the Type we are going to return how many items should be in that section.



createCollectionView ) Within the createCollectionView() Function we are going to .register() the appropriate cell.
One of them is the RMEpisodeInfoCollectionViewCell, we haven't created an identifier for RMEpisodeInfoCollectionViewCell, so we will have to do that in the RMEpisodeInfoCollectionViewCell file.

We will also go through the same process for the RMCharacterCollectionViewCell, but RMCharacterCollectionViewCell already has a cellIdentifier.



cellForItemAt ) Our cellForItemAt() Function is going to throw a fatalError(), but it should never do that because we are returning 0 in our numberOfSections() Function and numberOfItemsInSection() Function.

Once we have our sections, we are going to access the indexPath.section and store it in the sectionType Constant.
Once we have the sectionType, we can dequeue and return the appropriate cell.



Data To Cell ) Our goal is to take the data we are receiving from the ViewModel and putting it into a cell, that's done by creating a our cell and then configuring it with the ViewModel that we are receiving for that indexPath.

Within our switch, we are going to call the .dequeueReusableCell() Function in our information case and our characters case.

To do that, we will need the cellViewModel which is the indexPath.row element in our Collection.
Then, we are going to create the cell, meaning that we are going to create an empty box where we will store the cell.
Finally, we configure our empty cell with the ViewModel we are receiving.

Essentially, we are creating an empty cell and we are filling it with the ViewModel that we are receiving from RMEpisodeDetailViewViewModel.

The same will be done for RMCharacterCollectionViewCell.

This was the code that we had before we made changes to the cellForItemAt() Function :

    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    cell.backgroundColor = .yellow
    return cell



layout ) As of now, our simulator is displaying 4 RMEpisodeInfoCollectionViewCells and an Array of RMCharacterCollectionViewCell.
The cells that are appearing on the screen as distorted because we need to create appropriate layouts for both of our sections (Info/Character).

Right now we are only returning the layout for the information cell.
We are going to copy the code from the layout() Function and we are going to paste it into the createInfoLayout() Function.

Within the layout() Function, we are going to access our cellViewModels and store them in the sections Constant.
If we don't have our cellViewModels, we are going to return our default createInfoLayout() Function.

If we do have our cellViewModels, we are going to switch on the section that is being passed into the layout() Function.
Based on the case, we are going to call a different layout Function.



createCharacterLayout ) In the case of Character, we are going to create our createCharacterLayout() Function.
We want our item to have .fractionalWidth(0.5) because we want to fit two items per group.

We are entering 2 item instances into our subitems Array, that is why we need the item to be 0.5 of the its underlying group.
We want the height of the group to be 260, which would make the height of each of our item instances 260.
We will also set .contentInsets on our item Constant.

Now that our RMCharacterCollectionViewCell is set up, we are going to create our RMEpisodeInfoCollectionViewCell.
Head over to the RMEpisodeInfoCollectionViewCell file.

The height of createInfLayout() group was changed from 100 to 80.

*/


/*


-> Finish Episode Details Section


RMEpisodeDetailViewDelegate ) Coming from RMEpisodeDetailViewViewModel, we want to leverage a Delegate to get to the selection out of our View.
RMEpisodeDetailView is the file that holds our collectionView.

We need a Delegate for our cell, so at the top of our file we are going to declare a Protocol called RMEpisodeDetailViewDelegate.
The Protocol will be of Type AnyObject, that way our delegate Variable within our RMEpisodeDetailView Class can be a weak reference.

Inside of the Protocol we are going to declare a Function called rmEpisodeDetailView() with a detailView parameter, this is a common naming convention.

We always pass in a reference of the View that is triggering the call.
In this case, RMEpisodeDetailView is the View triggering the call, that is why we give our detailView parameter a Type of RMEpisodeDetailView.

The other value that we will need to pass in is the instance of RMCharacter that was selected, this is represented by the character parameter.



didSelectItemAt ) In our didSelectItemAt() Function, we can access our selection.
We access our selection by switching on the sectionType that we are receiving from cellViewModels.

In this case, we are not working with the information case, so we are going to break out of it.

We are working with the characters case, but the RMCharacterCollectionViewCellViewModel does not have an instance of RMCharacter.
So, the next thing we will have to do is get a particular Character out of position.

Instead of using viewModels in our characters case, we are going to use the indexPath.
We will use the indexPath to check in the RMEpisodeDetailViewViewModel that we have a Character at that position (at that indexPath).

The first approach would have had us access the characters case's RMCharacter instance, but we are going to access the position of RMEpisodeDetailViewViewModel's dataTuple's character Array.

RMEpisodeDetailViewViewModel's dataTuple's character Array holds the position of the RMCharacter instance because it is of Type RMCharacter.



sectionType ) With the information above, we are going to unwrap RMEpisodeDetailView's viewModel, we will save our viewModel's cellViewModels to the sections Constant, and we will need to access the sectionType which we will use to switch on.

In the characters case, we are going to pass in our indexPath.row to RMEpisodeDetailViewViewModel's .character(at:) Function which does not exist.
After that is finished, we are going to pass the character Constant into our delegate's .rmEpisodeDetailView() Function.
We are going to create our .character(at:) Function within the RMEpisodeDetailViewViewModel file.

Head over to the RMEpisodeDetailViewViewModel file.



character ) Returning from RMEpisodeDetailViewViewModel, we need to error check the didSelectItemAt() Function's character Constant before we pass it into our delegate's .rmEpisodeDetailView() Function.

As of now, we have our RMCharacter instance, but we haven't assigned a Delegate to our property, that will be done in the RMEpisodeDetailViewController.

Head over to the RMEpisodeDetailViewController file.


*/
