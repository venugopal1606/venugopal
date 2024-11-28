//
//  RegistrationViewController.swift
//  FacebookLogin
//
//  Created by FCI-2181 on 24/07/24.
// venugopal  ios

import UIKit

class RegistrationViewController: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var NameTFLD: UITextField!
    @IBOutlet weak var MobilenumbTFLD: UITextField!
    @IBOutlet weak var DateofbirthTFLD: UITextField!
    @IBOutlet weak var UsernameTFLD: UITextField!
    @IBOutlet weak var PasswordTFLD: UITextField!
    @IBOutlet weak var LabelError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textfieldsproperties()
        
    }
    
    func textfieldsproperties(){
        NameTFLD.delegate = self
        MobilenumbTFLD.delegate = self
        DateofbirthTFLD.delegate = self
        UsernameTFLD.delegate = self
        PasswordTFLD.delegate = self
        LabelError.isHidden = true
        
    }
    
    
    
    
    @IBAction func Register(_ sender: Any) {
    
        if NameTFLD.text?.count ?? 0 < 7{
            LabelError.isHidden = false
            LabelError.text = "enter your name morethan 7 characters"
            
        }else if MobilenumbTFLD.text?.count ?? 0 < 10 {
            LabelError.isHidden = false
            LabelError.text = "enter your mobilenum morethan 10 characters"
            
        }else if DateofbirthTFLD.text?.count ?? 0 < 9{
            LabelError.isHidden = false
            LabelError.text = "enter your dateofbirth morethan 9 characters"
            
        }else if UsernameTFLD.text?.count ?? 0 < 8 {
            LabelError.isHidden = false
            LabelError.text = "enter your username morethan 8 characters"

        }else if PasswordTFLD.text?.count ?? 0 < 7 {
            LabelError.isHidden = false
            LabelError.text = "enter your password morethan 7 characters"
        }else{
            LabelError.isHidden = true
            let data = [NameTFLD.text,MobilenumbTFLD.text,DateofbirthTFLD.text,UsernameTFLD.text,PasswordTFLD.text]
            
            UserDefaults.standard.set(UsernameTFLD.text, forKey: "username")
            UserDefaults.standard.set(PasswordTFLD.text, forKey: "password")
            
            let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "LoginpageViewController")as!LoginpageViewController
            storyboard.jayanthdata = data as[Any]
            self.navigationController?.pushViewController(storyboard, animated: true)
            print(data)
            NameTFLD.text = ""
            MobilenumbTFLD.text = ""
            DateofbirthTFLD.text = ""
            UsernameTFLD.text = ""
            PasswordTFLD.text = ""
            
            
        }
            
        }
        
    }
    
    
    
    
    
    
    




