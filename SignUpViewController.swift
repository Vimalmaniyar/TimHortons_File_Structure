//
//  SignUpViewController.swift
//  TeamHortons
//
//  Created by vimal maniyar on 04/11/22.
//

import UIKit
import IQKeyboardManagerSwift
import CoreTelephony

class SignUpViewController: UIViewController, CountryCodePickerDelegate {
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var btnSignUp:UIButton!
    @IBOutlet weak var btnBack:UIButton!
    
    @IBOutlet weak var btnPrefrenceCheckBox:UIButton!
    @IBOutlet weak var btnAgeCheckBox:UIButton!
    @IBOutlet weak var btnTermsCheckBox:UIButton!
    
    @IBOutlet weak var vwFirstName:ThemeFloatingTextField!
    @IBOutlet weak var vwLastName:ThemeFloatingTextField!
    @IBOutlet weak var vwPassword:ThemeFloatingTextField!
    @IBOutlet weak var vwConfirmPassword:ThemeFloatingTextField!
    
    @IBOutlet weak var vwEmail:ThemeFloatingTextField!
    @IBOutlet weak var vwPostCode:ThemeFloatingTextField!
    
    @IBOutlet weak var vwCountryCode: UIView!
    @IBOutlet weak var vwPhone:ThemeFloatingTextField!
    @IBOutlet weak var vwDOB:ThemeFloatingTextField!
    @IBOutlet weak var btnCountryCode: UIButton!
    @IBOutlet weak var tvPrefrenceAdd:UILabel!
    @IBOutlet weak var tvConfirmAge:UITextView!
    @IBOutlet weak var tvTerms:UITextView!
    @IBOutlet weak var tvPrivacy:UITextView!
    @IBOutlet weak var vwReferalCode: ThemeFloatingTextField!
    var countryCodePicker: CountryCodePickerViewController!
    var current_country_name : String?
    var current_country_code : String?
    var curretnCountryCode : String?
    var dictionary_user_current_contry : NSDictionary?
    var arrCountry = [CountryNew]()
    //MARK: - Variables
    
    // MARK: - Stored Properties
        var signUpViewModel: SignUpViewModel!
    
    var datePicker = UIDatePicker()
   
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setFloatingTextFields()
        signUpViewModel = SignUpViewModel()
        bindData()
        // Do any additional setup after loading the view.
        
        let carrier = CTTelephonyNetworkInfo().subscriberCellularProvider
        curretnCountryCode = carrier?.isoCountryCode

        countryCodePicker = CountryCodePickerViewController(nibName: "CountryCodePickerViewController", bundle: nil)

