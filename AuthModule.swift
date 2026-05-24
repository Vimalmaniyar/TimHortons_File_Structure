//
//  AuthModule.swift
//  TeamHortons
//
//  Created by vimal maniyar on 09/11/22.
//

import UIKit
import Alamofire
import GoogleSignIn


// MARK: - DataClass
struct AppUpdateMaintenance: Codable {
    let currentUpdate: CurrentUpdate?
    let currentMaintenance, nextMaintenance: Maintenance?
    let config:ConfigAppUpdates?

    enum CodingKeys: String, CodingKey {
        case currentUpdate = "current_update"
        case currentMaintenance = "current_maintenance"
        case nextMaintenance = "next_maintenance"
        case config
    }
}
// MARK: - Config

struct ConfigAppUpdates: Codable {
    let WELCOME_BOX: String?
    let DEBUG_BUILD_VERSION: [String]?

    enum CodingKeys: String, CodingKey {
        case WELCOME_BOX
        case DEBUG_BUILD_VERSION
    }
}
// MARK: - Maintenance
struct Maintenance: Codable {
    let notes, startTimestamp, endTimestamp: String?

    enum CodingKeys: String, CodingKey {
        case notes
        case startTimestamp = "start_timestamp"
        case endTimestamp = "end_timestamp"
    }
}

// MARK: - CurrentUpdate
struct CurrentUpdate: Codable {
    let forcefullyUpdate: Bool?
    let releaseNotes, appVersion: String?

    enum CodingKeys: String, CodingKey {
        case forcefullyUpdate = "forcefully_update"
        case releaseNotes = "release_notes"
        case appVersion = "app_version"
    }
}



struct ProfileUser:Codable{
    let firstName, lastName, email,phone, dob: String?
    let signup_from:String?
    let password_set:Bool
        let postcode: String?
        let referalCode: String?
    let countryCode: String?
        enum CodingKeys: String, CodingKey {
            case firstName = "first_name"
            case lastName = "last_name"
            case email, dob, postcode,phone,signup_from,password_set
            case referalCode = "referal_code"
            case countryCode = "country_code"
        }
}
struct ChangePasswordAPI:Codable{
    let current_password,new_password:String
}



