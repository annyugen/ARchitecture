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
    var ViewController:ViewController?
    var buttonHidden = false
    @IBOutlet weak var TrackingLabel: UILabel!
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
        if (sender.isOn == false) {
            
        }
    }
    
    
    @IBAction func featurePointSwitch(_ sender: UISwitch) {
    }
    
    
}
