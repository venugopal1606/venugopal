//
//  SignOutViewController.swift
//  FacebookLogin
//
//  Created by FCI-2181 on 26/07/24.
//

import UIKit

class SignOutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    @IBAction func SignOut(_ sender: Any) {

        let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "LoginpageViewController") as! LoginpageViewController
        self.navigationController?.pushViewController(storyboard, animated: true)
        
        
        
        
        
        
    }
    
    

}
