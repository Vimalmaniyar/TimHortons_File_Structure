//
//  ThemeTextDropDown.swift
//  IOConnect
//
//  Created by vimal maniyar on 01/11/22.
//  Copyright © 2022 Samir. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

protocol ThemeFloatingTextFieldDelegates:NSObject{
    func textFieldShouldReturn(_ withView: ThemeFloatingTextField) -> Bool
    func textFieldDidBeginEditing(_ withView: ThemeFloatingTextField)
}




@IBDesignable
class ThemeFloatingTextField: UIView {
    
    let kCONTENT_XIB_NAME = "ThemeFloatingTextField"

    //MARK: - IBOutlets
    @IBOutlet private weak var lblTitle:UILabel!
    @IBOutlet private weak var lblDescriptionField:UILabel!
    
    @IBOutlet private weak var lblSeprator:UILabel!
    
    @IBOutlet private weak var textField:UITextField!
    @IBOutlet private weak var contentView:UIView!
    @IBOutlet weak var btnRightIcon:UIButton!
    
    
    //MARK: - Variables
    var shouldStartFirstTimeEditing = false
    var doneAction:(()->())?
    
    var rightButtonAction:(()->())?
    
    @IBInspectable
    private var hideRightBtn: Bool{
        set{
            btnRightIcon.isHidden = newValue
        }get{
            return btnRightIcon.isHidden
        }
    }
    @IBInspectable
    private var showDescriptionField: Bool{
        set{
            lblDescriptionField.isHidden = !newValue
        }get{
            return lblDescriptionField.isHidden
        }
    }
    
    weak var delegate : ThemeFloatingTextFieldDelegates?
    
    var isTfFirstResponder:Bool{
        get{
            return textField.isFirstResponder
        }
    }
    
    var isSecureEntry:Bool{
        get{
            return textField.isSecureTextEntry
        }
        set {
            textField.isSecureTextEntry = newValue
        }
    }
    
    var shouldChangeCharacter:Bool = true
    var maxCharacters:Int?
    
    var textFieldInputView:UIView?{
        get{
            return textField.inputView
        }set{
            textField.inputView = newValue
        }
    }
    var text:String?{
        set{
            textField.text = newValue
            lblTitle.isHidden = (text ?? "").isEmpty
        }get{
            return textField.text
        }
    }
    var isEditingAllowd:Bool{
        set{
            textField.isUserInteractionEnabled = newValue
            btnRightIcon.isUserInteractionEnabled = newValue
        }get{
            return textField.isUserInteractionEnabled
        }
    }
    
    var title:String{
        set{
            lblTitle.text = newValue
            textField.attributedPlaceholder = NSAttributedString(
                string: title,
                attributes: [NSAttributedString.Key.foregroundColor: titleTextColor,.font:textField.font ?? UIFont().getCervinoRegularFont(20)]
            )
            lblTitle.isHidden = textField.text!.isEmpty
        }get{
            return lblTitle.text ?? ""
        }
   }
    var textFieldtextColor : UIColor? {
        set {
            textField.textColor = textFieldTextColor
        }
        get {
            return textField.textColor
        }
    }
   private var titleTextColor:UIColor{
        set{
            lblTitle.textColor = newValue
           // textField.textColor = newValue
        }get{
            return lblTitle.textColor
        }
    }
    
    private var textFieldTextColor:UIColor?{
         set{
             textField.textColor = newValue
         }get{
             return textField.textColor
         }
     }
    
    func makeResponder(){
        self.textField.becomeFirstResponder()
    }
    func resignResponder(){
        self.textField.resignFirstResponder()
    }
    
    //MARK: - IBActions
    
    @IBAction func btnRightTapped(_ sender:UIButton?){
        textField.isSecureTextEntry = ((sender?.isSelected) != nil)
        rightButtonAction?()
    }
    
    //MARK: - Custom Methods
    
    func setField(placeholder:String,text:String,textContentType:UITextContentType?,isForPassWord:Bool,textColor:UIColor  = ThemeColors.red.getColor, textFieldTextColor:UIColor  = .black,textFont:UIFont?,maxCharacter:Int? = nil,keyboardType:UIKeyboardType = .default,sepratorColor:UIColor = ThemeColors.red.getColor,allowEditing:Bool = true,showRightIcon:Bool = false, rightIconNormal:IcoMoonIcons? = nil,rightIconSelected:IcoMoonIcons? = nil,rightIconPixelSize:CGFloat? = nil, autoCapitaize: UITextAutocapitalizationType = .none, rightIconColor: UIColor? = .white){
        textField.autocorrectionType = .no
        textField.autocapitalizationType = autoCapitaize
        lblTitle.font = UIFont().getSofiaProBoldFont(14)
        textField.font = textFont
        textField.textContentType = textContentType
        textField.keyboardType = keyboardType
        
        lblSeprator.backgroundColor = sepratorColor
        
        self.maxCharacters = maxCharacter
        
        if isForPassWord {
            textField.isSecureTextEntry = true
            
        }
        
        showDescriptionField  = false
        self.titleTextColor = textColor
        self.textFieldTextColor = textFieldTextColor
        //self.textField.textColor = .black
        self.title = placeholder
        self.text = text
        self.isEditingAllowd = allowEditing
        //self.lblTitle.textColor = ThemeColors.red.getColor
        hideRightBtn = !showRightIcon
        
        
        if showRightIcon{
            btnRightIcon.titleLabel?.font = UIFont(name: Font.iComoon, size: rightIconPixelSize ?? 0)
            if let normal = rightIconNormal{
                btnRightIcon.setTitle(normal.rawValue, for: .normal)
                btnRightIcon.setTitleColor(rightIconColor, for: .normal)
            }
            if let selected = rightIconSelected{
                btnRightIcon.setTitle(selected.rawValue, for: .selected)
                btnRightIcon.setTitleColor(rightIconColor, for: .selected)
            }
            
        }
    }
    @objc func donePressed(){
        doneAction?()
    }
    
