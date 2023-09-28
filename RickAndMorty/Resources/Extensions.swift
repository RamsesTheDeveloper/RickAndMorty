//
//  Extensions.swift
//  RickAndMorty
//
//  Created by Ramsés Abdala on 9/28/23.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
        }
    }
}

/*


-> Character List View Section


UIView ) UIView's addSubview() method only allows us to add one View to our parent View at a time.
That's repetitive, so we are going to extend UIView and create an addSubviews() Function.

The addSubviews() Function makes use of variadic parameters.
For each argument passed into our addSubviews() Function, we are going to iterate over those arguments and call UIView's .addSubview() Function.

*/
