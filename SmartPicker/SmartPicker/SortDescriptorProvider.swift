//
//  SortDescriptorProvider.swift
//  SmartPicker
//
//  Created by james rochabrun on 3/10/18.
//  Copyright © 2018 james rochabrun. All rights reserved.
//

import Foundation

// MARK: - protocol
protocol SortDescriptorProvider {
    var sortDescriptor: NSSortDescriptor { get }
}

enum SortProvider {
    case creationDate /// when adding a new case here we also need to add one sortdescriptor for this case
}

// MARK: - extension for SortDescriptorProvider conformance, returns a sortDescriptor
extension SortProvider: SortDescriptorProvider {
    
    var sortDescriptor: NSSortDescriptor {
        switch self {
        case .creationDate:
            return NSSortDescriptor(key: "creationDate", ascending: true)
        }
    }
}
