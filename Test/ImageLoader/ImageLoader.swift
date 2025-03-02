//
//  ImageLoader.swift
//  Test
//
//  Created by Руслан Усманов on 01.03.2025.
//

import UIKit

/// Загружает и кэширует изображения
final class ImageLoader {
    
    /// Кэш для изображений, где ключ - ссылка
    var cache = NSCache<NSString, UIImage>()
    
    static let shared = ImageLoader()
    
    private init(cache: NSCache<NSString, UIImage> = NSCache<NSString, UIImage>()) {
        self.cache = cache
    }
    
    /// Загружает изображение по ссылке из кэша или сети
    func loadImage(stringURL: String, completion: @escaping (UIImage?) -> Void) {
        if let image = cache.object(forKey: NSString(string: stringURL)) {
            completion(image)
         return
        }

        guard let url = URL(string: stringURL) else { return }
        let request = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let strongSelf = self else { return }
            guard error == nil else { return }
            guard let data else { return }
            if let image = UIImage(data: data) {
                strongSelf.cache.setObject(image, forKey: NSString(string: stringURL))
                completion(image)
            } else {
                completion(nil)
            }
        }
        dataTask.resume()
    }
}
