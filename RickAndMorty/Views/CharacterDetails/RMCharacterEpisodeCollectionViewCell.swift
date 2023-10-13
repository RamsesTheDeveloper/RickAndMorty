//
//  RMCharacterEpisodeCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 10/12/23.
//

import UIKit

final class RMCharacterEpisodeCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "RMCharacterEpisodeCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemPurple
        contentView.layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func configure(with viewModel: RMCharacterEpisodeCollectionViewCellViewModel) {
        
        viewModel.registerForData { data in
            // print(String(describing: data))
            print(data.name)
            print(data.air_date)
            print(data.episode)
        }
        
        viewModel.fetchEpisode()
    }
}

/*


-> Episode Fetch Section


backgroundColor ) We have the appropriate number of cells, but we are not seeing them because we haven't set a color.
So, within the initializer, we are going to set a .backgroundColor on the contentView.

Head over to RMCharacterEpisodeCollectionViewCellViewModel.



Publisher-Subscriber ) Now that our Publisher-Subscriber pattern is in place, we are going to register for a block within the configure() Function.

Head over to RMCharacterEpisodeCollectionViewCellViewModel.

*/
