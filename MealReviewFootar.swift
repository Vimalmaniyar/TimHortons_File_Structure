//
//  MealReviewFootar.swift
//  TeamHortons
//
//  Created by Magnatesage  on 30/12/22.
//

import UIKit
protocol MealReviewFooterDelegate {
    func minusClick(sender: UIButton)
    func plushClick(sender: UIButton)
    func addToOrder(sender: UIButton)
    func cancelOrder(sender:UIButton)
}

class MealReviewFootar: UIView {

    @IBOutlet weak var btnAddToOrder: CornerRadiusButton!
    @IBOutlet weak var btnCancelOrder: CornerRadiusButton!
    @IBOutlet weak var btnMinus: CornerRadiusButton!
    @IBOutlet weak var btnPlus: CornerRadiusButton!
    @IBOutlet weak var lblCount: UILabel!
    
    var delegate : MealReviewFooterDelegate?
    
    class func instanceFromNib() -> UIView {
            return UINib(nibName: "MealReviewFootar", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    @IBAction func btnPlushClick(_ sender: UIButton) {
        delegate?.plushClick(sender: sender)
    }
    
    @IBAction func btnCancelClick(_ sender: UIButton) {
        delegate?.cancelOrder(sender: sender)
    }
    @IBAction func btnAddToOrderClick(_ sender: UIButton) {
        delegate?.addToOrder(sender: sender)
    }
    @IBAction func btnMinusClick(_ sender: UIButton) {
        delegate?.minusClick(sender: sender)
    }
}
