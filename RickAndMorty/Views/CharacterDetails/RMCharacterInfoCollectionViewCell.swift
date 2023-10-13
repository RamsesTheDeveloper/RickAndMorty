//
//  RMCharacterInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 10/12/23.
//

import UIKit

final class RMCharacterInfoCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "RMCharacterInfoCollectionViewCell"
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Earth"
        label.font = .systemFont(ofSize: 22, weight: .light)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Location"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = UIImage(systemName: "globe.americas")
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
    private let titleContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.addSubviews(valueLabel, iconImageView, titleContainerView)
        titleContainerView.addSubview(titleLabel)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            
            titleContainerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.33),
            titleContainerView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            titleContainerView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            titleContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: titleContainerView.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: titleContainerView.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: titleContainerView.rightAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: titleContainerView.bottomAnchor),
            
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 35),
            iconImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            // iconImageView.bottomAnchor.constraint(equalTo: titleContainerView.topAnchor, constant: -10),
            
            valueLabel.heightAnchor.constraint(equalToConstant: 30),
            
            valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 36),
            valueLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 10),
            valueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
        ])
        // valueLabel.backgroundColor = .blue
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func configure(with viewModel: RMCharacterInfoCollectionViewCellViewModel) {
        
    }
}

/*


-> Character Info Cell Section We are going to build out the View as well as tweak the ViewModel in order to make it Type safe and useful.


titleContainerView ) Instead of adding our titleLabel directly to our RMCharacterInfoCollectionViewCell, we are going to add it to our titleContainerView, but the titleContainerView will be added to the RMCharacterInfoCollectionViewCell.

The titleContainerView will have a .backgroundColor of .secondarySystemBackground.
We are giving the titleContainerView a .backgroundColor because we want to apply a 30 percent darker color to our RMCharacterInfoCollectionViewCell, so that we can signify a difference in the container.

For titleContainerView's .heightAnchor, we want it to have the same height as the contentView (RMCharacterInfoCollectionViewCell), but we want it to be 33 percent of the total size.



titleLabel ) After creating titleLabel's titleContainerView constraints, we are going to center the contents of the titleLabel and we will give it a systemFont.



iconImageView ) We want the iconImageView to have a height of 30 and a width of 30.
We want to place the iconImageView to the left of RMCharacterInfoCollectionViewCell's container, but we want to push off from its edges so we are going to give iconImageView a constant of 35 on the top and constant of 20 for the left.

We also want to push off the titleContainerView because if we don't then our iconImageView will overlap the titleContainerView.
We want to clip the edges of the cell because the bottom is not pointy, but the top of the cell is rounded.

The iconImageView is distorted, so we are going to set its .contentMode equal to .scaleAspectFit.
 
Within the Class's initializer, we will set the contentView.layer's .masksToBounds equal to true, so that everything stays inside of the rounded corners.

When we set a .heightAnchor, there is no need to set a .bottomAnchor.



valueLabel ) Setting the valueLabel's constraints as :

    valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 35),
    valueLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 10),
    valueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
    valueLabel.bottomAnchor.constraint(equalTo: titleContainerView.topAnchor, constant: -10),

Stretches the valueLabel vertically across the RMCharacterInfoCollectionViewCell while at the same time the text is vertically centered which makes the valueLabel look out of place.

So, instead of having a .bottomAnchor, we are going to give it a fixed height, and by doing so, we don't have to specify the bottom anchor because we know where the end of the label is going to be.

We will also set a font for the valueLabel within its Anonymous Function.
Be mindful of line wrapping.


*/
