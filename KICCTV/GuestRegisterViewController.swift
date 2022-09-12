//
//  GuestRegisterViewController.swift
//  TVExcel
//
//  Created by Firoze Moosakutty on 20/06/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import UIKit
import Reachability
import Firebase

class GuestRegisterViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var loginTocontinueLabel: UILabel!
    @IBOutlet weak var coutrycodeTextView: UITextField!
    @IBOutlet weak var mobilenumberTextField: UITextField!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    var phoneNumber = String()
    var reachability = Reachability()!
    var c_code = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden =  false
        self.tabBarController?.tabBar.isHidden = true
        mobilenumberTextField.setBottomBorder()
        coutrycodeTextView.setBottomBorder()
        self.contentView.backgroundColor = ThemeManager.currentTheme().backgroundColor
        self.contentView.layer.cornerRadius = 5
        self.contentView.clipsToBounds = true
        self.continueButton.layer.cornerRadius = 5
        self.continueButton.clipsToBounds = true
        self.validationLabel.isHidden = true
        self.continueButton.backgroundColor = ThemeManager.currentTheme().UIImageColor
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        if UserDefaults.standard.string(forKey:"c_code") != nil {
            let countryCallCode = self.getCountryPhonceCode(country: UserDefaults.standard.string(forKey:"countryCode")!)
            coutrycodeTextView.text = countryCallCode
        }
        self.mobilenumberTextField.delegate = self
        mobilenumberTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
      
        // Do any additional setup after loading the view.
    }
    // MARK: ButtonActions
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss()
    }
    
    @IBAction func continueButtonAction(_ sender: Any) {
        mobilenumberTextField.resignFirstResponder()
        if (mobilenumberTextField.text?.isEmpty)! {
            self.mobilenumberTextField.layer.shadowColor = UIColor.red.cgColor
            validationLabel.isHidden = false
            
        } else {
            phoneNumber = coutrycodeTextView.text! + mobilenumberTextField.text!
            //phoneNumber = "+91" + mobilenumberTextField.text!
            UserDefaults.standard.set(phoneNumber, forKey: "phoneNumber")
            c_code = coutrycodeTextView.text!
            if  reachability.connection != .none {
                CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
                PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
                    if let error = error {
                        CustomProgressView.hideActivityIndicator()
                        Application.showAlert(onViewController: self, title: "There was an error \n sending the SMS code", message: error.localizedDescription, actionTitle: "OK", cancelButton: false, handler: nil)
                        return
                    }
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                    CustomProgressView.hideActivityIndicator()
                    OTPverificationViewController.showOTPviewController(viewController: self,isFromRegister : false, userId: "jkjk")
                }
            } else {
                AppHelper.showAppErrorWithOKAction(vc: self, title: "Network connection lost!", message: "", handler: nil)
            }
        }
    }
    public class func showFromGuestUser(viewController : UIViewController) {
        let vc = GuestRegisterViewController()
        vc.modalPresentationStyle = .overCurrentContext
        viewController.present(vc, animated: true, completion: nil)
    }
    // MARK: Main Functions
    func dismiss() {
        UIView.animate(withDuration: 0.15, animations: {
            self.view.backgroundColor=UIColor.clear
        }, completion:{ _ in
            self.dismiss(animated: false, completion: nil)
        })
    }
    func getCountryPhonceCode (country : String) -> String {
        if country.count == 2 {
            var countryDictionary  = ["AF":"93",
                                      "AL":"355",
                                      "DZ":"213",
                                      "AS":"1",
                                      "AD":"376",
                                      "AO":"244",
                                      "AI":"1",
                                      "AG":"1",
                                      "AR":"54",
                                      "AM":"374",
                                      "AW":"297",
                                      "AU":"61",
                                      "AT":"43",
                                      "AZ":"994",
                                      "BS":"1",
                                      "BH":"973",
                                      "BD":"880",
                                      "BB":"1",
                                      "BY":"375",
                                      "BE":"32",
                                      "BZ":"501",
                                      "BJ":"229",
                                      "BM":"1",
                                      "BT":"975",
                                      "BA":"387",
                                      "BW":"267",
                                      "BR":"55",
                                      "IO":"246",
                                      "BG":"359",
                                      "BF":"226",
                                      "BI":"257",
                                      "KH":"855",
                                      "CM":"237",
                                      "CA":"1",
                                      "CV":"238",
                                      "KY":"345",
                                      "CF":"236",
                                      "TD":"235",
                                      "CL":"56",
                                      "CN":"86",
                                      "CX":"61",
                                      "CO":"57",
                                      "KM":"269",
                                      "CG":"242",
                                      "CK":"682",
                                      "CR":"506",
                                      "HR":"385",
                                      "CU":"53",
                                      "CY":"537",
                                      "CZ":"420",
                                      "DK":"45",
                                      "DJ":"253",
                                      "DM":"1",
                                      "DO":"1",
                                      "EC":"593",
                                      "EG":"20",
                                      "SV":"503",
                                      "GQ":"240",
                                      "ER":"291",
                                      "EE":"372",
                                      "ET":"251",
                                      "FO":"298",
                                      "FJ":"679",
                                      "FI":"358",
                                      "FR":"33",
                                      "GF":"594",
                                      "PF":"689",
                                      "GA":"241",
                                      "GM":"220",
                                      "GE":"995",
                                      "DE":"49",
                                      "GH":"233",
                                      "GI":"350",
                                      "GR":"30",
                                      "GL":"299",
                                      "GD":"1",
                                      "GP":"590",
                                      "GU":"1",
                                      "GT":"502",
                                      "GN":"224",
                                      "GW":"245",
                                      "GY":"595",
                                      "HT":"509",
                                      "HN":"504",
                                      "HU":"36",
                                      "IS":"354",
                                      "IN":"91",
                                      "ID":"62",
                                      "IQ":"964",
                                      "IE":"353",
                                      "IL":"972",
                                      "IT":"39",
                                      "JM":"1",
                                      "JP":"81",
                                      "JO":"962",
                                      "KZ":"77",
                                      "KE":"254",
                                      "KI":"686",
                                      "KW":"965",
                                      "KG":"996",
                                      "LV":"371",
                                      "LB":"961",
                                      "LS":"266",
                                      "LR":"231",
                                      "LI":"423",
                                      "LT":"370",
                                      "LU":"352",
                                      "MG":"261",
                                      "MW":"265",
                                      "MY":"60",
                                      "MV":"960",
                                      "ML":"223",
                                      "MT":"356",
                                      "MH":"692",
                                      "MQ":"596",
                                      "MR":"222",
                                      "MU":"230",
                                      "YT":"262",
                                      "MX":"52",
                                      "MC":"377",
                                      "MN":"976",
                                      "ME":"382",
                                      "MS":"1",
                                      "MA":"212",
                                      "MM":"95",
                                      "NA":"264",
                                      "NR":"674",
                                      "NP":"977",
                                      "NL":"31",
                                      "AN":"599",
                                      "NC":"687",
                                      "NZ":"64",
                                      "NI":"505",
                                      "NE":"227",
                                      "NG":"234",
                                      "NU":"683",
                                      "NF":"672",
                                      "MP":"1",
                                      "NO":"47",
                                      "OM":"968",
                                      "PK":"92",
                                      "PW":"680",
                                      "PA":"507",
                                      "PG":"675",
                                      "PY":"595",
                                      "PE":"51",
                                      "PH":"63",
                                      "PL":"48",
                                      "PT":"351",
                                      "PR":"1",
                                      "QA":"974",
                                      "RO":"40",
                                      "RW":"250",
                                      "WS":"685",
                                      "SM":"378",
                                      "SA":"966",
                                      "SN":"221",
                                      "RS":"381",
                                      "SC":"248",
                                      "SL":"232",
                                      "SG":"65",
                                      "SK":"421",
                                      "SI":"386",
                                      "SB":"677",
                                      "ZA":"27",
                                      "GS":"500",
                                      "ES":"34",
                                      "LK":"94",
                                      "SD":"249",
                                      "SR":"597",
                                      "SZ":"268",
                                      "SE":"46",
                                      "CH":"41",
                                      "TJ":"992",
                                      "TH":"66",
                                      "TG":"228",
                                      "TK":"690",
                                      "TO":"676",
                                      "TT":"1",
                                      "TN":"216",
                                      "TR":"90",
                                      "TM":"993",
                                      "TC":"1",
                                      "TV":"688",
                                      "UG":"256",
                                      "UA":"380",
                                      "AE":"971",
                                      "GB":"44",
                                      "US":"1",
                                      "UY":"598",
                                      "UZ":"998",
                                      "VU":"678",
                                      "WF":"681",
                                      "YE":"967",
                                      "ZM":"260",
                                      "ZW":"263",
                                      "BO":"591",
                                      "BN":"673",
                                      "CC":"61",
                                      "CD":"243",
                                      "CI":"225",
                                      "FK":"500",
                                      "GG":"44",
                                      "VA":"379",
                                      "HK":"852",
                                      "IR":"98",
                                      "IM":"44",
                                      "JE":"44",
                                      "KP":"850",
                                      "KR":"82",
                                      "LA":"856",
                                      "LY":"218",
                                      "MO":"853",
                                      "MK":"389",
                                      "FM":"691",
                                      "MD":"373",
                                      "MZ":"258",
                                      "PS":"970",
                                      "PN":"872",
                                      "RE":"262",
                                      "RU":"7",
                                      "BL":"590",
                                      "SH":"290",
                                      "KN":"1",
                                      "LC":"1",
                                      "MF":"590",
                                      "PM":"508",
                                      "VC":"1",
                                      "ST":"239",
                                      "SO":"252",
                                      "SJ":"47",
                                      "SY":"963",
                                      "TW":"886",
                                      "TZ":"255",
                                      "TL":"670",
                                      "VE":"58",
                                      "VN":"84",
                                      "VG":"284",
                                      "VI":"340"]
            let mobileCode = String(countryDictionary[country]!)
            let FormatmobileCode = "+" + mobileCode
            return FormatmobileCode
        } else {
            return "+1"
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.navigationController?.navigationBar.isHidden = false
        contentView.frame =  CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.contentViewHeight.constant = self.view.frame.height
      
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.mobilenumberTextField.layer.shadowColor = UIColor.gray.cgColor
        validationLabel.isHidden = true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 14
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    func makePhoneNumberVerified(){
        var parameterDict: [String: String?] = [ : ]
        parameterDict["uid"] = String(UserDefaults.standard.integer(forKey: "user_id"))
        parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
        parameterDict["device_type"] = "ios-phone"
        parameterDict["pubid"] = UserDefaults.standard.string(forKey:"pubid")
        parameterDict["phone"] = phoneNumber
        parameterDict["c_code"] = c_code
        ApiCommonClass.verifyPhoneNumber(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                 CustomProgressView.hideActivityIndicator()
                }
            } else {
                 DispatchQueue.main.async {
                CustomProgressView.hideActivityIndicator()
                WarningDisplayViewController().customActionAlert(viewController :self,title: "Your Number Varified", message: "", actionTitles: ["Ok"], actions:[{action1 in
                       self.dismiss() },nil])
                }
            }
        }
    }
}
extension GuestRegisterViewController: GuestRegisterDelegate {
    func didSelectGuestRegister() {
         DispatchQueue.main.async {
            CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
            self.makePhoneNumberVerified()
        }
    }
    func didSelectSkipVerification(){
        self.dismiss()
    }
}

