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
    
    //
    var totalChild: Int = 0
    var passingData = [Person]()
    
    /// The data source
    var dataSource: [Parent] = []
    
    //The people
    var person: [Person]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadProjects()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //HOW DO I DO THIS
    func loadProjects(){
        Alamofire.request(.GET,"http://192.168.0.71:3000/api/projects/"+GlobalV.email).responseJSON{
            response in if let JSONValues = response.result.value{
                let json = JSON(JSONValues)
                if let projects = json["Projects"].array{
                    for project in projects {
                        var childArray = [Person]();
                        let child1 = Person(name: project["first_name"].stringValue, phone: project["first_telephone"].stringValue, email: project["first_email"].stringValue)
                        childArray.append(child1);
                        let child2 = Person(name: project["secondary_name"].stringValue, phone: project["secondary_telephone"].stringValue, email: project["secondary_email"].stringValue)
                        childArray.append(child2);
                        let child3 = Person(name: project["third_name"].stringValue, phone: project["third_telephone"].stringValue, email: project["third_email"].stringValue)
                        if(child3.name!.isEmpty){
                           
                        }else{
                            childArray.append(child3)
                        }
                        let child4 = Person(name: project["fourth_name"].stringValue, phone: project["fourth_telephone"].stringValue, email: project["fourth_email"].stringValue)
                        if(child4.name!.isEmpty){
                            
                        }else{
                            childArray.append(child4)
                        }
                        let child5 = Person(name: project["fifth_name"].stringValue, phone: project["fifth_telephone"].stringValue, email: project["fifth_email"].stringValue)
                        if(child5.name!.isEmpty){
                            
                        }else{
                            childArray.append(child5)
                        }
                        self.dataSource.append(Parent(childs: childArray, title: project["name"].stringValue))
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
            print("hello")
            print(vc.total)
        }
    }
    
    
    
}