final class AuthModule{
    class func callAppUpdateMaintenanceAPI(completion:((AppUpdateMaintenance?,Error?)->())?){
        WebServicesManager().callAPI(url: .check_app_update, method: .get, params: nil, setAuthToken: true, responseType: AppUpdateMaintenance.self,  headerType: .sourceAppPassportDevicePassport) { (obj,error) in
            completion?(obj,error)
        }
    }
    
    
    class func getHeaderForAuth()-> HTTPHeaders? {
        var header : HTTPHeaders?
        header = [HTTPHeader(name: Global.kAuthHeaderKeys.ContentType, value: Global.kAuthHeaderKeys.ContentTypeValue), HTTPHeader(name: Global.kAuthHeaderKeys.source, value: Global.kDeviceType), HTTPHeader(name: Global.kAuthHeaderKeys.devicePassoport, value: Global.singleton.retriveFromUserDefaults(key: UserDefaultKeys.devicePassoport.rawValue) ?? "")]
        return header
    }
    class func getHeaderForAuthForAppPassport()-> HTTPHeaders? {
        var header : HTTPHeaders?
        header = [HTTPHeader(name: Global.kAuthHeaderKeys.ContentType, value: Global.kAuthHeaderKeys.ContentTypeValue), HTTPHeader(name: Global.kAuthHeaderKeys.source, value: Global.kDeviceType), HTTPHeader(name: Global.kAuthHeaderKeys.appPassport, value: Global.singleton.retriveFromUserDefaults(key: UserDefaultKeys.appPassport.rawValue) ?? "")]
        return header
    }
    class func getHeaderForAuthWithAccessToken()-> HTTPHeaders? {
        var header : HTTPHeaders?
        let authToken = Global.singleton.retriveFromUserDefaults(key: "UserAccessToken") ?? ""
        header = [HTTPHeader(name: Global.kAuthHeaderKeys.ContentType, value: "application/json"), HTTPHeader(name: Global.kAuthHeaderKeys.source, value: Global.kDeviceType), HTTPHeader(name: Global.kAuthHeaderKeys.devicePassoport, value: Global.singleton.retriveFromUserDefaults(key: UserDefaultKeys.devicePassoport.rawValue) ?? ""), .authorization(authToken)]
        return header
    }
    class func socialSignIn(params:SocialSignInParams,loginType:String,success:((APIResponse)->())?,failure:((Error)->())?){
        guard let data = try? JSONEncoder().encode(params) else {
            return
        }
        
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else { return  }
        var header : HTTPHeaders?
        header = [ HTTPHeader(name: Global.kAuthHeaderKeys.source, value: Global.kDeviceType), HTTPHeader(name: Global.kAuthHeaderKeys.appPassport, value: Global.singleton.retriveFromUserDefaults(key: UserDefaultKeys.appPassport.rawValue) ?? ""), HTTPHeader(name: Global.kAuthHeaderKeys.devicePassoport, value: Global.singleton.retriveFromUserDefaults(key: UserDefaultKeys.devicePassoport.rawValue) ?? "")]
        print(loginType)
     //   "\(Global.baseURLPath)auth/customer/signin/social/\(loginType)"
        WebServicesManager.requestPOSTURL(strURL: .signIn_social(signInType: loginType), params: json, headers: header) { successData in
            print(successData)
            Global.Consatnts.currentUserAuthData = successData.data
            success?(successData)
        } failure: { error in
            print(error.localizedDescription)
            failure?(error)
        }
    }
    class func handleSocialSignUp(params:SocialSignInParams,loginType:String,success:((APIResponse)->())?,userNotExist: ( ()->())?  ,failure:((Error)->())?){
        let json = ["email":params.email]
        var header : HTTPHeaders?
        header = [ HTTPHeader(name: Global.kAuthHeaderKeys.source, value: Global.kDeviceType), HTTPHeader(name: Global.kAuthHeaderKeys.appPassport, value: Global.singleton.retriveFromUserDefaults(key: UserDefaultKeys.appPassport.rawValue) ?? ""), HTTPHeader(name: Global.kAuthHeaderKeys.devicePassoport, value: Global.singleton.retriveFromUserDefaults(key: UserDefaultKeys.devicePassoport.rawValue) ?? "")]

        
        //"\(Global.baseURLPath)auth/customer/check-account"
        WebServicesManager.requestPOSTURL(strURL: .check_account, params: json, headers: header) { successData in
            print(successData)
            
            userNotExist?()
            
        } failure: { error in
            print(error.localizedDescription)
            if error.localizedDescription == "Account exist"{
                AuthModule.socialSignIn(params: params, loginType: loginType) { successData in
                    success?(successData)
                } failure: { error in
                    failure?(error)
                }
                
            }else{
                failure?(error)
            }
        }
    }

    
    class func callProfileDataAPI(completion:((ProfileUser?,Error?)->())?){
        WebServicesManager().callAPI(url: .profile_customer, method: .get, params: nil, setAuthToken: true, responseType: ProfileUser.self,  headerType: .sourceAppPassportDevicePassportAuthorization) { (obj,error) in
            completion?(obj,error)
        }
    }
    class func callDeleteProfileDataAPI(completion:((Error?)->())?){
        WebServicesManager().callCommonResponseAPI(url: .profile_customer, method: .delete, params: nil, setAuthToken: true, headerType: .sourceAppPassportDevicePassportAuthorization) { Error in
            if let error = Error{
                completion?(error)
            }else{
                Global.singleton.saveToUserDefaults(value: "", forKey: "UserAccessToken")
                Global.setLoginAsRoot()
                GIDSignIn.sharedInstance.signOut()
                Global.Consatnts.currentUserAuthData = nil
            }
        }
    }
    class func callLogoutAPI(completion:((Error?)->())?){
        let param = ["refreshToken":Global.Consatnts.currentUserAuthData?.refreshToken ?? "", "userId":Global.Consatnts.currentUserAuthData?.userID ?? ""] as [String : Any]
        //"fromAll" : true
        WebServicesManager().callCommonResponseAPI(url: .logout_customer, method: .post, params: param, setAuthToken: true, headerType: .sourceAppPassportDevicePassportAuthorization) { Error in
            
            
            Global.setLoginAsRoot()
            
            
            
            if let error = Error{
                completion?(error)
            }else{
                completion?(nil)
//                Global.singleton.saveToUserDefaults(value: "", forKey: UserDefaultKeys.userAccessToken)
//                Global.singleton.saveToUserDefaults(value: "", forKey: UserDefaultKeys.devicePassoport)
//                Global.singleton.saveToUserDefaults(value: "", forKey: UserDefaultKeys.appPassport)
//                Global.singleton.saveToUserDefaults(value: "", forKey: UserDefaultKeys.userId)
//                Global.singleton.saveToUserDefaults(value: "", forKey: UserDefaultKeys.refreshToken)
//
//                Global.setLoginAsRoot()
//                GIDSignIn.sharedInstance.signOut()
//                Global.Consatnts.currentUserAuthData = nil
//                delete_from_userdefault(key: UserDefaultKeys.currentUser)
//
//                Tbl_Cart.deleteData(context: _coreDataShared.getContext()) { isSuccess in
//                    if isSuccess {
//                        print("All cart data deleted")
//                    }
//                }
            }
        }
        
    }
    class func callUpdateProfileAPI(profileData: ProfileUser,completion:((Error?)->())?){
        let param = ["first_name": profileData.firstName!,"last_name":profileData.lastName!,"dob":profileData.dob!,"postcode":profileData.postcode!,"phone":(profileData.phone!), "country_code":(profileData.countryCode ?? "")] as [String : Any]
        WebServicesManager().callCommonResponseAPI(url: .profile_customer, method: .put, params: param, setAuthToken: true, headerType: .sourceAppPassportDevicePassportAuthorization) { Error in
            if let error = Error{
                completion?(error)
            }else{
                AuthModule.callProfileDataAPI { profile, error in
                    if error != nil{
                        completion?(nil)
                        return
                    }
                    let encoder = JSONEncoder()
                    // Encode user
                    let data = try! encoder.encode(profile)
                    // Write/Set Data
                    store_in_userdefault(value: data, key: .userProfileDetail)
                    completion?(nil)
                }
            }
        }
    }
    class func callChangePasswordAPI(profileData: ChangePasswordAPI,completion:((Error?,CommonResponse?)->())?){
        let param = ["current_password": profileData.current_password,"new_password":profileData.new_password] as [String : Any]
        
