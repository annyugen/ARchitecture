//
//  TrackingStatusViewController.swift
//  ARchitectureWithUI
//
//  Created by An Nguyen on 6/16/18.
//  Copyright © 2018 An Nguyen. All rights reserved.
//

import Foundation
import ARKit

class TrackingStatusViewController: UIViewController {
   
    @IBOutlet weak private var statusLabel: UILabel!

    // MARK: - Types
    enum MessageType {
        case trackingStateEscalation
        case planeEstimation
        case contentPlacement
        case focusSquare
        
        static var all: [MessageType] = [
            .trackingStateEscalation,
            .planeEstimation,
            .contentPlacement,
            .focusSquare
        ]
    }
    
    func showMessage(_ text: String) {
        statusLabel.text = text
    }
    
    func showTrackingQualityInfo(for trackingState: ARCamera.TrackingState) {
        showMessage(trackingState.outputString)
    }
    
}

extension ARCamera.TrackingState {
    var outputString: String {
        switch self {
        case .notAvailable:
            return "Tracking Unavailable"
        case .normal:
            return "Tracking Normal"
        case .limited(.excessiveMotion):
            return "Tracking limited\n Excessive Motion"
        case .limited(.insufficientFeatures):
            return "Tracking limited\n Insufficient Features"
        case .limited(.initializing):
            return "Initializing"
        case .limited(.relocalizing):
            return "Recovering from interruption"
        }
    }
}

