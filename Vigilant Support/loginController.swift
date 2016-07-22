//
//  loginController.swift
//  Vigilant Support
//
//  Created by Chaitanya Madduru on 6/16/16.
//  Copyright © 2016 Vigilant Technologies. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class loginController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var emailInput: UITextField!

    @IBAction func LoginButton(sender: AnyObject) {
        let validLogin = isValidEmail(emailInput.text!)
        if validLogin {
            print("User entered valid input")
            print(self.emailInput.text!)
            GlobalV.email = 1;
            self.performSegueWithIdentifier("attempt", sender: self)
        } else {
            print("Invalid email address")
        }
//        Alamofire.request(.GET,"http://192.168.0.71:3000/api/users/"+emailInput.text!).responseJSON{
//            response in if let JSONValues = response.result.value{
//                let json = JSON(JSONValues)
//                let user = json["Users"].stringValue
//                print(user)
//                if("client" == "client"){
//                    print(self.emailInput.text!)
//                    GlobalV.email = self.emailInput.text!
//                    self.performSegueWithIdentifier("attempt", sender: self)
//                }else if(user == "employee"){
//                
//                }else{
//                    
//                }
//            }
//        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailInput.delegate = self;
        UIApplication.sharedApplication().statusBarStyle = .Default
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return false
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let range = testStr.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
        let result = range != nil ? true : false
        return result
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    
}