        WebServicesManager().callAPI(url: .change_password, method: .post, params: param, setAuthToken: true, responseType: CommonResponse.self,  headerType: .sourceAppPassportDevicePassportAuthorization) { (obj,error) in
            
            if  error == nil {
                AuthModule.callProfileDataAPI { profile, error in
                    if error != nil{
                     
                        return
                    }
                    let encoder = JSONEncoder()
                    // Encode user
                    let data = try! encoder.encode(profile)
                    // Write/Set Data
                    store_in_userdefault(value: data, key: .userProfileDetail)
                   
                }
                completion?(nil, obj)
            }else{
                completion?(error, nil)
            }
        }
//
        /*
        WebServicesManager().callCommonResponseAPI(url: "\(Global.baseURLPath)auth-secure/profile/customer/change-password", method: .post, params: param, setAuthToken: true, headerType: .sourceAppPassportDevicePassportAuthorization) { Error in
            if let error = Error{
                completion?(error)
            }else{
                AuthModule.callProfileDataAPI { profile, error in
                    if error != nil{
                        completion?(nil)
                        return
                    }
                    let encoder = JSONEncoder()
                    // Encode user
                    let data = try! encoder.encode(profile)
                    // Write/Set Data
                    store_in_userdefault(value: data, key: .userProfileDetail)
                    completion?(nil)
                }
            }
        }*/
    }
    class func callGetOrderQRCode(completion:((GetQRCodeModel?,Error?)->())?){
        WebServicesManager().callAPI(url: .customer_code, method: .get, params: nil, setAuthToken: true, responseType: GetQRCodeModel.self,  headerType: .sourceAppPassportDevicePassportAuthorization) { (obj,error) in
            completion?(obj,error)
        }
    }
    
    class func callAppPassport(completion:((AppPassport?,Error?)->())?){
        
        WebServicesManager().callAPI(url: .app_passport, method: .post, params: nil, setAuthToken: false,  responseType: AppPassport.self ,  headerType: .getAppPassport) { (obj,error) in
            completion?(obj,error)
        }
    }
    
