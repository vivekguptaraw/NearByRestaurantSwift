//
//  ImageLoadManager.swift
//  Restaurants
//
//  Created by Vivek Gupta on 30/03/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

class ImageLoadManager: Any {
    static var shared = ImageLoadManager()
    private var requestOperations: OperationQueue
    
    init() {
        self.requestOperations = OperationQueue()
        self.requestOperations.maxConcurrentOperationCount = 6
        self.requestOperations.name = "com.restaurant.ImageDownload"
    }
    
    func downloadImage(withUrl url: String, shouldStore: Bool, completion: @escaping ((_ url: String, _ hashable: UIImage?) -> Swift.Void)) -> Operation? {
        
        if FileManager.default.fileExists(atPath: ImageDownloadOperation.pathForDictionary.appendingPathComponent(url.md5).path) {
            if let responseData = FileManager.default.contents(atPath: ImageDownloadOperation.pathForDictionary.appendingPathComponent(url.md5).path) {
                //The file exists but check if actual data is changed
                
                completion(url, UIImage(data: responseData))
            } else {
                completion(url, nil)
            }
            return nil
        } else {
            let downloadOperation = ImageDownloadOperation(urlString: url, shouldStore: shouldStore) {[weak self] (data, _) in
                if self != nil {
                    if let responseData = data {
                        completion(url, UIImage(data: responseData))
                    } else {
                        completion(url, nil)
                    }
                }
            }
            downloadOperation.performOperation()
            return downloadOperation
        }
    }
}

