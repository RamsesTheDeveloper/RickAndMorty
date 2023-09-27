//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 9/27/23.
//

import UIKit

final class RMTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTabs()
    }
    
    private func setUpTabs() {
        let charactersVC = RMCharacterViewController()
        let locationsVC = RMLocationViewController()
        let episodesVC = RMEpisodeViewController()
        let settingsVC = RMSettingsViewController()
        
        charactersVC.navigationItem.largeTitleDisplayMode = .automatic
        locationsVC.navigationItem.largeTitleDisplayMode = .automatic
        episodesVC.navigationItem.largeTitleDisplayMode = .automatic
        settingsVC.navigationItem.largeTitleDisplayMode = .automatic
        
        let nav1 = UINavigationController(rootViewController: charactersVC)
        let nav2 = UINavigationController(rootViewController: locationsVC)
        let nav3 = UINavigationController(rootViewController: episodesVC)
        let nav4 = UINavigationController(rootViewController: settingsVC)
        
        nav1.tabBarItem = UITabBarItem(title: "Characters", image: UIImage(systemName: "person"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Locations", image: UIImage(systemName: "globe"), tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "Episodes", image: UIImage(systemName: "tv"), tag: 3)
        nav4.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 4)
        
        for nav in [nav1, nav2, nav3, nav4] {
            nav.navigationBar.prefersLargeTitles = true
        }
        
        setViewControllers([nav1, nav2, nav3, nav4], animated: true)
    }
}

/*

-> Introduction Section


Primary Controller ) RMTabBarController is the housing controller, it houses all of our other controllers.



final Class ) We will declare our ViewControllers final with the goal of avoiding inheritance.



Attaching Controllers ) Within our RMTabBarController we created a setUpTabs() Function.
The setUpTabs() Function needs to be called within viewDidLoad() in order for our tabs to be attached to our RMTabBarController.



setUpTabs ) We are making the setUpTabs() Function private because code outside of our RMTabBarController should not be able to access/invoke this Function.

Within the setUpTabs() Function, we are going to create instances of our ViewControllers and attach them to our TabBarController via the setViewControllers() Function.

The setViewControllers() Function is made avaiable by the UITabBarController Class.



UINavigationController ) We want our screens to have a title bar at the top which is also known as a NavigatioBar.
To get that Functionality, we need to wrap our ViewController instances inside of a UINavigationController.


Setting Titles ) To set the title of our screens, we need to open the ViewController and inside the viewDidLoad() Function we set the title of the ViewController.

See RMCharacterViewController for reference.



tabBarItem ) We want to set a tabBarItem for all of our UINavigationControllers, each item will have a tag.



Large Titles ) To set large titles we need to make two changes to our code :

    ( 1 ) The first change requires that we set .largeTitleDisplayMode to .automatic for each of our base controllers.
    It is worth nothing that we cannot set iterate over our base controllers like we did for our UINavigationControllers because they are Types, although all of them inherit from UIViewController.

    ( 2 ) In the second change, we are using a For Loop to iterate over an Array of UINavigationControllers.
    This approach is different than the first one because in the first one we have to set the xxx preference to xxx manually, but in this approach, since all of the objects are of the same Type, we can set .prefersLargeTitles to true for each object in our iteration.


 */
