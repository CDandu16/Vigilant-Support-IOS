//
//  updatePassword.swift
//  Vigilant Support
//
//  Created by Chaitanya Madduru on 7/25/16.
//  Copyright © 2016 Vigilant Technologies. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class updatePasswordController: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var newPassword: UITextField!
    
    @IBAction func changePassword(sender: AnyObject) {
        Alamofire.request(.POST,"http://192.168.0.71:3000/api/authenticate/password",headers: ["x-access-token": GlobalV.token!],parameters: [ "id": GlobalV.email!, "password": self.newPassword.text!]).responseJSON{
            response in if let JSONValues = response.result.value{
                let json = JSON(JSONValues)
                print(json);
                let token = json["token"].stringValue
                //                let id = json["user_id"].stringValue;
                //                GlobalV.email = id;
                GlobalV.token = token;
                self.performSegueWithIdentifier("updated", sender: self)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.newPassword.delegate = self;
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
