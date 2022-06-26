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
    
    static let base32Codes = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F",
    "G", "H", "J", "K", "M", "N", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    static let base32ForbiddenLetters: Set<String> = ["I", "L", "O", "P"]
    static let base32DecodeMap = ["0": 0, "1": 1, "2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9, "A": 10, "B": 11, "C": 12, "D": 13, "E": 14, "F": 15, "G": 16, "H": 17, "J": 18, "K": 19, "M": 20, "N": 21, "Q": 22, "R": 23, "S": 24, "T": 25, "U": 26, "V": 27, "W": 28, "X": 29, "Y": 30, "Z": 31]
    
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
    
    // Base 32 hash.
    // numberOfDigits: Number of base32 digits required.
    public func hashBase32(numberOfDigits: Int) -> String {
        let md5Data = MD5(string: self)
        let maxNumberOfDigits = md5Data.count * 8 / 5
        let theNumberOfDigits = numberOfDigits < maxNumberOfDigits ? numberOfDigits : maxNumberOfDigits
        let theNumberOfBytes = theNumberOfDigits * 5 / 8
        var index = md5Data.count - theNumberOfBytes
        var buffer: UInt64 = 0
        var count = 0
        var result = ""
        while index < md5Data.count && count < 8 {
            buffer = buffer | UInt64(md5Data[index])
            buffer = buffer << 8
            count += 1
            index += 1
        }
        return result
    }
    
    public static func nextLetter(_ letter: String) -> String {

        // Check if string is build from exactly one Unicode scalar:
        guard let uniCode = UnicodeScalar(letter) else {
            return ""
        }
        switch uniCode {
        case "0" ..< "Z":
            if let unicodeScalar = UnicodeScalar(uniCode.value + 1) {
                let nextChar = String(unicodeScalar)
                if base32ForbiddenLetters.contains(nextChar) {
                    return nextLetter(nextChar)
                } else {
                    return nextChar
                }
            }
        default:
            break
        }
        return ""
    }
}
