//
//  UIImageView+Extension.swift
//  PlayRadar
//
//  Created by Muhammad Muizzsuddin on 08/08/23.
//

import UIKit

extension UIImageView {
    func setImage(withURL url: URL, placeholder: UIImage? = nil) {
        if let cachedImage = getCachedImage(forURL: url) {
            self.image = cachedImage
            return
        }
        
        if let placeholderImage = placeholder {
            self.image = placeholderImage
        }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                self.cacheImage(image, forURL: url)
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
    
    private func getCachedImage(forURL url: URL) -> UIImage? {
        let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        let fileName = url.lastPathComponent
        
        if let fileURL = cacheDirectory?.appendingPathComponent(fileName),
           let data = try? Data(contentsOf: fileURL) {
            return UIImage(data: data)
        }
        
        return nil
    }
    
    private func cacheImage(_ image: UIImage, forURL url: URL) {
        let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        let fileName = url.lastPathComponent
        
        if let fileURL = cacheDirectory?.appendingPathComponent(fileName),
           let data = image.jpegData(compressionQuality: 1.0) {
            try? data.write(to: fileURL)
        }
    }
}
