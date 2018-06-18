//
//  ARState.swift
//  ARchitectureWithUI
//
//  Created by An Nguyen on 6/13/18.
//  Copyright © 2018 An Nguyen. All rights reserved.
//

import Foundation
enum ARState: String {
    case initialized = "initialized", ready = "ready", tempUnavailable = "temporarily unavailable", failed = "failed"
    
    var stateDisplay: String{
        switch self {
        case .initialized:
            return "Scanning for horizontal plane"
        case .ready:
            return "Horizontal plane detect!"
        case .tempUnavailable:
            return "Temporarily Unavailable"
        case .failed:
            return "App failed to run! Need to restart!"
        }
    }
}
