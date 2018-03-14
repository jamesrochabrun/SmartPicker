//
//  String-Extension.swift
//  SmartPicker
//
//  Created by James Rochabrun on 3/13/18.
//  Copyright © 2018 james rochabrun. All rights reserved.
//

import Foundation

extension String {
    
    func removingWhiteSpaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
