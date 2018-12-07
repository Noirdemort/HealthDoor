//
//  medicineSaveViewController.swift
//  HealthTap
//
//  Created by Noirdemort on 03/12/18.
//  Copyright © 2018 Noirdemort. All rights reserved.
//

import UIKit
import Firebase

class medicineSaveViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	var expiry_date = ""
	

	@IBOutlet weak var company: UITextField!
	
	@IBOutlet weak var medicine: UITextField!
	
	
	@IBOutlet weak var salt: UITextField!
	

	@IBOutlet weak var datePicker: UIDatePicker!
	
	@IBAction func datePickerAction(_ sender: Any) {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd-MM-yyyy"
		let strDate = dateFormatter.string(from: datePicker.date)
		self.expiry_date = strDate
	}
	
	@IBAction func save_medicine(_ sender: Any) {
	
		let firebaseAuth = Auth.auth()
		let user = firebaseAuth.currentUser?.email
		if ( ( company.text!.isEmpty || medicine.text!.isEmpty || salt.text!.isEmpty) || (expiry_date == "" ) ){
			let alertController = UIAlertController(title: "Error!", message: "Atleast one field and Expiry Date should be filled!", preferredStyle: UIAlertController.Style.alert)
			
			alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
			
			self.present(alertController, animated: true, completion: nil)
			return
		}else{
			let request = NSMutableURLRequest(url: NSURL(string: "http://localhost:5000/save_medicine/")! as URL)
			request.httpMethod = "POST"
			let postString = "\(company.text!)@\(medicine.text!)@\(salt.text!)@\(String(describing: user))@\(expiry_date)"
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
			self.performSegue(withIdentifier: "med_saved", sender: nil)
		}
	}

}
