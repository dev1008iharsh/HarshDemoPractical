//
//  UIImageView+Extensions.swift
//  NewsAppHarsh
//
//  Created by My Mac Mini on 01/02/24.
//

import Foundation
import UIKit
 

extension UIImageView {
    func downloadImageWithCaching(urlString: String) {
        guard let imageURL = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        self.image = UIImage(named: "placeholder")
        if let cachedImage = ImageCache.shared.image(for: imageURL) {
            self.image = cachedImage
        } else {
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                if let error = error {
                    print("Error fetching image: \(error)")
                    return
                }
                guard let data = data, let image = UIImage(data: data) else {
                    print("Invalid image data")
                    return
                }
                ImageCache.shared.cache(image, for: imageURL)
                DispatchQueue.main.async {
                    self.image = image
                }
            }.resume()
        }
    }
}

class ImageCache {
    static let shared = ImageCache()
    private var cache = NSCache<NSURL, UIImage>()
    
    func image(for url: URL) -> UIImage? {
        return cache.object(forKey: url as NSURL)
    }
    
    func cache(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
}