        self.countryCodePicker.countryCodePickerDelegate = self
        self.countryCodePicker.showPhoneNumbers = true
        self.countryCodePicker.countries = countryNamesByCode()
        let locale = Locale.current
        let countryCode = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String?
        let titleCode = self.countryCodePicker.countries.filter({$0.code == countryCode})
        btnCountryCode.setTitle(titleCode.first?.phoneCode ?? "+44", for: .normal)
        
    }
    
    //MARK: - IBActions
    
    @IBAction func btnCountryCodeClick(_ sender: UIButton) {
        self.present(countryCodePicker, animated: true) {
            
        }
    }
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSignUpTapped(_ sender:UIButton?){
        let dateOfBirth = (vwDOB.text?.isEmpty ?? true) ? "" : vwDOB.text!.dd_mm_yyyy_slash_to_yyyy_mm_dd_str()
        signUpViewModel.updateAllFields(firstName: vwFirstName.text!, lastName: vwLastName.text!, password: vwPassword.text!, confirm: vwConfirmPassword.text!, email: vwEmail.text!, postCode: vwPostCode.text!, phoneNumber: vwPhone.text!, dateOfBirth: dateOfBirth, checkPreference: btnPrefrenceCheckBox.isSelected, checkIConfim: btnTermsCheckBox.isSelected , checkIAgree: btnAgeCheckBox.isSelected, referalCode: self.vwReferalCode.text!, countryCode: (btnCountryCode.titleLabel?.text!)!)
        
        switch signUpViewModel.inputValidation() {
        case .Correct:
            singUpAPI()
        case .Incorrect:
            //Display Error Message
            return
        }
    }
    
    @IBAction func btnCheckBoxTapped(_ sender:UIButton?){
        sender?.isSelected.toggle()
    }
    
    //MARK: - Custom Methods
    fileprivate func setFloatingTextFields(){
        vwFirstName.setField(placeholder: "First Name*", text: "", textContentType: .givenName, isForPassWord: false, textFont: UIFont().getSofiaProBoldFont(Global.defaultSansProBoldSize), sepratorColor: ThemeColors.brown.getColor, autoCapitaize: .words)
       // vwFirstName.setField(placeholder: "First Name*", text: "", textFont: UIFont().getSofiaProBoldFont(Global.defaultSansProBoldSize),sepratorColor: ThemeColors.brown.getColor)
        
        vwLastName.setField(placeholder: "Last Name*", text: "", textContentType: .familyName, isForPassWord: false, textFont: UIFont().getSofiaProBoldFont(Global.defaultSansProBoldSize),sepratorColor: ThemeColors.brown.getColor, autoCapitaize: .words)
        vwPhone.setField(placeholder: "Phone Number", text: "", textContentType: .telephoneNumber, isForPassWord: false, textFont: UIFont().getSofiaProBoldFont(Global.defaultSansProBoldSize),keyboardType: .phonePad , sepratorColor: ThemeColors.brown.getColor)
        
        vwDOB.setField(placeholder: "Date of birth", text: "", textContentType: nil, isForPassWord: false, textFont: UIFont().getSofiaProBoldFont(Global.defaultSansProBoldSize),keyboardType: .default,sepratorColor: ThemeColors.brown.getColor)
        vwDOB.setDOBPlaceholder()
        
        vwEmail.setField(placeholder: "Email*", text: "", textContentType: .emailAddress, isForPassWord: false, textFont: UIFont().getSofiaProBoldFont(Global.defaultSansProBoldSize), keyboardType: .emailAddress,sepratorColor: ThemeColors.brown.getColor)
        vwEmail.setDescriptionField(description: "This will be your username", descriptionTextColor: ThemeColors.brown.getColor, descriptionFont: UIFont().getSofiaProRegularFont(12))
        
        vwPostCode.setField(placeholder: "Post Code", text: "", textContentType: .postalCode, isForPassWord: false, textFont: UIFont().getSofiaProBoldFont(Global.defaultSansProBoldSize),keyboardType: .default, sepratorColor: ThemeColors.brown.getColor)
        vwPostCode.setDescriptionField(description: "This will help us give you the best deals", descriptionTextColor: ThemeColors.brown.getColor, descriptionFont: UIFont().getSofiaProRegularFont(12))
        
        vwPassword.setField(placeholder: "Password*", text: "", textContentType: .oneTimeCode, isForPassWord: true, textFont: UIFont().getSofiaProBoldFont(Global.defaultSansProBoldSize),maxCharacter: 16, sepratorColor: ThemeColors.brown.getColor, showRightIcon: true, rightIconNormal: IcoMoonIcons.iconEyeClose, rightIconSelected: IcoMoonIcons.iconEyeOpen, rightIconPixelSize: 15, rightIconColor: .black)
        vwPassword.rightButtonAction = { [weak self]  in
            self?.vwPassword.btnRightIcon.isSelected = !(self?.vwPassword.btnRightIcon.isSelected)!
            self?.vwPassword.isSecureEntry = !(self?.vwPassword.btnRightIcon.isSelected)!
        }
        vwConfirmPassword.setField(placeholder: "Confirm Password*", text: "", textContentType: .oneTimeCode, isForPassWord: true, textFont: UIFont().getSofiaProBoldFont(Global.defaultSansProBoldSize),maxCharacter: 16, sepratorColor: ThemeColors.brown.getColor, showRightIcon: true, rightIconNormal: IcoMoonIcons.iconEyeClose, rightIconSelected: IcoMoonIcons.iconEyeOpen, rightIconPixelSize: 15, rightIconColor: .black)
        vwConfirmPassword.rightButtonAction = { [weak self]  in
            self?.vwConfirmPassword.btnRightIcon.isSelected = !(self?.vwConfirmPassword.btnRightIcon.isSelected)!
            self?.vwConfirmPassword.isSecureEntry = !(self?.vwConfirmPassword.btnRightIcon.isSelected)!
        }
        
        vwReferalCode.setField(placeholder: "Friend referal code", text: "", textContentType: .oneTimeCode, isForPassWord: false, textFont: UIFont().getSofiaProBoldFont(Global.defaultSansProBoldSize),sepratorColor: ThemeColors.brown.getColor)
        vwReferalCode.setReferalCodePlaceholder()
        _ = [btnAgeCheckBox,btnTermsCheckBox,btnPrefrenceCheckBox].map({$0?.isSelected = false})
        //IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses = [UIView.self]
        
        _ = [vwFirstName,vwLastName,vwPassword,vwConfirmPassword,vwEmail,vwPostCode,vwPhone,vwDOB,vwReferalCode].map({$0?.delegate = self})
        
        setDatePicker()
        vwDOB.textFieldInputView = datePicker
        vwDOB.shouldChangeCharacter = false
        vwDOB.doneAction = { [weak self]  in
            guard let self = self else{return}
            self.dateChanged()
        }
    
        let attributedString = NSMutableAttributedString(string: "* I agree with Tim Hortons Terms and conditions")
        let url = URL(string: Global.TearmAndConditionSigUpURL)!

        // Set the 'click here' substring to be the link
        attributedString.setAttributes([.link: url], range: attributedString.mutableString.range(of: "Terms and conditions"))
     //   attributedString.setAttributes([.link: url], range: NSMakeRange(25, 20))
        //attributedStringPrivacy.setAttributes([.link: urlPrivacy], range: attributedStringPrivacy.mutableString.range(of: "Privacy Statement"))

        self.tvTerms.attributedText = attributedString
        self.tvTerms.isUserInteractionEnabled = true
        self.tvTerms.isEditable = false

        // Set how links should appear: blue and underlined
        self.tvTerms.linkTextAttributes = [
            .foregroundColor: ThemeColors.link.getColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        let attributedStringPrivacy = NSMutableAttributedString(string: "By signing up, I ackowledge I have read Tim Hortons Privacy Statement")
        let urlPrivacy = URL(string: Global.PrivacyPolicyURLSingup)!
        // Set the 'click here' substring to be the link
        attributedStringPrivacy.setAttributes([.link: urlPrivacy], range: attributedStringPrivacy.mutableString.range(of: "Privacy Statement"))
     //   attributedStringPrivacy.setAttributes([.link: urlPrivacy], range: NSMakeRange(52, 17))
        //attributedStringPrivacy.setAttributes([.link: urlPrivacy], range: attributedStringPrivacy.mutableString.range(of: "Privacy Statement"))

        self.tvPrivacy.attributedText = attributedStringPrivacy
        self.tvPrivacy.isUserInteractionEnabled = true
        self.tvPrivacy.isEditable = false
        
        self.tvTerms.delegate = self
        self.tvPrivacy.delegate = self

        // Set how links should appear: blue and underlined
        self.tvPrivacy.linkTextAttributes = [
            .foregroundColor: ThemeColors.link.getColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
    }
    
    private func setDatePicker(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = ""
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        datePicker.locale = Locale(identifier: "en_US_POSIX")
        
        let today  = Date()
        let calender = Calendar.current
        let minAge = calender.date(byAdding: .year, value: -18, to: today)
        let maxAge = calender.date(byAdding: .year, value: -100, to: today)
        
        datePicker.minimumDate = maxAge
        datePicker.maximumDate = minAge
        datePicker.date = datePicker.maximumDate!
        
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }
    
    @objc func dateChanged(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateStr = dateFormatter.string(from: datePicker.date)
        vwDOB.text = dateStr
    }
    
    func bindData() {
        signUpViewModel.errorMessage.bind {
            guard let errorMessage = $0 else { return }
            self.view.alpha = 0.5
            self.showThemeAlertVC(type: .common(msg: errorMessage)) { isSuccess in
                self.view.alpha = 1
            }
            
        }
    }
    
    func singUpAPI() {
        _progressBar.showProgressBar(uiView: self.view)
        signUpViewModel.singUp { apiResponse in
            _progressBar.hideProgressBar(uiView: self.view)
            if apiResponse.success! {
                self.view.alpha = 0.5
                self.showThemeAlertVC(type: .common(msg: "Signup Successful")) { isSuccess in
                    self.view.alpha = 1
                    let tabVC = self.storyboard!.instantiateViewController(withIdentifier: "ConfirmationViewController") as! ConfirmationViewController
                    tabVC.strEmail = self.vwEmail.text!
                    
                    self.navigationController?.pushViewController(tabVC, animated:true)
                }
                
            }
            else {
                self.view.alpha = 0.5
                self.showThemeAlertVC(type: .common(msg: apiResponse.message ?? "Signup Api error")) { isSuccess in
                    self.view.alpha = 1
                }
                
            }
        } failure: { error in
            _progressBar.hideProgressBar(uiView: self.view)
            self.view.alpha = 0.5
            self.showThemeAlertVC(type: .common(msg: error.localizedDescription)) { isSuccess in
                self.view.alpha = 1
            }
           // self.showAlert(errorMessage: error.localizedDescription )
        }
    }
    
    func countryNamesByCode() -> [CountryNew] {
        var countries = [CountryNew]()
        let frameworkBundle = Bundle(for: type(of: self))
        guard let jsonPath = frameworkBundle.path(forResource: "CountryPicker.bundle/Data/countryCodes", ofType: "json"), let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
            return countries
        }
        
        do {
            if let jsonObjects = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? NSArray {
                
                for jsonObject in jsonObjects {
                    
                    guard let countryObj = jsonObject as? NSDictionary else {
                        return countries
                    }
                    
                    guard let code = countryObj["code"] as? String, let phoneCode = countryObj["dial_code"] as? String, let name = countryObj["name"] as? String else {
                        return countries
                    }
                    
                    let country = CountryNew(code: code, name: name, phoneCode: phoneCode)
                    countries.append(country)
                }
                
            }
        } catch {
            return countries
        }
        return countries
    }
    
    func countryPhoneCode(_ picker: CountryCodePickerViewController, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        self.btnCountryCode.setTitle(phoneCode, for: .normal)
        picker.dismiss(animated: true) {
            
        }
    }
}
extension SignUpViewController:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return true
    }
}
extension SignUpViewController: ThemeFloatingTextFieldDelegates{
    func textFieldDidBeginEditing(_ withView: ThemeFloatingTextField) {
        
    }
    
    func textFieldShouldReturn(_ withView: ThemeFloatingTextField) -> Bool {
        let arr = [vwFirstName,vwLastName,vwPassword,vwConfirmPassword,vwEmail,vwPostCode,vwPhone,vwDOB,vwReferalCode]
        if arr.last != withView{
            if let index = arr.firstIndex(of: withView){
                arr[index+1]?.makeResponder()
            }
        }
        return true
    }
}


