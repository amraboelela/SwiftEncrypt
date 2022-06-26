//
//  String.swift
//  DarkEyeCore
//
//  Created by Amr Aboelela on 6/11/22.
//  Copyright © 2022 Amr Aboelela. All rights reserved.
//

import Foundation
import CommonCrypto

extension String {
    
    func MD5(string: String) -> Data {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: length)
        
        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData
    }

    // Hexadecimal hash.
    // numberOfDigits: Number of hexadecimal digits required.
    public func hashBase16(numberOfDigits: Int) -> String {
        let md5Data = MD5(string: self)
        let md5Hex = md5Data.map { String(format: "%02hhx", $0) }.joined()
        return md5Hex.suffix(numberOfDigits).lowercased()
    }
}
