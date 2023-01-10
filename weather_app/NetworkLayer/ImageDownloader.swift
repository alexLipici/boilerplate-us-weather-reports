//
//  ImageDownloader.swift
//  weather_app
//
//  Created by Petru-Alexandru Lipici on 08.01.2023.
//

import Foundation
import Alamofire

class ImageDownloader {
    
    static var shared: ImageDownloader = {
        return ImageDownloader()
    }()
    
    private let imageCache = NSCache<AnyObject, AnyObject>()
    
    private var session: Session
    private let networkInterceptor: RequestInterceptor
        
    private init() {
        networkInterceptor = NetworkInterceptor()
        session = EncryptedSession(interceptor: networkInterceptor, delegate: SessionDelegate())
    }
    
    func downloadImage(
        url: String,
        includeCache: Bool,
        completion: @escaping (Result<(image: UIImage, redirectedUrl: String), NetworkError>) -> Void
    ) {
        guard URL(string: url) != nil else { return completion(.failure(.canceled)) }
        
        var redirectedURL: String = url
        
        let redirector = Redirector(behavior: .modify({ _, urlRequest, _ in
            
            redirectedURL = urlRequest.url?.absoluteString ?? url
            
            if let imageFromCache = self.cacheForKey(redirectedURL) {
                if includeCache {
                    completion(.success((image: imageFromCache, redirectedUrl: redirectedURL)))
                } else {
                    // it means that we should load another different image -> retry call to obtain another image
                    self.downloadImage(url: url, includeCache: includeCache, completion: completion)
                }
                return nil
            } else {
                return urlRequest
            }
        }))
        
        session
            .request(
                url,
                method: .get,
                encoding: CustomGetEncoding()
            )
            .redirect(using: redirector)
            .response { response in
                switch response.result {
                case .success(let responseData):
                    guard
                        let data = responseData,
                        let image = UIImage(data: data)
                    else {
                        return completion(.failure(.unknown))
                    }
                    
                    self.storeCache(image: image, key: redirectedURL)

                    completion(.success((image: image, redirectedUrl: redirectedURL)))
                case .failure(let error):
                    completion(.failure(.customMessage(error.localizedDescription)))
                }
            }
    }
    
    private func storeCache(image: UIImage, key: String) {
        imageCache.setObject(image, forKey: key as AnyObject)
    }
    
    private func cacheForKey(_ key: String) -> UIImage? {
        guard let imageFromCache = self.imageCache.object(forKey: key as AnyObject) as? UIImage else {
            return nil
        }
        
        return imageFromCache
    }
}
