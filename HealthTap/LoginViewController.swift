//
//  LoginViewController.swift
//  HealthTap
//
//  Created by Noirdemort on 02/12/18.
//  Copyright © 2018 Noirdemort. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

	@IBOutlet weak var login_mail: UITextView!
	
	
	@IBOutlet weak var login_password: UITextField!
	
	@IBAction func login(_ sender: Any) {

		if (login_mail.text!.isEmpty || login_password.text!.isEmpty){
			let alertController = UIAlertController(title: "Error!", message: "Username and password should not be empty", preferredStyle: UIAlertController.Style.alert)

			alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))

			self.present(alertController, animated: true, completion: nil)
		} else{
			Auth.auth().signIn(withEmail: login_mail.text!, password: login_password.text!) { (user, error) in

				if (error == nil){
					self.performSegue(withIdentifier: "login_success", sender: nil)
				}else{
					print("Login Error: \(error!)")
					let alertController = UIAlertController(title: "Login Error!", message: "Invalid username or password!", preferredStyle: UIAlertController.Style.alert)
					
					alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
					
					self.present(alertController, animated: true, completion: nil)
				}
			}
		}
	}
	/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
