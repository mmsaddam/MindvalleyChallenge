//
//  String+Extras.swift
//  Mindvalley-Challenge
//
//  Created by Muzahidul Islam on 24/5/20.
//  Copyright © 2020 Muzahid. All rights reserved.
//

import UIKit

extension String {
    ///https://stackoverflow.com/questions/30450434/figure-out-size-of-uilabel-based-on-string-in-swift
    func getHeight(for width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
}
