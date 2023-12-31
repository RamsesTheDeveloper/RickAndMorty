//
//  RMCharacterEpisodeCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 10/12/23.
//

import UIKit

final class RMCharacterEpisodeCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "RMCharacterEpisodeCollectionViewCell"
    
    private let seasonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .regular)
        return label
    }()
    
    private let airDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // contentView.backgroundColor = .systemPurple
        // contentView.backgroundColor = .systemBackground
        contentView.backgroundColor = .tertiarySystemBackground
        setUpLayer()
        contentView.addSubviews(seasonLabel, nameLabel, airDateLabel)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLayer() {
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 2
        // contentView.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            seasonLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            seasonLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            seasonLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            seasonLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),
            
            nameLabel.topAnchor.constraint(equalTo: seasonLabel.bottomAnchor),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            nameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),
            
            airDateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            airDateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            airDateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            airDateLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        seasonLabel.text = nil
        nameLabel.text = nil
        airDateLabel.text = nil
    }
    
    public func configure(with viewModel: RMCharacterEpisodeCollectionViewCellViewModel) {
        
        viewModel.registerForData { [weak self] data in
            // print(String(describing: data))
            // print(data.name)
            // print(data.air_date)
            // print(data.episode)
            
            // Main Thread
            
            self?.nameLabel.text = data.name
            self?.seasonLabel.text = "Episode " + data.episode
            self?.airDateLabel.text = "Aired on " + data.air_date
        }
        
        viewModel.fetchEpisode()
        contentView.layer.borderColor = viewModel.borderColor.cgColor
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


/*


-> Character Episode Cell Section


configure ) We want to create three labels for data.name, data.air_date, and data.episode.
We also want the cell to be tappable so that the user can get more information about an episode.

Our configure() Function doesn't need to jump on the Main Thread because RMCharacterEpisodeCollectionViewCellViewModel's episode's didSet property setter is passing the model into dataBlock which gets its data from the execute() Function which happens to be on the Main Thread.

That is why we don't need to jump on the Main Thread when we give our UILabel's values within the configure() Function.

We use negative constants because we are moving from right to left.

Head over to RMCharacterDetailViewController.



Recap ) After the RMEpisodeDetailViewController was created, the instructor provided a recap.
We used RMCharacterDetailViewController's didSelectItemAt() Function to get the section of the selected ViewModel (the cell that the user is tapping on), then from the position in that section, we get the episode by exposing the episodes Collection for the RMCharacterDetailView instance in RMCharacterDetailViewController which was done in RMCharacterDetailViewViewModel, and then we created an instance RMEpisodeDetailViewController and passed in the URL.



*/


/*


-> Improve Character Tab Section


setUpLayer ) To make changes to the cell displayed in our RMEpisodeListView, we are going to abstract the Layer code into a Function called setUpLayer() which we will called within the overridden initializer.

As of now, the border color of the cell is .systemBlue.
We want to get the color from the viewModel or at least have a default color declared in the viewModel.



configure ) The setUpLayer() Function is setting the borderColor of our cell.
We want the viewModel to set the borderColor, so we are going to remove that line of code from the setUpLayer() Function and move it into the configure() Function.

Then, instead of assigning the borderColor directly, we will declare a borderColor property within our viewModel that will set the color of that one cell in the collectionView.

Head over to the RMCharacterEpisodeCollectionViewCellViewModel file.

*/
