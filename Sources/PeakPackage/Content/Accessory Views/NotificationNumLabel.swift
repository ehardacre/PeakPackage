//
//  NotificationNumLabel.swift
//  Peak Client App
//
//  Created by Ethan Hardacre  on 11/5/20.
//  Copyright © 2020 Ethan Hardacre . All rights reserved.
//

import Foundation
import SwiftUI

/**
 #NotificationNumLabel
 this is a label that indicates the number of unread messages like is shown in the corner of apps
 */
struct NotificationNumLabel : View {
    
    //the number of notifications
    var number : Int
    //the position of the notification
    var position = CGPoint(x: 25, y: 0)
    
    var body: some View {
        if number != 0{
            ZStack {
                Capsule()
                    .fill(Color.red)
                    .frame(
                        width: 10 * CGFloat(numOfDigits()),
                        height: 15,
                        alignment: .topTrailing)
                    .position(position)
                Text("\(number)")
                    .foregroundColor(Color.white)
                    .font(Font.system(size: 12)
                        .bold())
                    .position(position)
            }
        }else{
            EmptyView()
        }
    }
    
    //number of digits determines the size of the capsule
    func numOfDigits() -> Float {
        let numOfDigits = Float(String(number).count)
        return numOfDigits == 1 ? 1.5 : numOfDigits
    }
}
