//
//  THAlertView.swift
//  TeamHortons
//
//  Created by Magnatesage  on 11/12/22.
//

import UIKit

protocol THAlertViewDelegate {
    func removeAlert(sender: THAlertView)
    func doneClickOnAlert(sender: THAlertView)
}
class THAlertView: UIView {
    // MARK: – IBOutlets
    @IBOutlet  var lblTitle: UILabel!
    @IBOutlet  var lblDescritpion: UILabel!
    @IBOutlet  var cancelButton: UIButton!
    @IBOutlet  var okButton: UIButton!
    var delegate: THAlertViewDelegate?
    
    private func setupView() {
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 4
        self.okButton.isEnabled = true
    }
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    class func instanceFromNib() -> THAlertView {
        let view = UINib(nibName: "THAlertView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! THAlertView
        view.setupView()
        return view
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.delegate?.removeAlert(sender: self)
    }

    @IBAction func done(_ sender: Any) {
        self.delegate?.doneClickOnAlert(sender: self)
    }
}

