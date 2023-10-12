//
//  RMCharacterPhotoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 10/12/23.
//

import UIKit

final class RMCharacterPhotoCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "RMCharacterPhotoCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func configure(with viewModel: RMCharacterPhotoCollectionViewCellViewModel) {
        
    }
}

/*


-> Character Detail ViewModels


configure ) We want to configure each of our UICollectionViewCells with their respective ViewModel.
So, within each of our CharacterDetails' Classes, we are going to create a Function called configure(with viewModel:), we will also override the initializer and create our setUpConstraints() Function and prepareForReuse() Function.

We will copy and paste this code into RMCharacterInfoCollectionViewCell and RMCharacterEpisodeCollectionViewCell.



*/
