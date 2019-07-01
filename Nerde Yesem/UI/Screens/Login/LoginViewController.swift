//
//  LoginViewController.swift
//  Nerde Yesem
//
//  Created by umur yavuz on 29.06.2019.
//  Copyright © 2019 umur yavuz. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {
    
    @IBOutlet weak var container_header: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 10, height: 10)).cgPath
        container_header.layer.mask = maskLayer
    }
    
    @IBAction func onClick(_ sender: Any) {
        let myDelegate = UIApplication.shared.delegate as? AppDelegate

        myDelegate?.loginWithTouchID()
    }
   
}
