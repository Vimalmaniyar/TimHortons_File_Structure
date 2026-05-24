//
//  LoginViewController.swift
//  TeamHortons
//
//  Created by vimal maniyar on 04/11/22.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import AuthenticationServices

enum EnumLoginSocialType:String{
    case google = "google"
    case facebook = "facebook"
    case apple = "apple"
    case normal = "normal" // NONE CASE
}

enum loginTypeEnum {
    case fromLogin
    case fromDeails
}

class LoginViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnLogin:UIButton!
    @IBOutlet weak var btnSignUp:UIButton!
    @IBOutlet weak var btnForgotPassword:UIButton!
    
    @IBOutlet weak var btnSignInApple:UIButton!
    @IBOutlet weak var btnSignInFacebook:UIButton!
    @IBOutlet weak var btnSignInGoogle:UIButton!
    
    @IBOutlet weak var vwUserName:ThemeFloatingTextField!
    @IBOutlet weak var vwPassword:ThemeFloatingTextField!
    @IBOutlet weak var loginErrorDescriptionLabel: UILabel!
    @IBOutlet weak var lblBuild:UILabel!
    // MARK: - Variables
    private let signInConfig = GIDConfiguration(clientID: Global.SDKKeys.GoogleLogin.ClientId)
    // MARK: - Stored Properties
        var loginViewModel: LoginViewModel!
    var loginType : loginTypeEnum = .fromLogin
    var logoTapCount = 0
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        var str = ""
        
        let forgotPass = NSMutableAttributedString(string:  "Forgot Password?")
        forgotPass.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: "Forgot Password?".count))
        forgotPass.addAttribute(.font, value: UIFont(name: Font.SofiaProRegular, size: 16)!, range: NSRange(location: 0, length: "Forgot Password?".count))
        
        let txtReset = NSMutableAttributedString(string:  " Reset")
        txtReset.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: " Reset".count))
        txtReset.addAttribute(.font, value: UIFont(name: Font.SofiaProBold, size: 16)!, range: NSRange(location: 0, length: " Reset".count))
        
        forgotPass.append(txtReset)
        
        btnForgotPassword.setAttributedTitle(forgotPass, for: .normal)
        
//        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
//              str += "Version: \(version) "
//        }
        if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
              str += "Build: \(build)"
        }

        lblBuild.text = str
        setFloatingTextFields()
        loginViewModel = LoginViewModel()
        // Do any additional setup after loading the view.
        btnSignUp.isSelected = true
        btnSignUp.backgroundColor = .white
        bindData()
