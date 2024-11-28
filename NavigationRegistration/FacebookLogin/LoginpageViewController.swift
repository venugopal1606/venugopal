//
//  LoginpageViewController.swift
//  FacebookLogin
//
//  Created by FCI-2181 on 24/07/24.
//

import UIKit

class LoginpageViewController: UIViewController {

    
    @IBOutlet weak var UsernameTFLD: UITextField!
    @IBOutlet weak var PasswordTFLD: UITextField!
    
    @IBOutlet weak var ErrorLabel: UILabel!
    var username : String!
    var password : String!
    
    
    var jayanthdata : Array <Any> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        ErrorLabel.isHidden = true
        username = UserDefaults.standard.string(forKey: "username")
        password = UserDefaults.standard.string(forKey: "password")
        print("expected username : \(username!)")
        print("expected password : \(password!)")

    }
    


    @IBAction func LoginBT(_ sender: Any) {
        
        if (UsernameTFLD.text!.count < 8 ){
            ErrorLabel.isHidden = false
            ErrorLabel.text = "Enter your username"
            
        }else if (PasswordTFLD.text!.count < 7 ){
            ErrorLabel.isHidden = false
            ErrorLabel.text = "Enter your password"
            
        }else{

            if ((UsernameTFLD.text! == username ) && (PasswordTFLD.text! == password  )){
                
                let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "HomepageViewController") as! HomepageViewController
                self.navigationController?.pushViewController(storyboard, animated: true)
                UsernameTFLD.text = ""
                PasswordTFLD.text = ""
                
            }else{
                ErrorLabel.isHidden = false
                ErrorLabel.text = "please enter correct details"
                
            }
            
        }
    }
        
        
        
        
    }
    
    
    
    

