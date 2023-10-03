//
//  RMFooterLoadingCollectionReusableView.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 10/2/23.
//

import UIKit

final class RMFooterLoadingCollectionReusableView: UICollectionReusableView {
    static let identifier = "RMFooterLoadingCollectionReusableView"
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // backgroundColor = .systemBlue
        backgroundColor = .systemBackground
        addSubview(spinner)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    public func startAnimating() {
        spinner.startAnimating()
    }
}

/*


-> Paginator Indicator Section


UICollectionReusableView ) UICollectionReusableView is similar to a cell, such that we need to register and dequeue it, therefore we will need to create an identifier static Constant at the top of the file.

We are going to register RMFooterLoadingCollectionReusableView with our collectionView.
Head over to the RMCharacterListView file.



backgroundColor ) UICollectionReusableView does not nave a contentView, which is by design.



spinner ) After registering our footer in our RMCharacterListViewViewModel's collectionView, we are going to copy the spinner that we created in the RMCharacterListView and we are going to paste it in this file.

We will also copy and paste the constraints we created for the spinner in the RMCharacterListView file.

Note that we need to call our startAnimating() Function inside of our RMCharacterListViewViewModel's viewForSupplementaryElementOfKind() Function.

Head over to the RMCharacterListViewViewModel file.

*/
