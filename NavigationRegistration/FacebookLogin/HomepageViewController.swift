//
//  HomepageViewController.swift
//  FacebookLogin
//
//  Created by FCI-2181 on 25/07/24.
//

import UIKit

class HomepageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func NextPage(_ sender: Any) {
        
        let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "SignOutViewController") as! SignOutViewController
        self.navigationController?.pushViewController(storyboard, animated: true)
        
    }
    
    

}
