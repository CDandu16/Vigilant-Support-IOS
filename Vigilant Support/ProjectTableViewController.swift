//
//  ProjectTableViewController.swift
//  Vigilant Support
//
//  Created by Chaitanya Madduru on 6/21/16.
//  Copyright © 2016 Vigilant Technologies. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProjectTableViewController: UITableViewController {
    /// The number of elements in the data source
    var total: Int!
    
    //name of listview
    var projectTitle: String?
    
    /// The data source
    var dataSource: [Person]!
    
    //The people
    var person: [Person]!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor = UIColor.clearColor();
        self.tableView.separatorStyle = .None
        self.view.backgroundColor = UIColor(red: 0.9,green: 0.9,blue: 0.9, alpha: 1)
        self.tableView.backgroundColor = UIColor(red: 0.9,green: 0.9,blue: 0.9, alpha: 1)
        self.title = self.projectTitle
        print(total)
//        self.loadProjects()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //HOW DO I DO THIS 
//    func loadProjects(){
//        print("hi")
//        Alamofire.request(.GET,"http://192.168.0.71:3000/api/projects/"+GlobalV.email).responseJSON{
//            response in if let JSONValues = response.result.value{
//                let json = JSON(JSONValues)
//                if let projects = json["Projects"].array{
//                    for project in projects {
//                        let child1 = Person(name: project["first_name"].stringValue, phone: project["first_telephone"].stringValue, email: project["first_email"].stringValue)
//                        let child2 = Person(name: project["secondary_name"].stringValue, phone: project["secondary_telephone"].stringValue, email: project["secondary_email"].stringValue)
//                        let child3 = Person(name: project["third_name"].stringValue, phone: project["third_telephone"].stringValue, email: project["third_email"].stringValue)
//                        let child4 = Person(name: project["fourth_name"].stringValue, phone: project["fourth_telephone"].stringValue, email: project["fourth_email"].stringValue)
//                        let child5 = Person(name: project["fifth_name"].stringValue, phone: project["fifth_telephone"].stringValue, email: project["fifth_email"].stringValue)
//                        self.dataSource+=[child1,child2,child3,child4,child5]
//                    }
//                    self.total = self.dataSource.count
//                }
//            }
//            self.tableView.reloadData()
//        }
//    }
//    
   

    // MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.total
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
               
    
            let cell = tableView.dequeueReusableCellWithIdentifier("cardViewCell", forIndexPath: indexPath) as! PersonCardCell
            
            let child = self.view.viewWithTag(100) as? UILabel
            child!.text =  self.dataSource[indexPath.row].name
            child!.textAlignment = .Center
            
            let emlBtn = self.view.viewWithTag(10) as? subclassedUIButton
            let callBtn = self.view.viewWithTag(20) as? subclassedUIButton
            let txtBtn = self.view.viewWithTag(30) as? subclassedUIButton
            emlBtn?.string = self.dataSource[indexPath.row].email
            callBtn?.string = self.dataSource[indexPath.row].phone
            txtBtn?.string = self.dataSource[indexPath.row].phone
            emlBtn?.addTarget(self, action: #selector(ProjectTableViewController.emlBtn(_:)), forControlEvents: .TouchUpInside)
            callBtn?.addTarget(self, action: #selector(ProjectTableViewController.callBtn(_:)), forControlEvents: .TouchUpInside)
            txtBtn?.addTarget(self, action: #selector(ProjectTableViewController.txtBtn(_:)), forControlEvents: .TouchUpInside)
    
        
        return cell
    }
    
    //This compsoses the email to send
    func emlBtn(sender: subclassedUIButton){
        NSLog(sender.string!)
        let email = sender.string!
        let url = NSURL(string: "mailto:\(email)")!
        UIApplication.sharedApplication().openURL(url)
    }
    
    //This will open the call button
    func callBtn(sender: subclassedUIButton){
        let no = sender.string!
        if(!(no.substringToIndex(no.startIndex.advancedBy(1))=="1")){
            let alert = UIAlertController(title: "International Call", message: "This is an international call", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default, handler: {action in
                NSLog("it worked")
                NSLog(sender.string!)
                let phone = sender.string!
                let url = NSURL(string: "tel://\(phone)")!
                UIApplication.sharedApplication().openURL(url)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
            NSLog(sender.string!)
            let phone = sender.string!
            let url = NSURL(string: "tel://\(phone)")!
            UIApplication.sharedApplication().openURL(url)
        }
        
    }
    
    func txtBtn(sender: subclassedUIButton){
        NSLog(sender.string!)
        let sms = sender.string!
        let url = NSURL(string: "sms://\(sms)")!
        UIApplication.sharedApplication().openURL(url)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 300 ;
    }

    

}
