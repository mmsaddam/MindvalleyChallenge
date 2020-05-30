/*
 Reference:
 https://developer.apple.com/documentation/uikit/uiimage/asynchronously_loading_images_into_table_and_collection_views
*/
import UIKit
import Foundation

public class ImageCache {
    public static let publicCache = ImageCache()
    private let cachedImages = NSCache<NSURL, UIImage>()
    
    public final func image(url: NSURL) -> UIImage? {
        return cachedImages.object(forKey: url)
    }
    /// - Tag: cache
    // Returns the cached image if available, otherwise asynchronously loads and caches it.
    public final func load(url: NSURL, completion: @escaping (UIImage?) -> Swift.Void) {
        // Check for a cached image.
        if let cachedImage = image(url: url) {
            completion(cachedImage)
            return
        }
        
        // Go fetch the image.
        
        URLSession.shared.dataTask(with: url as URL) { (data, response, error) in
            // Check for the error, then data and try to create the image.
            guard let responseData = data, let image = UIImage(data: responseData), error == nil else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
           
            // Cache the image.
            self.cachedImages.setObject(image, forKey: url, cost: responseData.count)
            
            DispatchQueue.main.async {
                 completion(image)
            }
           
        }.resume()
    }
        
}
