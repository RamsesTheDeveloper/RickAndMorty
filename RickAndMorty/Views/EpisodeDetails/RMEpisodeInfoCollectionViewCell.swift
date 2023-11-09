//
//  RMEpisodeInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 10/21/23.
//

import UIKit

final class RMEpisodeInfoCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "RMEpisodeInfoCollectionViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .right
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubviews(titleLabel, valueLabel)
        setUpLayer()
        addConstraints()
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
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            valueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.47),
            valueLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.47)

        ])
        
        // titleLabel.backgroundColor = .red
        // valueLabel.backgroundColor = .green
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        valueLabel.text = nil
    }
    
    func configure(with viewModel: RMEpisodeInfoCollectionViewCellViewModel) {
        titleLabel.text = viewModel.title
        valueLabel.text = viewModel.value
    }
    
}

/*


-> Episode Detail Cells Section


setUpLayer ) Coming from RMEpisodeDetailView, we are now going to build out our RMEpisodeInfoCollectionViewCell.
To begin, we are going to create our setUpLayer() Function.

The first order of business is rounding the corners of our RMEpisodeInfoCollectionViewCell which is done by setting the layer's .cornerRadius equal to zero and setting .maskToBounds equal to true.

In order to show our changes, we need to call the setUpLayer() Function within the overridden initializer.

*/


/*


-> Finish Episode Details Section


UILabel ) Our goal is to build out our RMEpisodeInfoCollectionViewCell and implementing tap functionality that will open up the Character details screen when a Character is selected from the RMEpisodeDetailView.

We want our RMEpisodeInfoCollectionViewCell to display two labels in its cell.
We want a title and a valueLabel.

Notice that we are declaring all of our components first and then we are setting their constraints in the addConstraints() Function.



prepareForReuse ) Since we are going to reuse our RMEpisodeInfoCollectionViewCell over and over, we need to nil out the previous titleLabel and valueLabel values of the given ViewModel.



configure ) To configure our titleLabel and valueLabel, we are going to access the viewModel that we are receiving from our caller and we will assign the values from our viewModel to our labels.

Note that our RMEpisodeInfoCollectionViewCellViewModel only has two values, the first being title and the second being value which reflect the data that we are receiving from the Rick and Morty API.



addConstraints ) We want the titleLabel to be the left 50 percent of the cell and the valueLabel to be other remaining 50 percent.
We are using negative 4 for the .bottomAnchor because using positive 4 will push it down, using negative pushes it up and away from its border.

Likwise, we are going to move valueLabel's .rightAnchor margin inward by 10.
Using a negative pushes the object inward.

Therefore, pushing it outward is positive and pushing it inward is negative.

We added margins to the .leftAnchor and the .rightAnchor, so we are going to give our .widthAnchor a value of 0.47 to navigate that difference.
We were having trouble getting the .widthAnchor to work because we were working with the constant argument instead of the multiplier.



Date Format ) Currently, our date isn't formatting correctly.
We used a DateFormatter in our RMCharacterInfoCollectionViewCellViewModel, but in our case, we will need to format our date when the value is being created.

RMEpisodeDetailViewViewModel's createCellViewModels() creates our date's value, so we will need to format our date there.
Head over to the RMEpisodeDetailViewViewModel file.


*/
