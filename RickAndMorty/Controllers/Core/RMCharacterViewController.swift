//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 9/27/23.
//

import UIKit

final class RMCharacterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"
        
    }
}


/*

-> Introduction


view.backgroundColor ) We are going to support both light mode and dark mode, so we are going to set the value of view.backgroundColor equal to .systemBackground.


title ) The title property is used to set the title of the ViewController's NavigationBar.


 */
