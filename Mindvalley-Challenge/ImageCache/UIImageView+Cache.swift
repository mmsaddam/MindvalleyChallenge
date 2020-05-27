//
//  UIImageView+Cache.swift
//  Mindvalley-Challenge
//
//  Created by Muzahidul Islam on 24/5/20.
//  Copyright © 2020 Muzahid. All rights reserved.
//

import UIKit

extension UIImageView {
    func loadImage(_ url: URL, placeHolder: UIImage? = UIImage(named: "placeholder")) {
        self.image = placeHolder
        ImageCache.publicCache.load(url: url as NSURL) { [weak self] (remoteImage) in
            if remoteImage != nil {
                self?.image = remoteImage
            } else if let placeHolder = placeHolder {
                self?.image = placeHolder
            }
        }
    }
}
