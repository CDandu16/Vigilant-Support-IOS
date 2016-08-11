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
import Crashlytics

class updatePasswordController: UIViewController,UITextFieldDelegate {
    
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
    
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var newPasswordCheck: UITextField!
    @IBOutlet weak var error: UILabel!
    
    @IBAction func changePassword(sender: AnyObject) {
        
        if(newPassword.text! == newPasswordCheck.text!){
            Alamofire.request(.POST,"http://159.203.189.124:3000/api/authenticate/password",headers: ["x-access-token": GlobalV.token!],parameters: [ "id": GlobalV.email!, "password": self.newPassword.text!]).responseJSON{
                response in if let JSONValues = response.result.value{
                    let json = JSON(JSONValues)
                    print(json);
                    let token = json["token"].stringValue
                    GlobalV.token = token;
                    self.loadProjects();
                }
            }
        }else{
            self.error.text = "passwords do not match"
            self.error.textColor = UIColor.redColor()
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.newPassword.delegate = self;
        self.newPasswordCheck.delegate = self;
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
    
    func loadProjects(){
        Alamofire.request(.GET,"http://159.203.189.124:3000/api/projects/project/"+GlobalV.email!,headers: ["x-access-token": GlobalV.token!]).responseJSON{
            response in if let JSONValues = response.result.value{
                let json = JSON(JSONValues)
                if let projects = json["Projects"]["projects"].array{
                    for project in projects {
                        var childArray : [Person] = [];
                        if let employees = project["Employees"].array{
                            for employee in employees{
                                let child = Person(name: employee["name"].stringValue, phone: employee["phone"].stringValue, email: employee["email"].stringValue, picture: employee["picture"].stringValue, job_title: employee["job_title"].stringValue,rank: employee["rank"].intValue);
                                childArray.append(child);
                            }
                        }
                        childArray.sortInPlace({$0.0.rank < $0.1.rank});
                        self.dataSource.append(Parent(childs: childArray, title: project["project_name"].stringValue))
                    }
                    self.total = self.dataSource.count
                }
            }
            if (self.total == 1){
                self.passingData = self.dataSource[0].childs
                self.totalChild = self.dataSource[0].childs.count
                self.projectTitle = self.dataSource[0].title
                self.performSegueWithIdentifier("one_project_updated", sender: self)
            }else{
                self.performSegueWithIdentifier("updated", sender: self)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "one_project_updated"){
            let navVc = segue.destinationViewController as! UINavigationController
            let vc = navVc.viewControllers.first as! ProjectTableViewController
            vc.dataSource = self.passingData
            vc.total = self.totalChild
            vc.projectTitle = self.projectTitle
            print("hello")
            print(vc.total)
        }
    }

    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    
}
