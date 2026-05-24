//
//  ThemeAlertViewController.swift
//  TeamHortons
//
//  Created by vimal maniyar on 01/01/23.
//

import UIKit

enum EnumThemeAlertScreenTypes{

    case chageLocationfromCart,removeItemFromCart,priceChange,deleteAccount,deleteMeal,cancelOrder,browsingMenuAlert, locationAlert, logOutAlert, applePayNotSetup, cardNameValidation, noMenuAvailable, locationIsOff, loginFirst, deleteMessage, somethingWentWrong, paymentFail, deleteFailedOrderData, mandatoryCustomizer, mandatoryDressingDipping, variantMandatory, addToCartWithoutLogin, common(msg:String), checkingDevicetime, openSetting, mandatoryCustomizerWithtitle(title:String, msg:String), appTakingOrderOFStore(msg:NSAttributedString?),loginFirstForCodeScreen,addToMealWithoutLogin,addMoreItems(msg:String),removeLastItemFromOffer
    
    var getSubtitleText:String{
        switch self {
        case .locationAlert:
            return "Please Select Restaurant First"
        case .chageLocationfromCart:
            return "The prices of some items in the checkout may differ if you change your restaurant location. Check prices before you finish ordering."
        case .removeItemFromCart:
            return "Do you want to remove this item from your order?"
        case .priceChange:
            return "Prices have been revised"
        case .deleteAccount:
            return "Are you sure you want to delete your account? This action cannot be undone and all of your data and account information will be permanently deleted."
        case .deleteMeal:
            return  "Are you sure want to cancel the order?"
        case .cancelOrder:
            return "Do you want to Cancel Order?"
        case .browsingMenuAlert:
            return "Unfortunately, we are not serving this item at this time, please browse menu"
        case .logOutAlert:
            return "Are you sure you want to Logout?"
        case .applePayNotSetup:
            return "Your ApplePay setup is not proper, could you please try with another card in ApplePay?"
        case .cardNameValidation:
            return "Please enter card holder name"
        case .noMenuAvailable:
            return "No menu available for this restaurant, please change the restaurant"
        case .locationIsOff:
            return "Please ON your location from phone settings"
        case .loginFirst:
            return "Please login to use features"
        case .deleteMessage:
            return "Do you want to remove this item from Code?"
        case .somethingWentWrong:
            return "Something went wrong!"
        case .paymentFail:
            return "We are sorry, but your payment has not been successful. Please try again or use a different payment method"
        
        case .deleteFailedOrderData:
            return "If you confirm, the order data will be cleared"
        case .mandatoryCustomizer:
            return "You have missed customisation, select to proceed!"
        case .mandatoryDressingDipping:
            return "You have missed customisation, select to proceed!" // THIS MSG WILL CHANGE
        case .variantMandatory:
            return "Please select one of the variants to proceed"
        case .addToCartWithoutLogin:
            return "If you want to add an item to cart, please login or register first"
        case .common(let msg):
            return msg
        case .checkingDevicetime:
            return "Something went wrong while checking device time"
        case .openSetting:
            return "We could’t pick up your location. Please turn on location services to proceed."
        case .mandatoryCustomizerWithtitle(let title, let msg):
            return msg
        case .appTakingOrderOFStore:
            return ""
        case .loginFirstForCodeScreen:
            return "To view code screen please login first"
        case .addToMealWithoutLogin:
            return "If you want to make it meal, please login or register first"
        case .addMoreItems(let msg):
            return msg
        case .removeLastItemFromOffer:
            return "Are you sure you want to remove this last item, if you remove then you have to select items again for continuing with offer.."
        }
    }
    