//        let button = UIButton(type: .roundedRect)
//             button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
//             button.setTitle("Test Crash", for: [])
//             button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
//             view.addSubview(button)
        
    }
    

     @IBAction func crashButtonTapped(_ sender: AnyObject) {
         let numbers = [0]
         let _ = numbers[1]
     }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        //self.navigationController?.navigationBar.backgroundColor = .clear
        self.vwUserName.text = "" // "samirmagnates@gmail.com"
        self.vwPassword.text = "" //123456"
        if Global.singleton.retriveFromUserDefaults(key: UserDefaultKeys.appPassport.rawValue) == "" {
            Global.appDelegate.getAppPassport {
                
            }
        }
        
        if Global.singleton.retriveFromUserDefaults(key: UserDefaultKeys.isSkippLogin.rawValue) ?? ""  == "1"{
            self.btnSkip.isHidden = true
        }
        else {
            self.btnSkip.isHidden = false
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func btnSkipClick(_ sender: Any) {
        Global.setHomeAsRoot()
        delete_from_userdefault(key: .authToken)
    }
    
    @IBAction private func btnLogoTapped(_ sneder:UIButton){
        logoTapCount += 1
        if logoTapCount >= 3{
            showChangeBaseUrlAlert()
            logoTapCount = 0
        }
    }
    
    @IBAction private func btnLoginTapped(_ sender:UIButton?){
        //self.btnLogin.backgroundColor  = .white
        //self.btnSignUp.backgroundColor = .clear
        //self.btnLogin.isSelected  = true
       // self.btnSignUp.isSelected = false
        loginViewModel.updateCredentials(email: self.vwUserName.text!, password: self.vwPassword.text!)
        
        //Here we check user's credentials input - if it's correct we call login()
        switch loginViewModel.credentialsInput() {
        case .Correct:
            login()
        case .Incorrect:
            //Display Error Message
            return
        }
    }
    
    @IBAction private func btnSignUpTapped(_ sender:UIButton?){
        //self.btnLogin.backgroundColor = .clear
        self.btnSignUp.backgroundColor = .white
       // self.btnLogin.isSelected = false
        self.btnSignUp.isSelected = true
        
        let singnUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        show(singnUpVC, sender: self)
    }
    
    @IBAction private func btnForgotPasswordTapped(_ sender:UIButton?){
        let singnUpVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPwdViewController") as! ForgotPwdViewController
        show(singnUpVC, sender: self)
    }
    
    @IBAction private func btnSignInWithApple(_ sender:UIButton?){
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    @IBAction private func btnSignInWithFaceBook(_ sender:UIButton?){
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self, handler: { [weak self] result, error in
            guard let self = self else{return}
                    if error != nil {
                        print("ERROR: Trying to get login results")
                        self.showAlert(errorMessage: error?.localizedDescription ?? "")
                    } else if result?.isCancelled != nil {
                        print("The token is \(result?.token?.tokenString ?? "")")
                        if result?.token?.tokenString != nil {
                            guard let accessToken = FBSDKLoginKit.AccessToken.current else { return }
                            let graphRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                                          parameters: ["fields": "email, name"],
                                                                          tokenString: accessToken.tokenString,
                                                                          version: nil,
                                                                          httpMethod: .get)
                            graphRequest.start { (connection, result, error) -> Void in
                                if error == nil {
                                    if let dict = result as? [String:Any]{
                                       let email =  dict["email"] as! String
                                       let fullName =  dict["name"] as! String
                                        let names:[Substring] = fullName.split(separator: " ")
                                        if !email.isEmpty{
                                            
                                            let param = SocialSignInParams(email: email, first_name: names.count > 0 ? String(names.first!) : nil, last_name: names.count>1 ? String(names.last!) : nil, dob: nil, postCode: nil, phone_no: nil)
                                            self.handleSocialUser(param: param, loginType: EnumLoginSocialType.facebook.rawValue)
                                            
                                        }else if !fullName.isEmpty && email.isEmpty {
                                            self.view.alpha = 0.5
                                            self.showAlertVC(type: .loginEmail) {[weak self] obj in
                                                guard let self = self else{return}
                                                self.view.alpha = 1
                                                self.handleSocialUser(param: obj, loginType: EnumLoginSocialType.facebook.rawValue)
                                
                                            } cancelTap: { [weak self]  in
                                                    guard let self = self else{return}
                                                    self.view.alpha = 1
                                                    loginManager.logOut()
                                                    
                                            }

                                            
                                            
                                        }else {
                                            self.view.alpha = 0.5
                                            self.showAlertVC(type: .loginEmailName) {[weak self] obj in
                                                guard let self = self else{return}
                                                self.view.alpha = 1
                                                self.handleSocialUser(param: obj, loginType: EnumLoginSocialType.facebook.rawValue)
                                
                                            } cancelTap: { [weak self]  in
                                                    guard let self = self else{return}
                                                    self.view.alpha = 1
                                                    loginManager.logOut()
                                                    
                                            }

                                        }
                                    }
                                }
                                else {
                                    print("error \(String(describing: error))")
                                }
                            }
                        } else {
                            print("Cancelled")
                        }
                    }
                })
    }
    
    @IBAction private func btnSignInWithGoogle(_ sender:UIButton?){
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else {
                self.showAlert(errorMessage: "Sign-in with google failed!")
                return
            }
            let signInUser = signInResult?.user
            // If sign in succeeded, display the app's main content View.
            let fullName  = signInUser?.profile?.name
            let firstName = (signInUser?.profile?.givenName) ?? ""
            let lastName  = signInUser?.profile?.familyName
            
            guard let email = signInUser?.profile?.email else{return}
            
            let param = SocialSignInParams(email: email, first_name: firstName.isEmpty == true ? (fullName) : firstName, last_name: firstName.isEmpty == true ? ("") : lastName, dob: nil, postCode: nil, phone_no: nil)
            
            self.handleSocialUser(param: param, loginType: EnumLoginSocialType.google.rawValue)
          }
    }

    //MARK: - Custom Methods
    private func handleSocialUser(param:SocialSignInParams,loginType:String){
        
        _progressBar.showProgressBar(uiView: self.view)
        
        AuthModule.handleSocialSignUp(params: param, loginType: loginType) { [weak self] apiResponse  in
            guard let self = self else{return}
            _progressBar.hideProgressBar(uiView: self.view)
            if apiResponse.success! {
                Global.singleton.saveToUserDefaults(value:(apiResponse.data?.accessToken) ?? "" , forKey: UserDefaultKeys.authToken.rawValue)
                Global.singleton.saveToUserDefaults(value: apiResponse.data?.userID ?? "", forKey: UserDefaultKeys.userId.rawValue)
                Global.singleton.saveToUserDefaults(value: "", forKey: UserDefaultKeys.isSkippLogin.rawValue)
                Global.setHomeAsRoot()
            }
            else {
                self.showAlert(errorMessage: apiResponse.message ?? "")
            }
            
        } userNotExist: { [weak self]  in
            guard let self = self else{return}
            // SHOW T&C
            _progressBar.hideProgressBar(uiView: self.view)
            self.gotoAcceptTerms(socialParams: param, loginType: EnumLoginSocialType(rawValue: loginType) ?? .normal)
            
        } failure: { [weak self] errorApi  in
            guard let self = self else{return}
            self.showAlert(errorMessage: errorApi.localizedDescription)
            _progressBar.hideProgressBar(uiView: self.view)
        }
    }
    fileprivate func setFloatingTextFields(){
        vwUserName.setField(placeholder: "Email*", text: "", textContentType: .emailAddress, isForPassWord: false,textColor: .white, textFieldTextColor: .white, textFont: UIFont().getSofiaProBoldFont(14),sepratorColor: .white)
       
        vwPassword.setField(placeholder: "Password*", text: "", textContentType: .oneTimeCode, isForPassWord: true, textColor: .white, textFieldTextColor: .white, textFont: UIFont().getSofiaProBoldFont(14), maxCharacter: 16,sepratorColor: .white, showRightIcon: true, rightIconNormal: IcoMoonIcons.iconEyeClose, rightIconSelected: IcoMoonIcons.iconEyeOpen, rightIconPixelSize: 15)
        
        vwPassword.rightButtonAction = { [weak self]  in
            self?.vwPassword.btnRightIcon.isSelected = !(self?.vwPassword.btnRightIcon.isSelected)!
            self?.vwPassword.isSecureEntry = !(self?.vwPassword.btnRightIcon.isSelected)!
            
        }
    }
    
    func login() {
       _progressBar.showProgressBar(uiView: self.view)
        loginViewModel.login { [self] apiResponse in
            _progressBar.hideProgressBar(uiView: self.view)
            if apiResponse.success! {
                   // CoreDataManager.sharedInstance.saveLoginUserData(apiResponse: apiResponse) { loginData in
                   // print("Clouser of Logindata Save return token = \(loginData?.accessToken ?? "NODATA")")
                Global.singleton.saveToUserDefaults(value:(apiResponse.data?.accessToken) ?? "" , forKey: UserDefaultKeys.authToken.rawValue)
                Global.singleton.saveToUserDefaults(value: "", forKey: UserDefaultKeys.isSkippLogin.rawValue)
                switch loginType {
                case .fromLogin:
                    Global.setHomeAsRoot()
                case .fromDeails:
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else {
                self.view.alpha = 0.5
                self.showThemeAlertVC(type: .common(msg: apiResponse.message ?? "")) { isSuccess in
                    self.view.alpha = 1
                }
                
            }
           
        } failure: { error in
            self.view.alpha = 0.5
            self.showThemeAlertVC(type: .common(msg: error.localizedDescription)) { isSuccess in
                self.view.alpha = 1
            }
            _progressBar.hideProgressBar(uiView: self.view)
        }
    }
    
    func bindData() {
//        loginViewModel.credentialsInputErrorMessage.bind { [weak self] in
//            self?.loginErrorDescriptionLabel.isHidden = false
//            self?.loginErrorDescriptionLabel.text = $0
//        }

//        loginViewModel.isUsernameTextFieldHighLighted.bind { [weak self] in
//            if $0 { self?.highlightTextField(self!.vwUserName)}
//        }
////
//        loginViewModel.isPasswordTextFieldHighLighted.bind { [weak self] in
//            if $0 { self?.highlightTextField(self!.vwPassword)}
//        }
        
        loginViewModel.errorMessage.bind {
            guard let errorMessage = $0 else { return }
            self.showAlert(errorMessage: errorMessage)
        }
    }
    
    func highlightTextField(_ textField: ThemeFloatingTextField) {
            textField.resignFirstResponder()
    }
    
    private func showChangeBaseUrlAlert(){
        let alert = UIAlertController(title: Global.kAppName, message: "Enter base url which you want to change", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField(configurationHandler: { textField in
            textField.text = Global.defaultDevPath
        })

        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Set Staging URL", style: .default, handler: { alertAction in
            guard let textField =  alert.textFields?.first else {
                        return
            }
            textField.text = Global.defaultStagingPath
            Global.baseURLPath = textField.text ?? Global.defaultStagingPath
            Global.singleton.saveToUserDefaults(value: Global.baseURLPath, forKey: "baseUrl")
            Global.appDelegate.getAppPassport {
               
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Set Development URL", style: .destructive, handler: { alertAction in
            guard let textField =  alert.textFields?.first else {
                return
            }
            textField.text = Global.defaultDevPath
            Global.baseURLPath = Global.defaultDevPath
            
            Global.singleton.saveToUserDefaults(value: Global.baseURLPath, forKey: "baseUrl")
            Global.appDelegate.getAppPassport {
                
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Set Devlopment Environment", style: .default, handler: { alertAction in
            _appEnvironment = .dev
            PaymentConfig.provisionPaymentCredentials()
            Global.singleton.saveToUserDefaults(value: AppEnvironment.dev.rawValue, forKey: UserDefaultKeys.appEnv.rawValue)
        }))
        alert.addAction(UIAlertAction(title: "Set LIVE Environment", style: .destructive, handler: { alertAction in
            _appEnvironment = .live
            PaymentConfig.provisionPaymentCredentials()
            Global.singleton.saveToUserDefaults(value: AppEnvironment.live.rawValue, forKey: UserDefaultKeys.appEnv.rawValue)
        }))

        // 4. Present the alert.
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
}
extension LoginViewController:ASAuthorizationControllerDelegate{
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
       
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            
        let userIdentifier = appleIDCredential.user
        var fullName  = String(describing:  appleIDCredential.fullName)
        var firstName = String(describing:  appleIDCredential.fullName?.givenName ?? "")
        var lastName  = String(describing:  appleIDCredential.fullName?.familyName ?? "")
        var email     = appleIDCredential.email ?? ""
         
        let user: AppleSignInModel = AppleSignInModel(appleIDCredential)
            
            
        if !(user.email ?? "").isEmpty{
            // CHECKING DATA RETRIVED FIRST TIME FROM APPLE
            //store_in_userdefault(value: user, key: .appleSignInUser)
            
            do {
                // Create JSON Encoder
                let encoder = JSONEncoder()
                // Encode user
                let data = try encoder.encode(user)
                // Write/Set Data
                let strAppleUserData = String(data: data, encoding: .utf8)
                KeychainItem.appleSignInUser = strAppleUserData
//                store_in_userdefault(value: data, key: .appleSignInUser)
            } catch {
                self.showAlert(errorMessage: "Unable to Encode apple user : (\(error.localizedDescription))")
            }
        }else{
            if let strAppleUserData = KeychainItem.appleSignInUser,!strAppleUserData.isEmpty{// UserDefaults.standard.data(forKey: UserDefaultKeys.appleSignInUser.rawValue) {
                do {
                    let data = Data(strAppleUserData.utf8)
                    // Create JSON Decoder
                    let decoder = JSONDecoder()
                    // Decode user
                    let appleUser = try decoder.decode(AppleSignInModel.self, from: data)
                   // if let appleUser:AppleSignInModel = read_from_userdefault(key: .appleSignInUser){
                        
                        fullName = appleUser.firstName + appleUser.lastName
                        firstName = appleUser.firstName
                        lastName = appleUser.lastName
                        email = appleUser.email ?? ""
                    //}

                } catch {
                    self.showAlert(errorMessage: "Unable to Decode apple user : (\(error.localizedDescription))")
                }
            }
        }
            
        
        print("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))")
        if !email.isEmpty && !email.lowercased().contains("@privaterelay"){
            //FIRST TIME WHEN I REGISTER WITH APPLE LOGIN
            // WE GET EMAIL, FIRSTNAME AND LASTNAME
            let param = SocialSignInParams(email: email, first_name: firstName, last_name: lastName,dob: nil, postCode: nil,phone_no: nil)
            self.handleSocialUser(param: param, loginType: EnumLoginSocialType.apple.rawValue)
            
        } else if email.lowercased().contains("@privaterelay") && !fullName.isEmpty {
            //privaterelay
            // IF EMAIL IS PRIVATERELAY
            // GET JWT TOKEN AND GET THE EMAIL FROM EMAIL FIELD
            if let string = String(data:appleIDCredential.identityToken ?? Data(), encoding: .utf8) {
                do {
                    let jwt = try decode(jwt: string)
                    let param = SocialSignInParams(email: email, first_name: firstName, last_name: lastName,dob: nil, postCode: nil,phone_no: nil)
                    
                    self.handleSocialUser(param: param, loginType: EnumLoginSocialType.apple.rawValue)
                    if let email = jwt["email"].string {
                        print("Email is \(email)")
                       
                    }
                } catch {
                    //handle error
                    print(error)
                    self.showAlert(errorMessage: "Error in Apple Login") {
                        
                    }
                }
            }
        }else{
            if let string = String(data:appleIDCredential.identityToken ?? Data(), encoding: .utf8) {
                do {
                    let jwt = try decode(jwt: string)
                    
                    if let email = jwt["email"].string {
                        print("Email is \(email)")
                        self.handleSocialUser(param: SocialSignInParams(email: email), loginType: EnumLoginSocialType.apple.rawValue)
                    }
                } catch {
                    //handle error
                    print(error)
                    self.showAlert(errorMessage: "Error in Apple Login") {
                        
                    }
                }
            }
//
//            self.view.alpha = 0.5
//            self.showAlertVC(type: .loginEmail) {[weak self] obj in
//                guard let self = self else{return}
//                self.view.alpha = 1
//                self.handleSocialUser(param: obj, loginType: EnumLoginSocialType.apple.rawValue)
//
//            } cancelTap: { [weak self]  in
//                    guard let self = self else{return}
//                    self.view.alpha = 1
//            }
        }
        
    }
   }
}


