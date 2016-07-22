//
//  LoadProjectController.swift
//  Vigilant Support
//
//  Created by Chaitanya Madduru on 7/18/16.
//  Copyright © 2016 Vigilant Technologies. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoadProjectController: UITableViewController {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Projects"
        self.loadProjects()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    //HOW DO I DO THIS
    func loadProjects(){
        Alamofire.request(.GET,"http://192.168.0.71:3000/api/projects/project/1").responseJSON{
            response in if let JSONValues = response.result.value{
                let json = JSON(JSONValues)
                if let projects = json["Projects"]["projects"].array{
                    for project in projects {
                        var childArray = [Person]();
                        if let employees = project["Employees"].array{
                            for employee in employees{
                                print("hello")
                                print(employee["picture"].stringValue)
                                let child = Person(name: employee["name"].stringValue, phone: employee["phone"].stringValue, email: employee["email"].stringValue, picture: employee["picture"].stringValue);
                                childArray.append(child);
                            }
                        }
                        self.dataSource.append(Parent(childs: childArray, title: project["project_name"].stringValue))
                    }
                    self.total = self.dataSource.count
                }
            }
            self.tableView.reloadData()
        }
    }
    
    
    
    // MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.total
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("projectCell", forIndexPath: indexPath)
        let child = self.view.viewWithTag(200) as? UILabel
        child!.text =  self.dataSource[indexPath.row].title
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.passingData = self.dataSource[indexPath.row].childs
        self.totalChild = self.dataSource[indexPath.row].childs.count
        self.projectTitle = self.dataSource[indexPath.row].title
        self.performSegueWithIdentifier("detailer", sender: self)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "detailer"){
            let vc: ProjectTableViewController = segue.destinationViewController as! ProjectTableViewController
            vc.dataSource = self.passingData
            vc.total = self.totalChild
            vc.projectTitle = self.projectTitle
            print("hello")
            print(vc.total)
        }
    }
    
    
    
}