    var getTitleText:String{
        switch self {
        case .locationAlert:
            return ""
        case .chageLocationfromCart:
            return ""
        case .removeItemFromCart:
            return "Remove Item"
        case .priceChange:
            return ""
        case .deleteAccount:
            return "Delete Account?"
        case .deleteMeal,  .deleteMessage:
            return "Are you sure?"
        case .cancelOrder:
            return "Cancel Order"
        case .browsingMenuAlert:
            return "You can't order this now."
        case .logOutAlert:
            return ""
        case .applePayNotSetup, .cardNameValidation:
            return ""
        case .noMenuAvailable:
            return ""
        case .locationIsOff:
            return ""
        case .loginFirst,.loginFirstForCodeScreen:
            return ""
        case .somethingWentWrong:
            return Global.kAppName
        case .paymentFail:
            return Global.kAppName
        case .deleteFailedOrderData:
            return "Are you sure you want to close the order?"
        case .mandatoryCustomizer, .variantMandatory:
            return Global.kAppName
        case .mandatoryDressingDipping:
            return "Please select Sauce"
        case .addToCartWithoutLogin, .addToMealWithoutLogin:
            return Global.kAppName
        case .common(_):
            return Global.kAppName
        case .checkingDevicetime:
            return Global.kAppName
        case .openSetting:
            return ""
        case .mandatoryCustomizerWithtitle(let title, let msg):
            return "Please Select \(title)"
        case .appTakingOrderOFStore:
            return ""
        case .addMoreItems(msg: let msg):
            return ""
        case .removeLastItemFromOffer:
            return ""
        }
    }
    var isShowTitle:Bool{
       return !getTitleText.isEmpty 
    }
    var isShowImage:Bool{
        switch self {
        case .locationAlert:
            return false
        case .chageLocationfromCart,.browsingMenuAlert:
            return false
        case .removeItemFromCart:
            return true
        case .priceChange:
            return false
        case .deleteAccount,.deleteMeal,   .deleteMessage:
            return false
        case .cancelOrder:
            return true
        case .logOutAlert:
            return false
        case .applePayNotSetup, .cardNameValidation:
            return false
        case .noMenuAvailable:
            return false
        case .locationIsOff:
            return false
        case .loginFirst,.loginFirstForCodeScreen:
            return false

        case .somethingWentWrong:
            return false
        case .paymentFail:
            return false

        case .deleteFailedOrderData:
            return false
        case .mandatoryCustomizer, .variantMandatory :
            return false
        case .mandatoryDressingDipping:
            return false
        case .addToCartWithoutLogin,.addToMealWithoutLogin:
            return false
        case .common(_):
            return false
        case .checkingDevicetime:
            return false
        case .openSetting:
            return false
        case .mandatoryCustomizerWithtitle(let title, let msg):
            return false

        case .appTakingOrderOFStore:
            return true
        case .addMoreItems(msg: let msg):
            return false
        case .removeLastItemFromOffer:
            return false
        }
    }
    var titleTextColor:UIColor{
        switch self {
        case .locationAlert, .cardNameValidation:
            return ThemeColors.gray.getColor
        case .chageLocationfromCart:
            return ThemeColors.gray.getColor
        case .removeItemFromCart,.browsingMenuAlert:
            return ThemeColors.red.getColor
        case .priceChange,.deleteMeal:
            return ThemeColors.gray.getColor
        case .deleteAccount:
            return ThemeColors.red.getColor
        case .cancelOrder:
            return ThemeColors.red.getColor
        case .logOutAlert :
            return ThemeColors.red.getColor
        case .applePayNotSetup:
            return ThemeColors.red.getColor
        case .noMenuAvailable, .locationIsOff:
            return ThemeColors.gray.getColor
        case .loginFirst,.loginFirstForCodeScreen:
            return ThemeColors.gray.getColor
        case   .deleteMessage:
            return ThemeColors.red.getColor
        case .somethingWentWrong:
            return ThemeColors.red.getColor
        case .paymentFail:
            return ThemeColors.red.getColor
        case .deleteFailedOrderData:
            return ThemeColors.red.getColor
        case .mandatoryCustomizer, .mandatoryDressingDipping, .variantMandatory:
            return ThemeColors.red.getColor
        case .addToCartWithoutLogin,.addToMealWithoutLogin:
            return ThemeColors.red.getColor
        case .common(_):
            return ThemeColors.red.getColor
        case .checkingDevicetime:
            return ThemeColors.red.getColor
        case .openSetting:
            return ThemeColors.red.getColor
        case .mandatoryCustomizerWithtitle(let title, let msg):
            return ThemeColors.red.getColor
        case .appTakingOrderOFStore:
            return .black
        case .addMoreItems(msg: let msg):
            return ThemeColors.red.getColor
        case .removeLastItemFromOffer:
            return ThemeColors.red.getColor
        }
    }
    var titleTextAlignment:NSTextAlignment{
        switch self {
        case .locationAlert:
            return .center
        case .chageLocationfromCart,.deleteMeal,.browsingMenuAlert:
            return .left
        case .removeItemFromCart,.cancelOrder:
            return .center
        case .priceChange:
            return .left
        case .deleteAccount:
            return .left
        case .logOutAlert:
            return .center
        case .applePayNotSetup, .cardNameValidation:
            return .center
        case .noMenuAvailable, .locationIsOff:
            return .center
        case .loginFirst,.loginFirstForCodeScreen:
            return .center
        case   .deleteMessage:
            return .left
        case .somethingWentWrong:
            return .center
        case .paymentFail:
            return .center
        case .deleteFailedOrderData:
            return .center
        case .mandatoryCustomizer, .variantMandatory :
            return .center
        case .mandatoryDressingDipping:
            return .center
        case .addToCartWithoutLogin,.addToMealWithoutLogin:
            return .center
        case .common(_):
            return .center
        case .checkingDevicetime:
            return .center
        case .openSetting:
            return .center
        case .mandatoryCustomizerWithtitle(let title, let msg):
            return .center
        case .appTakingOrderOFStore:
            return .left
        case .addMoreItems(msg: let msg):
            return .center
        case .removeLastItemFromOffer:
            return .center
        }
    }
    var subTitleTextAlignment:NSTextAlignment{
        switch self {
        case .locationAlert,.cardNameValidation:
            return .center
        case .chageLocationfromCart,.deleteMeal,.browsingMenuAlert:
            return .left
        case .removeItemFromCart,.cancelOrder:
            return .center
        case .priceChange:
            return .left
        case .deleteAccount:
            return .left
        case .logOutAlert:
            return .center
        case .applePayNotSetup:
            return .center
        case .noMenuAvailable, .locationIsOff:
            return .center
        case .loginFirst,.loginFirstForCodeScreen:
            return .center
        case .deleteMessage:
            return .left
        case .somethingWentWrong:
            return .center
        case .paymentFail:
            return .center
        case .deleteFailedOrderData:
            return .center
        case .mandatoryCustomizer, .variantMandatory:
            return .center
        case .mandatoryDressingDipping:
            return .center
        case .addToCartWithoutLogin,.addToMealWithoutLogin:
            return .center
        case .common(_):
            return .center
        case .checkingDevicetime:
            return .center
        case .openSetting:
            return .center
        case .mandatoryCustomizerWithtitle(let title, let msg):
            return .center
        case .appTakingOrderOFStore:
            return .left
        case .addMoreItems(msg: let msg):
            return .center
        case .removeLastItemFromOffer:
            return .center
        }
    }
    var btnDoneTitle:String{
        switch self {
        case .locationAlert, .cardNameValidation:
            return "Ok"
        case .chageLocationfromCart:
            return "Change Location"
        case .removeItemFromCart:
            return "Cancel"
        case .priceChange,.browsingMenuAlert:
            return "Ok"
        case .deleteAccount:
            return "Cancel"
        case .deleteMeal,.cancelOrder,.deleteFailedOrderData:
            return "No"
        case .logOutAlert:
            return "Cancel"
        case .applePayNotSetup:
            return "Ok"
        case .noMenuAvailable, .locationIsOff:
            return "Ok"
        case .loginFirst,.loginFirstForCodeScreen:
            return "Ok"
        case .deleteMessage:
            return "Cancel"
        case .somethingWentWrong:
            return "Ok"
        case .paymentFail:
            return "Ok"
        case .mandatoryCustomizer, .variantMandatory:
            return "Ok"
        case .mandatoryDressingDipping:
            return "Select Sauce"
        case .addToCartWithoutLogin,.addToMealWithoutLogin:
            return "Ok"
        case .common(_):
            return "Ok"
        case .checkingDevicetime:
            return "Ok"
        case .openSetting:
            return "Open Setting"
        case .mandatoryCustomizerWithtitle(let title, _):
            return "Select \(title)"
        case .appTakingOrderOFStore:
            return "Ok"
        case .addMoreItems(msg: let msg):
            return "Add More"
        case .removeLastItemFromOffer:
            return "Cancel"
        }
    }
    var btnCancelTitle:String{
        switch self {
        case .locationAlert:
            return ""
        case .chageLocationfromCart:
            return "Cancel"
        case .removeItemFromCart:
            return "Confirm"
        case .priceChange,.browsingMenuAlert:
            return ""
        case .deleteAccount:
            return "Delete"
        case .deleteMeal,.cancelOrder,.deleteFailedOrderData:
            return "Yes"
        case .logOutAlert:
            return "Logout"
        case .applePayNotSetup, .cardNameValidation:
            return ""
        case .noMenuAvailable,  .locationIsOff:
            return ""
        case .loginFirst,.loginFirstForCodeScreen:
            return ""
        case .deleteMessage:
            return "Remove"
        case .somethingWentWrong:
            return ""
        case .paymentFail:
            return ""
        case .mandatoryCustomizer, .mandatoryDressingDipping, .variantMandatory:
            return ""
        case .addToCartWithoutLogin,.addToMealWithoutLogin:
            return ""
        case .common(_):
            return ""
        case .checkingDevicetime:
            return ""
        case .openSetting:
            return ""
        case .mandatoryCustomizerWithtitle(_, _):
            return ""
        case .appTakingOrderOFStore:
            return ""
        case .addMoreItems(let msg):
            return "No Thanks"
        case .removeLastItemFromOffer:
            return "Yes"
        }
    }
}

