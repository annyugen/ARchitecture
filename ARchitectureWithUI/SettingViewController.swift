//
//  SettingViewController.swift
//  ARchitectureWithUI
//
//  Created by An Nguyen on 7/8/18.
//  Copyright © 2018 An Nguyen. All rights reserved.
//

import Foundation
import UIKit

class SettingViewController: UIViewController {
    @IBOutlet weak var PopUpView: UIView!
    @IBOutlet weak var TrackingLabel: UILabel!
    
    var ViewController:ViewController?
    var buttonHidden = false
    var completionHandler:((String) -> Int)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PopUpView.layer.cornerRadius = 10
        PopUpView.layer.masksToBounds = true
        
        TrackingLabel.isHidden = buttonHidden

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    @IBAction func closePopUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        //self.performSegue(withIdentifier: "backToMain", sender: self)
        
    }

    @IBAction func trackingStateSwitch(_ sender: UISwitch) {
        let getState = storyboard!.instantiateInitialViewController() as! ViewController
        
        if (sender.isOn == false) {
            getState.state = true
        } else{
            getState.state = false
        }
    }
    
    @IBAction func featurePointSwitch(_ sender: UISwitch) {
        let getFeatureStatus = storyboard!.instantiateInitialViewController() as! ViewController
        if (sender.isOn == true){
            let temp = getFeatureStatus.featurePts
            getFeatureStatus.featurePts = temp
        } else {
            getFeatureStatus.featurePts = []
        }
    }
    
    
}
