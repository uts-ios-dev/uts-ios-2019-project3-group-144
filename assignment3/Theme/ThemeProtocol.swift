//
//  ThemeProtocol.swift
//  assignment3
//
//  Created by Jacob Efendi on 6/2/19.
//  Copyright © 2019 group144. All rights reserved.
//

import Foundation
import UIKit

protocol ThemeProtocol {
    var mainFontName: String { get }
    var font: UIColor {get}
    var background: UIColor { get }
    var placeHolder: UIColor { get }
    var accent: UIColor { get }
    var tint: UIColor { get }
}
