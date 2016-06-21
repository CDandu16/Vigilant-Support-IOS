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
    
    
    var projectsUsed = [projectModel]()
    
    @IBOutlet var projectsTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        projectsTable.delegate = self
        projectsTable.dataSource = self
        loadProjects()
    }
    
    func loadProjects(){
        print("hi")
        Alamofire.request(.GET,"http://192.168.0.71:3000/api/projects/chaitudandu@gmail.com").responseJSON{
            response in if let JSONValues = response.result.value{
                let json = JSON(JSONValues)
                if let projects = json["Projects"].array{
                    for project in projects {
                        if let title = project["name"].string{
                            let projectAdd = projectModel(name: title)
                            self.projectsUsed += [projectAdd]
                        }
                    }
                }
            }
            self.projectsTable.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectsUsed.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("works ere")
        let cellIdentifier = "ProjectTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! Project
        let project = projectsUsed[indexPath.row]
        
        print(project.name)
        
        cell.nameLabel.text = project.name
        

        // Configure the cell...

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
