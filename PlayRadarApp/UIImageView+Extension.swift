//
//  UIImageView+Extension.swift
//  PlayRadarApp
//
//  Created by Muhammad Muizzsuddin on 08/08/23.
//

import UIKit

extension UIImageView {
    @discardableResult
    func setImage(withURL url: URL) -> AsyncImageReference {
        return AsyncImageReference(url, self)
    }
}

class AsyncImageReference {
    weak var imageView: UIImageView?
    private let url: URL
    init(_ url: URL, _ imageView: UIImageView) {
        self.imageView = imageView
        self.url = url
        setImage(withURL: url)
    }
    
    func setImage(withURL url: URL, placeholder: UIImage? = nil) {
        if let cachedImage = getAsyncImageReference(forURL: url) {
            imageView?.image = cachedImage
            return
        }
        
        if let placeholderImage = placeholder {
            imageView?.image = placeholderImage
        }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                self?.cacheImage(image, forURL: url)
                DispatchQueue.main.async { [weak self] in
                    self?.imageView?.image = image
                }
            }
        }
    }
    
    private func getAsyncImageReference(forURL url: URL) -> UIImage? {
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
