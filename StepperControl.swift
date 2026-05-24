//
//  StepperControl.swift
//  TeamHortons
//
//  Created by Magnatesage  on 08/12/22.
//

import UIKit

class StepperControl: UIView {
    @IBOutlet weak var viewBg: UIView!
    
    @IBOutlet weak var btnPlush: UIButton!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var btnMinus: UIButton!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func disableMinusButton(isDisable: Bool) {
        self.btnMinus.isEnabled = isDisable
    }
    func disablePlushButton(isDisable: Bool) {
        self.btnMinus.isEnabled = isDisable
    }
    func hideShowMinusButton(isHidden: Bool) {
        self.btnMinus.isHidden = isHidden
    }
    
    func hideShowPlushButton(isHidden: Bool) {
        self.btnPlush.isHidden = isHidden
    }
}
