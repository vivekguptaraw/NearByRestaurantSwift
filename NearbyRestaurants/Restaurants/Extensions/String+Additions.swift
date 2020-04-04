//
//  String+Additions.swift
//  Restaurants
//
//  Created by Vivek Gupta on 30/03/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation


var CC_MD5_DIGEST_LENGTH: Int = 16;          /* digest length in bytes */
var CC_MD5_BLOCK_BYTES: Int = 64;         /* block size in bytes */
var CC_MD5_BLOCK_LONG: Int = (CC_MD5_BLOCK_BYTES / MemoryLayout<CC_LONG>.size.self)

extension String {
    var md5: String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.deinitialize(count: digestLen)
        
        return String(format: hash as String)
    }
}
