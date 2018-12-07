//
//  medicineSearchViewController.swift
//  HealthTap
//
//  Created by Noirdemort on 03/12/18.
//  Copyright © 2018 Noirdemort. All rights reserved.
//

import UIKit

class medicineSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	var medicine_list = [String]()
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return medicine_list.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "medicine_search_cell")
		cell.textLabel!.text = medicine_list[indexPath.row]
		return cell
	}
	

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	
	

	@IBOutlet weak var company: UITextField!
	
	@IBOutlet weak var medicine: UITextField!
	
	
	@IBOutlet weak var salt: UITextField!
	

	@IBAction func find_medicine(_ sender: Any) {
		if ( company.text!.isEmpty && medicine.text!.isEmpty && salt.text!.isEmpty){
			let alertController = UIAlertController(title: "Error!", message: "Atleast one field  should be filled!", preferredStyle: UIAlertController.Style.alert)
			
			alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
			
			self.present(alertController, animated: true, completion: nil)
			return
		}else{
			let request = NSMutableURLRequest(url: NSURL(string: "http://localhost:5000/search_medicine/")! as URL)
			request.httpMethod = "POST"
			let postString = "\(company.text!)@\(medicine.text!)@\(salt.text!)"
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
		}
	}
	
}