// MARK: Model for get apple login user data
public struct AppleSignInModel : Codable {

    public let userIdentifier: String
    public let firstName: String
    public let lastName: String
    public let email: String?
    public let appleId: String?

    public init(userIdentifier: String, firstName: String, lastName: String, email: String?, appleId: String?) {
        self.userIdentifier = userIdentifier
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.appleId = appleId
    }

    public init(userIdentifier: String, firstName: String, lastName: String, email: String?, appleId: Data?) {
        self.userIdentifier = userIdentifier
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        if let appleIdData: Data = appleId, let aToken: String = String(data: appleIdData, encoding: .utf8) {
            self.appleId = aToken
        } else {
            self.appleId = nil
        }
    }

    @available(iOS 13.0, *)
    public init(_ appleIDCredential: ASAuthorizationAppleIDCredential) {
        self.userIdentifier = appleIDCredential.user
        self.firstName = appleIDCredential.fullName?.givenName ?? ""
        self.lastName = appleIDCredential.fullName?.familyName ?? ""
        self.email = appleIDCredential.email ?? ""
        if let tokenData: Data = appleIDCredential.identityToken,
            let aToken: String = String(data: tokenData, encoding: .utf8) {
            self.appleId = aToken

        } else {
            self.appleId = nil
        }
    }
}
