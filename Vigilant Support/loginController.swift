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
import Crashlytics

class loginController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var error: UILabel!
    
    /// The number of elements in the data source
    var total = 0
    
    // pasing data
    var projectTitle: String?
    var totalChild: Int = 0
    var passingData = [Person]()
    
    /// The data source
    var dataSource: [Parent] = []
    
    //The people
    var person: [Person]!
    
    
    @IBAction func LoginButton(sender: AnyObject) {
        let validLogin = isValidEmail(emailInput.text!)
        if validLogin {
            Alamofire.request(.POST,"http://159.203.189.124:3000/api/authenticate",parameters: [ "email":  self.emailInput.text!, "password": self.passwordInput.text!]).responseJSON{
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
                            self.loadProjects();
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
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//        let range = testStr.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
//        let result = range != nil ? true : false
//        return result
        return true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    func loadProjects(){
        Alamofire.request(.GET,"http://159.203.189.124:3000/api/projects/project/"+GlobalV.email!,headers: ["x-access-token": GlobalV.token!]).responseJSON{
            response in if let JSONValues = response.result.value{
                let json = JSON(JSONValues)
                if let projects = json["Projects"]["projects"].array{
                    for project in projects {
                        var childArray = [Person]();
                        if let employees = project["Employees"].array{
                            for employee in employees{
                                let child = Person(name: employee["name"].stringValue, phone: employee["phone"].stringValue, email: employee["email"].stringValue, picture: employee["picture"].stringValue, job_title: employee["job_title"].stringValue);
                                childArray.append(child);
                            }
                        }
                        self.dataSource.append(Parent(childs: childArray, title: project["project_name"].stringValue))
                    }
                    self.total = self.dataSource.count
                }
            }
            if (self.total == 1){
                self.passingData = self.dataSource[0].childs
                self.totalChild = self.dataSource[0].childs.count
                self.projectTitle = self.dataSource[0].title
                self.performSegueWithIdentifier("one_project", sender: self)
            }else{
                self.performSegueWithIdentifier("attempt", sender: self)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "one_project"){
            let navVc = segue.destinationViewController as! UINavigationController
            let vc = navVc.viewControllers.first as! ProjectTableViewController
            vc.dataSource = self.passingData
            vc.total = self.totalChild
            vc.projectTitle = self.projectTitle
            print("hello")
            print(vc.total)
        }
    }

    
    
}