    func setDescriptionField(description:String? = nil,descriptionTextColor:UIColor = ThemeColors.brown.getColor,descriptionFont:UIFont?){
            showDescriptionField = true
            
            lblDescriptionField.text = description
            lblDescriptionField.textColor = descriptionTextColor
            lblDescriptionField.font = descriptionFont ?? UIFont().getCervinoRegularFont(20)
        self.layoutIfNeeded()
    }
    func setDOBPlaceholder(){
        let titleAtt = [NSAttributedString.Key.foregroundColor: ThemeColors.red.getColor,.font: UIFont().getSofiaProBoldFont(14)]
        let formatAtt = [NSAttributedString.Key.foregroundColor: ThemeColors.brown.getColor,.font: UIFont().getSofiaProBoldFont(14)]

        let titleStr = NSMutableAttributedString(string: "Date of birth", attributes: titleAtt)
        let formatStr = NSMutableAttributedString(string: "", attributes: formatAtt)

        titleStr.append(formatStr)
        textField.attributedPlaceholder = titleStr
        
        let lbltitleAtt = [NSAttributedString.Key.foregroundColor: ThemeColors.red.getColor,.font:UIFont().getSofiaProRegularFont(12)]
        let lblformatAtt = [NSAttributedString.Key.foregroundColor: ThemeColors.brown.getColor,.font:UIFont().getSofiaProRegularFont(12)]
        let lbltitleStr = NSMutableAttributedString(string: "Date of birth", attributes: lbltitleAtt)
        let lblformatStr = NSMutableAttributedString(string: "", attributes: lblformatAtt)
        lbltitleStr.append(lblformatStr)
        lblTitle.attributedText = lbltitleStr
    }
    
    func setReferalCodePlaceholder(){
        let titleAtt = [NSAttributedString.Key.foregroundColor: ThemeColors.red.getColor,.font: UIFont().getSofiaProBoldFont(14)]
        let formatAtt = [NSAttributedString.Key.foregroundColor: ThemeColors.brown.getColor,.font: UIFont().getSofiaProBoldFont(14)]

        let titleStr = NSMutableAttributedString(string: "Friends referal code", attributes: titleAtt)
        let formatStr = NSMutableAttributedString(string: " (1234)", attributes: formatAtt)

        titleStr.append(formatStr)
        textField.attributedPlaceholder = titleStr
        
        let lbltitleAtt = [NSAttributedString.Key.foregroundColor: ThemeColors.red.getColor,.font:UIFont().getSofiaProRegularFont(12)]
        let lblformatAtt = [NSAttributedString.Key.foregroundColor: ThemeColors.brown.getColor,.font:UIFont().getSofiaProRegularFont(12)]
        let lbltitleStr = NSMutableAttributedString(string: "Friend referal code", attributes: lbltitleAtt)
        let lblformatStr = NSMutableAttributedString(string: " (1234)", attributes: lblformatAtt)
        lbltitleStr.append(lblformatStr)
        lblTitle.attributedText = lbltitleStr
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        contentView.fixInView(self)
     
        textField.iq.toolbar.doneBarButton.setTarget(self, action: #selector(donePressed))
        textField.addTarget(self, action: #selector(textChnaged(textField:)), for: .editingChanged)
        
        textField.delegate = self
    }
    @objc private func textChnaged(textField:UITextField){
        lblTitle.isHidden = textField.text!.isEmpty
    }
}
extension ThemeFloatingTextField:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.textFieldDidBeginEditing(self)
        shouldStartFirstTimeEditing = true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        delegate?.textFieldShouldReturn(self)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        lblTitle.isHidden = textField.text!.isEmpty
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if shouldChangeCharacter{
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
            guard range.location == 0 else {
                if maxCharacters != nil  {
                    return newString.length <= maxCharacters!
                }
                return true
            }
            let valid =  newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location != 0
            return valid
        }
        return false
    }
}



extension UITextField {
  func setLeftView(image: UIImage) {
    let iconView = UIImageView(frame: CGRect(x: 10, y: 15, width: 15, height: 15)) // set your Own size
    iconView.image = image
    let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 45))
    iconContainerView.addSubview(iconView)
    leftView = iconContainerView
    leftViewMode = .always
    self.tintColor = .lightGray
      self.layer.borderColor = UIColor.lightGray.cgColor
  }
}
