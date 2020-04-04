//
//  UIImageView+Extensions.swift
//  Restaurants
//
//  Created by Vivek Gupta on 30/03/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

var operations: UInt8 = 0
var loadUrlString: UInt8 = 0

protocol DownloadImage: class {}

extension DownloadImage where Self: UIImageView {
    var loadingString: String? {
        set {
            objc_setAssociatedObject(self, &loadUrlString, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &loadUrlString) as? String
        }
    }
    
    func loadImage(urlString: String?, shouldReload: Bool = false, completion: ((_ image: UIImage?) -> Swift.Void)? = nil) {
        if urlString != nil {
            if urlString?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
                return
            }
            self.loadingString = urlString!.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: " ").inverted)!
            _ = ImageLoadManager.shared.downloadImage(withUrl: self.loadingString!, shouldStore: !shouldReload) {[weak self] (url, image) in
                DispatchQueue.main.async {
                    if let slf = self, let img = image {
                        if slf.loadingString == url {
                            slf.image = img
                            if let cmp = completion {
                                cmp(image)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func cancelOperation (_ url: String) {
        var operationDict = self.getOperationDict()
        if let operation: Operation = operationDict[url] as? Operation {
            operation.cancel()
            operationDict[url] = nil
        }
        objc_setAssociatedObject(self, &operations, operationDict, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func setOperation (_ operation: Operation, for key: String) {
        var operationDict = self.getOperationDict()
        operationDict[key] = operation
        objc_setAssociatedObject(self, &operations, operationDict, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func getOperationDict () -> [AnyHashable: Operation?] {
        if let operationDictionary = objc_getAssociatedObject(self, &operations) as? [AnyHashable: Operation] {
            return operationDictionary
        } else {
            let operationDictionary = [AnyHashable: Operation?]()
            objc_setAssociatedObject(self, &operations, operationDictionary, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return operationDictionary
        }
    }
}

extension UIImageView: DownloadImage {
    
}