class ThemeAlertViewController: UIViewController {
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblSubTitle:UILabel!
    @IBOutlet weak var vwBG:UIView!
    
    @IBOutlet weak var vwImg:UIView!
    
    @IBOutlet weak var btnCancel:UIButton!
    @IBOutlet weak var btnDone:UIButton!
    
    //MARK: - Variables
    
    var completion:((Bool)->())?
    
    var screenType: EnumThemeAlertScreenTypes = .chageLocationfromCart
    //MARK: - IBActions
    
    @IBAction func btnCancelTapped(_ sender:UIButton?) {
        switch screenType {
        case .chageLocationfromCart,.priceChange,.browsingMenuAlert, .applePayNotSetup:
            completion?(false)
        case .removeItemFromCart,.deleteAccount,.deleteMeal,.cancelOrder,.deleteFailedOrderData:
            completion?(true) // DONE TAP
        case .locationAlert:
            completion?(false)
        case .logOutAlert, .cardNameValidation:
            completion?(true)
        case .noMenuAvailable:
            completion?(false)
        case .locationIsOff:
            completion?(false)
        case .loginFirst,.loginFirstForCodeScreen:
            completion?(false)
        case .deleteMessage:
            completion?(true)
        case .somethingWentWrong:
             completion?(false)
        case .paymentFail:
             completion?(false)
        case .mandatoryCustomizer, .mandatoryDressingDipping, .variantMandatory:
            completion?(false)
        case .addToCartWithoutLogin,.addToMealWithoutLogin:
            completion?(false)
        case .common(_):
            completion?(false)
        case .checkingDevicetime,.appTakingOrderOFStore:
             completion?(false)
        case .openSetting:
            completion?(false)
        case .mandatoryCustomizerWithtitle(let title, let msg):
            completion?(false)
            
        case .addMoreItems(msg: let msg):
            completion?(false)
        case .removeLastItemFromOffer:
            completion?(true)
        }
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnDoneTapped(_ sender:UIButton?){
        switch screenType {
        case .chageLocationfromCart,.priceChange,.browsingMenuAlert:
            completion?(true)
        case .removeItemFromCart,.deleteAccount,.deleteMeal,.cancelOrder,.deleteFailedOrderData,.removeLastItemFromOffer:
            completion?(false) // CANCEL TAP
        case .locationAlert:
            completion?(true)
        case .logOutAlert:
            completion?(false)
        case .applePayNotSetup, .cardNameValidation:
            completion?(true)
        case .noMenuAvailable:
            completion?(true)
        case .locationIsOff:
            completion?(true)
        case .loginFirst,.loginFirstForCodeScreen:
            completion?(false)
        case .deleteMessage:
            completion?(false)
        case .somethingWentWrong:
             completion?(true)
        case .paymentFail:
             completion?(true)
        case .mandatoryCustomizer, .mandatoryDressingDipping, .variantMandatory:
            completion?(true)
        case .addToCartWithoutLogin,.addToMealWithoutLogin:
            completion?(true)
        case .common(_):
            completion?(true)
        case .checkingDevicetime,.appTakingOrderOFStore:
             completion?(true)
        case .openSetting:
            completion?(true)
        case .mandatoryCustomizerWithtitle(let title, let msg):
            completion?(true)
        case .addMoreItems(msg: let msg):
            completion?(true)
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUI()
    }
    private func setUI(){
        lblTitle.text = screenType.getTitleText
        lblSubTitle.text = screenType.getSubtitleText
        
        lblTitle.isHidden = !screenType.isShowTitle
        vwImg.isHidden = !screenType.isShowImage
        
        lblTitle.textColor = screenType.titleTextColor
        lblTitle.textAlignment = screenType.titleTextAlignment
        lblSubTitle.textAlignment = screenType.subTitleTextAlignment
        
        lblTitle.numberOfLines = 0
        
        btnDone.setTitle(screenType.btnDoneTitle, for: .normal)
        btnDone.layer.backgroundColor = ThemeColors.red.getColor.cgColor
        btnDone.layer.borderColor =  ThemeColors.red.getColor.cgColor
        self.btnDone.setTitleColor(ThemeColors.white.getColor, for: .normal)

        btnCancel.setTitle(screenType.btnCancelTitle, for: .normal)
        btnCancel.isHidden = screenType.btnCancelTitle.isEmpty
        
        switch screenType {
        case .browsingMenuAlert:
            MenuModule().getCurrentMenu() { MenuData in
                if let menuData = MenuData{
                    self.lblSubTitle.text = "Unfortunately, we are not serving this item at this time, please browse \(menuData.name ?? "")\((menuData.name ?? "").lowercased().contains("menu") ? "" :  " menu")."
                }
            }
            break
        case .common(let msg):
            lblSubTitle.text = msg
            break
        case .addMoreItems(let msg):
            lblSubTitle.text = msg
            break
        case .appTakingOrderOFStore(let msg):
            lblSubTitle.attributedText = msg
            break
        case .appTakingOrderOFStore:
            lblTitle.font = UIFont().getSofiaProMediumFont(16)
            lblSubTitle.font = lblTitle.font
        default:
            break
        }
    }

}
