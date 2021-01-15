//
//  Bool.swift
//  Peak Client App
//
//  Created by Ethan Hardacre  on 10/29/20.
//  Copyright © 2020 Ethan Hardacre . All rights reserved.
//

import Foundation

extension Bool {
    static func ^ (left: Bool, right: Bool) -> Bool {
        return left != right
    }
}
