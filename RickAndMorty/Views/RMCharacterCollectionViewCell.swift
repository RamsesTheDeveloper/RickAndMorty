//
//  RMCharacterCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 9/28/23.
//

import UIKit

/// Single cell for a character
final class RMCharacterCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "RMCharacterCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        // imageView.contentMode = .scaleAspectFit
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubviews(imageView, nameLabel, statusLabel)
        addConstraints()
        setUpLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func setUpLayer() {
        contentView.layer.cornerRadius = 8 // .cornerRadius for the UICollectionViewCell.
        
        contentView.layer.shadowColor = UIColor.secondaryLabel.cgColor
        contentView.layer.cornerRadius = 4 // This .cornerRadius is specific to the shadow.
        contentView.layer.shadowOffset = CGSize(width: -4, height: 4)
        contentView.layer.shadowOpacity = 0.3
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            statusLabel.heightAnchor.constraint(equalToConstant: 30),
            statusLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 7),
            statusLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -7),
            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),
            
            nameLabel.heightAnchor.constraint(equalToConstant: 30),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 7),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -7),
            nameLabel.bottomAnchor.constraint(equalTo: statusLabel.topAnchor),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -3)
        ])
        
        // imageView.backgroundColor = .systemGreen
        // nameLabel.backgroundColor = .red
        // statusLabel.backgroundColor = .orange
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setUpLayer()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
        statusLabel.text = nil
    }
    
    public func configure(with viewModel: RMCharacterCollectionViewCellViewModel) {
        nameLabel.text = viewModel.characterName
        statusLabel.text = viewModel.characterStatusText
        viewModel.fetchImage { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.imageView.image = image
                }
            case .failure(let error):
                print(String(describing: error))
                break
            }
        }
    }
}

/*


-> Character Cell Section


RMCharacterCollectionViewCell ) The RMCharacterCollectionViewCell file is going to be the template of a single cell.
The reasoning here is that we are going to use the same cell over and over in our collectionView with the small difference of configuring with different data.

For example, if we show an image and a character name, then our template is going to use a different URL for the image and a different text for that Character's name.



cellIdentifier ) We created a static Constant in our Class with the goal of making it easy to change the identifier in one spot instead of having to change it in several places.



imageView ) We will use the block pattern to create a UIImageView for an instance of RMCharacter.



nameLabel ) We also need a nameLabel of Type UILabel for an instance of RMCharacter.
Note that UILabel has a default text color of .label which is a semantic color that will be white or black depending on the mode that the user is in.



statusLabel ) Likewise, we will need a status label to accomodate for RMCharacter's RMCharacterStatus.



contentView ) We are not going to add our imageView, nameLabel, and statusLabel to our parent View directly because it is not the correct way of adding our Views to the parent View.

Using addSubviews() alone to add our Views is not correct because it doesn't account for the safe area.
However, invoking addSubviews() on contentView handles the safe area for us and is the best way to add our Views.



addConstraints ) Notice that we are adding our constraints on the contentView, and not the view, that's because contentView accounts for the safe area, so that we don't have to.

Also notice how we are using negatives for right and bottom anchors.



prepareForReuse ) The prepareForReuse() Function is made available to use through UICollectionViewCell.
Every time that the cell is used, we want to reset it, which is accomplished by prepareForReuse().

When we reset the cell, we will want to get rid of the contents of the image, nameLabel, and statusLabel so that we have clean cell to work with.



configure ) We want to configure our UICollectionViewCell with a ViewModel.
We need a ViewModel because we will need to feed each cell in our UICollectionView data.

Inside of the configure() Function, we want to download the image and assign our image and text to instance of RMCharacterCollectionViewCell.

To do so, we are going to open our RMCharacterCollectionViewCellViewModel.

Whenever configure() is called, we want to assign the contents of our View, which are made available via our ViewModel.
We are taking the data that our ViewModel is producing and we are giving it to our UIView via the configure() Function.



Memory Leak ) Inside of our configure() Function's .fetchImage() call, we are referencing the imageView Constant which is owned by self and self is our RMCharacterCollectionViewCell Class.

DispatchQueue is an Asynchronous task, so to avoid a retain cycle, we will need to capture a pointer to self (RMCharacterCollectionViewCell) in a weak capacity, that way it can be broken.

Then, we will need to make self Optional by placing a question mark after the keyword self :

Making self Optional stops us from retaining the cell bi-directionally.
We don't want to have a pointer that has a strong connection in receivign and sending data because if it is, a retain cycle will ensue.

By making self Optional, the closure is strongly held by the cell, but not vice versa.



Naming Convention ) When working with Views and ViewModels, it is best practice to name the ViewModel after the View like we did for RMCharacterCollectionViewCellViewModel.



register ) Returning to our RMCharacterListView, we are going to register our RMCharacterCollectionViewCell as the cell of our collectionView.



deque ) Once we register the cell, we need to open our RMCharacterListViewViewModel and change the identifier for the cellForItemAt() Function.

*/


/*


-> Showing Characters Section


imageView ) The image we are receiving is not flushed to the top, so we are going to change its .contentMode from .scaleAspectFit to .scaleAspectFill.

This change causes the image to overflow its bounds, so we need to set .clipsToBounds equal to true.



cornerRadius ) To give our cells rounded corners, we are going to access our contentView's layer property and we are going to set its .cornerRadius to 8.

These changes are made inside of our overridden initializer.



shadow ) We will also add a shadow to our UICollectionViewCell.
Note that we are using .cgColor because the GPU is more comfortable using this Type for expensive operations like creating shadows.



setUpLayer ) We noticed that the shadow was not adapting to Dark Mode and Light Mode, so we abstracted it into its own private Function and to solve the problem by overriding the traitCollectionDidChange() Function.



traitCollectionDidChange ) The traitCollectionDidChange() Function is overridden by using the super Function to call traitCollectionDidChange() and passing in the previousTraitCollection argument.

Then, we call our setUpLayer() Function, that way the layer will be set up again whenever it changes.

Note that traitCollectionDidChange() is invoked when the iOS interface environment changes.

*/
