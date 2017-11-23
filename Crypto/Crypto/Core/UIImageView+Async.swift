//
//  UIImageView+Async.swift
//  Intonate
//
//  Created by Aashish Dhawan on 9/4/17.
//  Copyright © 2017 Oratio LLC. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    func loadImageUsingCache(withUrl urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
//        let url = URL(string: urlString)
        self.image = nil

        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }

        // if not, download image from url
        URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
            if error != nil {
                print(error!)
                return
            }

            dispatch {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                }
            }

        }).resume()
    }
}
