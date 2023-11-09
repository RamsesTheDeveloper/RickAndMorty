//
//  RMEpisodeInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 10/21/23.
//

import UIKit

final class RMEpisodeInfoCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "RMEpisodeInfoCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .secondarySystemBackground
        setUpLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLayer() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondaryLabel.cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with viewModel: RMEpisodeInfoCollectionViewCellViewModel) {
        
    }
    
}

/*


-> Episode Detail Cells Section


setUpLayer ) Coming from RMEpisodeDetailView, we are now going to build out our RMEpisodeInfoCollectionViewCell.
To begin, we are going to create our setUpLayer() Function.

The first order of business is rounding the corners of our RMEpisodeInfoCollectionViewCell which is done by setting the layer's .cornerRadius equal to zero and setting .maskToBounds equal to true.

In order to show our changes, we need to call the setUpLayer() Function within the overridden initializer.


*/
