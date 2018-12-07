//
//  BloodSearchViewController.swift
//  HealthTap
//
//  Created by Noirdemort on 03/12/18.
//  Copyright © 2018 Noirdemort. All rights reserved.
//

import UIKit
import CoreLocation

class BloodSearchViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
	
	var banks_list = [String]()
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return banks_list.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "blood_bank_search_cell")
		cell.textLabel!.text = banks_list[indexPath.row]
		return cell
	}
	
	
	let blood_groups = ["A+", "B+", "O+", "AB+", "A-", "B-", "O-", "AB-"]
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return blood_groups[row]
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return blood_groups.count
	}
	
	let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

		self.blood_group.delegate = self
		self.blood_group.dataSource = self
        // Do any additional setup after loading the view.
		locationManager.delegate = self;
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestWhenInUseAuthorization()
		locationManager.startUpdatingLocation()
    }

	
	@IBOutlet weak var blood_group: UIPickerView!
	
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		let aa = blood_group.selectedRow(inComponent: row)
		print(aa)
		let request = NSMutableURLRequest(url: NSURL(string: "http://localhost:5000/get_blood/")! as URL)
		request.httpMethod = "POST"
		let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
		let location = String(locValue.latitude) + "#" + String(locValue.longitude)
		let postString = "\(blood_groups[aa])@\(location)"
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
