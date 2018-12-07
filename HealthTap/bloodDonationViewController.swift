//
//  bloodDonationViewController.swift
//  HealthTap
//
//  Created by Noirdemort on 03/12/18.
//  Copyright © 2018 Noirdemort. All rights reserved.
//

import UIKit
import Firebase

class bloodDonationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
	
	let blood_groups = ["A+", "B+", "O+", "AB+", "A-", "B-", "O-", "AB-"]
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return blood_groups.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return blood_groups[row]
	}
	
	

	@IBOutlet weak var donated_bank: UITextField!
	
	
	@IBOutlet weak var blood_group: UIPickerView!
	
	var group = ""
	

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		group = blood_groups[row]
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.blood_group.delegate = self
		self.blood_group.dataSource = self
        // Do any additional setup after loading the view.
    }
    

	@IBAction func save_donation(_ sender: Any) {
		if (donated_bank.text!.isEmpty || group == "" ){
			
		}else{
			
			let firebaseAuth = Auth.auth()
			let user = firebaseAuth.currentUser?.email
			let request = NSMutableURLRequest(url: NSURL(string: "http://localhost:5000/save_blood/")! as URL)
			request.httpMethod = "POST"
			let postString = "\(group)@\(donated_bank.text!)@\(String(describing: user))"
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
				print("Blood responseString = \(String(describing: responseString))")
			}
			task.resume()
		}
	}
	
}
