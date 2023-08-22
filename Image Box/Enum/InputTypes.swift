//
//  InputTypes.swift
//  Image Box
//
//  Created by Krunal on 23/11/2022.
//

import Foundation


enum InputTag: Int {
    case x = 10,
         y = 11,
         width = 12,
         height = 13
}

enum InputType {
    case x(xPoint: String),
         y(yPoint: String),
         width(width: String),
         height(height: String)
}
