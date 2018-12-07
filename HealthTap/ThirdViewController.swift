//
//  ThirdViewController.swift
//  HealthTap
//
//  Created by Noirdemort on 02/12/18.
//  Copyright © 2018 Noirdemort. All rights reserved.
//

import UIKit
import Firebase

class ThirdViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	@IBAction func log_out(_ sender: Any) {
		let firebaseAuth = Auth.auth()
		do {
			try firebaseAuth.signOut()
		} catch let signOutError as NSError {
			print ("Error signing out: %@", signOutError)
		}
		self.performSegue(withIdentifier: "logout", sender: nil)
	}
	
}
