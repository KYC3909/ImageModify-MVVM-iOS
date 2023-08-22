//
//  Thread Checker.swift
//  Image Box
//
//  Created by Krunal on 22/11/2022.
//

import UIKit

func guaranteeMainThread(_ work: @escaping () -> Void) {
    Thread.isMainThread ? work() : DispatchQueue.main.async(execute: work)
}
