//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 1/15/21.
//

import Foundation

extension Collection {
    subscript(safe i: Index) -> Iterator.Element? {
        return self.indices.contains(i) ? self[i] : nil
    }
}
