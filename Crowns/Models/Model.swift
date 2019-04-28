//
//  Model.swift
//  Crowns
//  Copyright © 2019 halftonedesign. All rights reserved.
//

import Foundation


enum Faction {
    case church
    case commoners
    case merchants
    case military
    
    func asset() -> String {
        switch self {
        case .church:
            return "church-mask"
        case .commoners:
            return "commoners-mask"
        case .merchants:
            return "merchants-mask"
        case .military:
            return "military-mask"
        }
    }
}
