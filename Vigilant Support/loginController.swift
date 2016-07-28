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
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var error: UILabel!
    
    
    @IBAction func LoginButton(sender: AnyObject) {
        let validLogin = isValidEmail(emailInput.text!)
        if validLogin {
            Alamofire.request(.POST,"http://192.168.0.71:3000/api/authenticate",parameters: [ "email":  self.emailInput.text!, "password": self.passwordInput.text!]).responseJSON{
                response in
                switch response.result{
                case .Failure(_):
                    if let statusCode = response.response?.statusCode{
                        if statusCode == 401{
                            self.error.text = "wrong username or password"
                            self.error.textColor = UIColor.redColor()
                            print(self.error.text)
                        }
                    }
                case .Success( _):
                    if let JSONValues = response.result.value{
                        let json = JSON(JSONValues)
                        print(json);
                        let token = json["token"].stringValue
                        let id = json["user_id"].stringValue;
                        GlobalV.email = id;
                        GlobalV.token = token;
                        if json["first_time"].boolValue{
                            self.performSegueWithIdentifier("new_password", sender: self)
                        }else{
                            self.performSegueWithIdentifier("attempt", sender: self)
                        }
                    }
                
                
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailInput.delegate = self;
        self.passwordInput.delegate = self;
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
