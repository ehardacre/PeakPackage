//
//  CGSize.swift
//  Peak Client App
//
//  Created by Ethan Hardacre  on 9/17/20.
//  Copyright © 2020 Ethan Hardacre . All rights reserved.
//

import Foundation
import CoreGraphics

extension CGSize {
    func multiplyBy(_ factor : CGFloat) -> CGSize{
        let newWidth = self.width * factor
        let newHeight = self.height * factor
        return CGSize(width: newWidth, height: newHeight)
    }
}
