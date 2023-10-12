//
//  RMCharacterPhotoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 10/12/23.
//

import UIKit

final class RMCharacterPhotoCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "RMCharacterPhotoCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    public func configure(with viewModel: RMCharacterPhotoCollectionViewCellViewModel) {
        viewModel.fetchImage { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(data: data)
                }
            case .failure:
                break
            }
        }
    }
}

/*


-> Character Detail ViewModels


configure ) We want to configure each of our UICollectionViewCells with their respective ViewModel.
So, within each of our CharacterDetails' Classes, we are going to create a Function called configure(with viewModel:), we will also override the initializer and create our setUpConstraints() Function and prepareForReuse() Function.

We will copy and paste this code into RMCharacterInfoCollectionViewCell and RMCharacterEpisodeCollectionViewCell.

*/


/*


-> Character Photo Cell Section


imageView ) After creating our imageView, we are going to added to our contentView via the .addSubview() Function, set up its constraints in the setUpConstraints() Function, and we reset the image by setting imageView.image equal to nil.



configure ) Our RMCharacterPhotoCollectionViewCellViewModel needs to provide a mechanism that fetches the image.
Head over to the RMCharacterPhotoCollectionViewCellViewModel file.

Coming back from RMCharacterPhotoCollectionViewCellViewModel, we are going to call our viewModel's .fetchImage() Function and we are going to switch on the result and we will assign the data to a UIImage instance within the Main Thread where we should do all of our data/UI operations.


*/