    class func callDeviceRegister(params:[String:Any], completion:((DeviceRegisterResponse?, Error?)->())?){
        WebServicesManager().callAPI(url: .device_register, method: .post, params: params, setAuthToken: false, responseType: DeviceRegisterResponse.self,  headerType: .registerCustomerDevice) { (obj,error) in
            completion?(obj,error)
        }
    }
    
    class func callUpdateDeviceRegister(params:[String:Any], completion:((Error?)->())?){
        WebServicesManager().callCommonResponseAPI(url: .update_device, method: .put, params: params, setAuthToken: false, headerType: .updateCustomerDevice) { err in
            completion?(err)
        }
    }
    
    class func callGetNewAccessToken(completion:((CustomerRefreshToken?, Error?)->())?){
        let authToken = Global.singleton.retriveFromUserDefaults(key: "UserAccessToken") ?? ""
        let params = ["accessToken":authToken,"refreshToken":Global.Consatnts.currentUserAuthData?.refreshToken ?? "","userId":Global.singleton.retriveFromUserDefaults(key: UserDefaultKeys.userId.rawValue) ?? ""]
        WebServicesManager().callAPI(url: .refresh_token, method: .post, params: params as Parameters, setAuthToken: false, responseType: CustomerRefreshToken.self,  headerType: .sourceAppPassportDevicePassport) { (obj,error) in
            if obj != nil{
                Global.Consatnts.currentUserAuthData?.accessToken = obj!.accessToken
                Global.Consatnts.currentUserAuthData?.expireIn = obj!.expireIn
                Global.Consatnts.currentUserAuthData?.refreshExpireIn = obj!.refreshExpireIn
                Global.singleton.saveToUserDefaults(value:(obj!.accessToken) ?? "" , forKey: UserDefaultKeys.authToken.rawValue)
            }
            completion?(obj,error)
        }
    }
    
    class func callNewActivationLink(params:[String:Any],completion:((CommonResponse?,Error?) -> ())?){
        WebServicesManager().callAPI(url: .send_activation_link, method: .post, params: params, setAuthToken: false, responseType: CommonResponse.self, headerType: .sourceAppPassportDevicePassport) { response, error in
            completion?(response,error)
        }
    }
    class func callGetCommunicationData(completion:((CommunicationData?, Error?)->())?){
        WebServicesManager().callAPI(url: .customer_communication, method: .get, params: nil, setAuthToken: true, responseType: CommunicationData.self,  headerType: .sourceAppPassportDevicePassportAuthorization) { (obj,error) in
            completion?(obj,error)
        }
    }
    class func callUpdateCommunicationData(params:[String:Any],completion:((CommunicationData?, Error?)->())?){
        WebServicesManager().callAPI(url: .customer_communication, method: .post, params: params,encoding: JSONEncoding.default, setAuthToken: true, responseType: CommunicationData.self,  headerType: .sourceAppPassportDevicePassportAuthorization) { (obj,error) in
            completion?(obj,error)
        }
    }
    class func callValidateAccessToken(completion:((Error?)->())?){
        WebServicesManager().callCommonResponseAPI(url: .auth_evaluate_token, method: .get, params: nil, setAuthToken: true, headerType: .sourceAppPassportDevicePassportAuthorization, completion: { err in
            completion?(err)
        })
    }
}


// MARK: - DataClass
struct GetQRCodeModel: Codable {
    var qrImage, code, expires: String?
    var products: Products?
    enum CodingKeys: String, CodingKey {
        case qrImage = "qr_image"
        case code, expires
        case products
    }
}

struct DeviceRegisterResponse: Codable {
    var deviceToken, deviceID, deviceType: String?

    enum CodingKeys: String, CodingKey {
        case deviceToken
        case deviceID = "deviceId"
        case deviceType
    }
}

// MARK: - DataClass
struct AppPassport: Codable {
    var apppassport: String?
}

// MARK: - CommunicationData
struct CommunicationData: Codable {
    let pushSubscription, emailSubscription: Bool?

    enum CodingKeys: String, CodingKey {
        case pushSubscription = "push_subscription"
        case emailSubscription = "email_subscription"
    }
}
