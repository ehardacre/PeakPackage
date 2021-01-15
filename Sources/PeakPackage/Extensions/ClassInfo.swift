//
//  ClassInfo.swift
//  Peak Client App
//
//  Created by Ethan Hardacre  on 10/1/20.
//  Copyright © 2020 Ethan Hardacre . All rights reserved.
//

import Foundation

struct ClassInfo : CustomStringConvertible, Equatable {
    let classObject: AnyClass
    let className: String

    init?(_ classObject: AnyClass?) {
        guard classObject != nil else { return nil }

        self.classObject = classObject!

        let cName = class_getName(classObject)
        self.className = String(cString: cName)
    }

    var superclassInfo: ClassInfo? {
        let superclassObject: AnyClass? = class_getSuperclass(self.classObject)
        return ClassInfo(superclassObject)
    }

    var description: String {
        return self.className
    }

    static func ==(lhs: ClassInfo, rhs: ClassInfo) -> Bool {
        return lhs.className == rhs.className
    }
}
