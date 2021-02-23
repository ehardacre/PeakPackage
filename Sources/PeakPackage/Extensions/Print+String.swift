//
//  Print.swift
//  Peak Client App
//
//  Created by Ethan Hardacre  on 8/25/20.
//  Copyright © 2020 Ethan Hardacre . All rights reserved.
//

import Foundation

public struct printTags{
    public static var error = "#"
    public static var database = "^"
    public static var general = "*"
}

/**
 # Print
 this print shadows Swift.print. it adds a tag to the beginning of programmed print statements so that the output log can be filtered to find specific print statements.
 - Parameter tag : (String) the tag that is added to the beginning of prints (default is *)
 */
public func printr(_ items: Any..., tag: String = printTags.general, separator: String = " ", terminator: String = "\n") {
        let output = items.map { "\(tag) \($0)" }.joined(separator: separator)
        Swift.print(output, terminator: terminator)
        defaults.addToLogs(log: output)
}

//extension to string to determine numeric strings
extension String {
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
    
    func makeNumeric() -> String{
        return self.components(separatedBy: CharacterSet.letters.union(CharacterSet.punctuationCharacters)).joined().replacingOccurrences(of: " ", with: "")
    }
    
    static func fromInt(_ number : Int?) -> String?{
        if number != nil{
            return String(number!)
        }
        return nil
    }
}

extension String {
    mutating func withDecimalPrecision(_ prec : Int) -> String{
        if self.contains("."){
            let splt = self.split(separator: ".")
            let before = splt[0]
            if prec == 0 { return String(before) }
            var after = splt[1]
            after = after.prefix(prec)
            self = before + "." + after
        }
        return self
    }
    
    func replaceCharactersFromSet(characterSet: CharacterSet, replacementString: String = "") -> String {
        return components(separatedBy: characterSet).joined(separator: replacementString)
    }
    
    var digits: Self { filter(\.isWholeNumber) }
    var integer: Int? { Int(self) }
}
