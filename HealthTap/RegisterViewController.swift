//
//  RegisterViewController.swift
//  HealthTap
//
//  Created by Noirdemort on 02/12/18.
//  Copyright © 2018 Noirdemort. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    


	@IBOutlet weak var username: UITextView!
	
	
	
	@IBOutlet weak var email: UITextView!
	
	@IBOutlet weak var password: UITextField!
	

	
	
	@IBAction func register_user(_ sender: Any) {
		
		if (email.text!.isEmpty || username.text!.isEmpty || password.text!.isEmpty){
			let alertController = UIAlertController(title: "Error!", message: "All fields are compulsory!", preferredStyle: UIAlertController.Style.alert)
			
			alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
			
			self.present(alertController, animated: true, completion: nil)
			return
		}
			
		Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (authResult, error) in
			// ...
			guard (authResult?.user) != nil else {
				let alertController = UIAlertController(title: "Registration alert", message: "Account Creation unsuccessful!", preferredStyle: UIAlertController.Style.alert)

				alertController.addAction(UIAlertAction(title: "Retry", style: UIAlertAction.Style.default,handler: nil))

				self.present(alertController, animated: true, completion: nil)
				return
			}

			print(authResult!)
			let request = NSMutableURLRequest(url: NSURL(string: "http://localhost:5000/set_user/")! as URL)
			request.httpMethod = "POST"
			let postString = "\(self.username.text!)#\(self.email.text!)"
			request.httpBody = postString.data(using: String.Encoding.utf8)
			let task = URLSession.shared.dataTask(with: request as URLRequest){data, response, error in
				guard error == nil && data != nil else{
					print("error")
					return
				}
				if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200{
					print("statusCode should be 200, but is \(httpStatus.statusCode)")
					print("response = \(String(describing: response))")
				}
				let responseString = String(data: data!, encoding: String.Encoding.utf8)
				print("responseString = \(String(describing: responseString))")
			}
			task.resume()
			self.performSegue(withIdentifier: "registered", sender: nil)
			
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
