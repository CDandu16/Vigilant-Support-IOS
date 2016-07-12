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
    var total = 0
    
    /// The identifier for the parent cells.
    let parentCellIdentifier = "ParentCell"
    
    /// The identifier for the child cells.
    let childCellIdentifier = "ChildCell"
    
    /// The data source
    var dataSource: [Parent] = []
    
    //The people
    var person: [Person]!
    
    /// Define wether can exist several cells expanded or not.
    let numberOfCellsExpanded: NumberOfCellExpanded = .One
    
    /// Constant to define the values for the tuple in case of not exist a cell expanded.
    let NoCellExpanded = (-1, -1)
    
    /// The index of the last cell expanded and its parent.
    var lastCellExpanded : (Int, Int)!


    @IBOutlet weak var emlBttn: UITableViewCell!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadProjects()
        self.lastCellExpanded = NoCellExpanded
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //HOW DO I DO THIS 
    func loadProjects(){
        print("hi")
        Alamofire.request(.GET,"http://192.168.0.71:3000/api/projects/"+GlobalV.email).responseJSON{
            response in if let JSONValues = response.result.value{
                let json = JSON(JSONValues)
                if let projects = json["Projects"].array{
                    for project in projects {
                        let child1 = Person(name: project["first_name"].stringValue, phone: project["first_telephone"].stringValue, email: project["first_email"].stringValue)
                        let child2 = Person(name: project["secondary_name"].stringValue, phone: project["secondary_telephone"].stringValue, email: project["secondary_email"].stringValue)
                        let child3 = Person(name: project["third_name"].stringValue, phone: project["third_telephone"].stringValue, email: project["third_email"].stringValue)
                        let child4 = Person(name: project["fourth_name"].stringValue, phone: project["fourth_telephone"].stringValue, email: project["fourth_email"].stringValue)
                        let child5 = Person(name: project["fifth_name"].stringValue, phone: project["fifth_telephone"].stringValue, email: project["fifth_email"].stringValue)
                        self.total=projects.count
                        self.dataSource .append(Parent(state: .Collapsed, childs: [child1,child2,child3,child4,child5], title: project["name"].stringValue))
                    }
                }
            }
            self.tableView.reloadData()
        }
    }

    /**
     Set the initial data for test the table view.
     
     - parameter parents: The number of parents cells
     - parameter childs:  Then maximun number of child cells per parent.
     */
//    private func setInitialDataSource(numberOfRowParents parents: Int, numberOfRowChildPerParent childs: Int) {
//        
//        // Set the total of cells initially.
//        self.total = parents
//        
//        let data = [Parent](count: parents, repeatedValue: Parent(state: .Collapsed, childs: [String](), title: ""))
//        
//        dataSource = data.enumerate().map({ (index: Int, element: Parent) -> Parent in
//            
//            var newElement = element
//            
//            newElement.title = "Item \(index)"
//            
//            // generate the random number between 0...childs
//            let random = Int(arc4random_uniform(UInt32(childs + 1)))
//            
//            // create the array for each cell
//            newElement.childs = (0..<random).enumerate().map {"Subitem \($0.index)"}
//            
//            return newElement
//        })
//    }
    
    /**
     Expand the cell at the index specified.
     
     - parameter index: The index of the cell to expand.
     */
    private func expandItemAtIndex(index : Int, parent: Int) {
        
        // the data of the childs for the specific parent cell.
        let currentSubItems = self.dataSource[parent].childs
        
        // update the state of the cell.
        self.dataSource[parent].state = .Expanded
        
        // position to start to insert rows.
        var insertPos = index + 1
        
        let indexPaths = (0..<currentSubItems.count).map { _ -> NSIndexPath in
            let indexPath = NSIndexPath(forRow: insertPos, inSection: 0)
            insertPos += 1
            return indexPath
        }
        
        // insert the new rows
        self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
        
        // update the total of rows
        self.total += currentSubItems.count
    }
    
    /**
     Collapse the cell at the index specified.
     
     - parameter index: The index of the cell to collapse
     */
    private func collapseSubItemsAtIndex(index : Int, parent: Int) {
        
        var indexPaths = [NSIndexPath]()
        
        let numberOfChilds = self.dataSource[parent].childs.count
        
        // update the state of the cell.
        self.dataSource[parent].state = .Collapsed
        
        guard index + 1 <= index + numberOfChilds else { return }
        
        // create an array of NSIndexPath with the selected positions
        indexPaths = (index + 1...index + numberOfChilds).map { NSIndexPath(forRow: $0, inSection: 0)}
        
        // remove the expanded cells
        self.tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
        
        // update the total of rows
        self.total -= numberOfChilds
    }
    
    /**
     Update the cells to expanded to collapsed state in case of allow severals cells expanded.
     
     - parameter parent: The parent of the cell
     - parameter index:  The index of the cell.
     */
    private func updateCells(parent: Int, index: Int) {
        
        switch (self.dataSource[parent].state) {
            
        case .Expanded:
            self.collapseSubItemsAtIndex(index, parent: parent)
            self.lastCellExpanded = NoCellExpanded
            
        case .Collapsed:
            switch (numberOfCellsExpanded) {
            case .One:
                // exist one cell expanded previously
                if self.lastCellExpanded != NoCellExpanded {
                    
                    let (indexOfCellExpanded, parentOfCellExpanded) = self.lastCellExpanded
                    
                    self.collapseSubItemsAtIndex(indexOfCellExpanded, parent: parentOfCellExpanded)
                    
                    // cell tapped is below of previously expanded, then we need to update the index to expand.
                    if parent > parentOfCellExpanded {
                        let newIndex = index - self.dataSource[parentOfCellExpanded].childs.count
                        self.expandItemAtIndex(newIndex, parent: parent)
                        self.lastCellExpanded = (newIndex, parent)
                    }
                    else {
                        self.expandItemAtIndex(index, parent: parent)
                        self.lastCellExpanded = (index, parent)
                    }
                }
                else {
                    self.expandItemAtIndex(index, parent: parent)
                    self.lastCellExpanded = (index, parent)
                }
            case .Several:
                self.expandItemAtIndex(index, parent: parent)
            }
        }
    }
    
    /**
     Find the parent position in the initial list, if the cell is parent and the actual position in the actual list.
     
     - parameter index: The index of the cell
     
     - returns: A tuple with the parent position, if it's a parent cell and the actual position righ now.
     */
    private func findParent(index : Int) -> (parent: Int, isParentCell: Bool, actualPosition: Int) {
        
        var position = 0, parent = 0
        guard position < index else { return (parent, true, parent) }
        
        var item = self.dataSource[parent]
        
        repeat {
            
            switch (item.state) {
            case .Expanded:
                position += item.childs.count + 1
            case .Collapsed:
                position += 1
            }
            
            parent += 1
            
            // if is not outside of dataSource boundaries
            if parent < self.dataSource.count {
                item = self.dataSource[parent]
            }
            
        } while (position < index)
        
        // if it's a parent cell the indexes are equal.
        if position == index {
            return (parent, position == index, position)
        }
        
        item = self.dataSource[parent - 1]
        return (parent - 1, position == index, position - item.childs.count - 1)
    }
}

extension ProjectTableViewController {
    
    // MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.total
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell!
        
        let (parent, isParentCell, actualPosition) = self.findParent(indexPath.row)
        
        if !isParentCell {
            cell = tableView.dequeueReusableCellWithIdentifier(childCellIdentifier, forIndexPath: indexPath)
            let child = self.view.viewWithTag(100) as? UILabel
            child!.text =  self.dataSource[parent].childs[indexPath.row - actualPosition - 1].name
            child!.textAlignment = .Center
            
            let emlBtn = self.view.viewWithTag(10) as? subclassedUIButton
            let callBtn = self.view.viewWithTag(20) as? subclassedUIButton
            let txtBtn = self.view.viewWithTag(30) as? subclassedUIButton
            emlBtn?.string = self.dataSource[parent].childs[indexPath.row - actualPosition - 1].email
            callBtn?.string = self.dataSource[parent].childs[indexPath.row - actualPosition - 1].phone
            txtBtn?.string = self.dataSource[parent].childs[indexPath.row - actualPosition - 1].phone
            emlBtn?.addTarget(self, action: #selector(ProjectTableViewController.emlBtn(_:)), forControlEvents: .TouchUpInside)
            callBtn?.addTarget(self, action: #selector(ProjectTableViewController.callBtn(_:)), forControlEvents: .TouchUpInside)
            txtBtn?.addTarget(self, action: #selector(ProjectTableViewController.txtBtn(_:)), forControlEvents: .TouchUpInside)
        }
        else {
            cell = tableView.dequeueReusableCellWithIdentifier(parentCellIdentifier, forIndexPath: indexPath)
            cell.textLabel!.text = self.dataSource[parent].title
            cell.textLabel!.textColor = UIColor.whiteColor();
        }
        
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

    
    
    
    // MARK: UITableViewDelegate
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let (parent, isParentCell, actualPosition) = self.findParent(indexPath.row)
        
        guard isParentCell else {
            
                        
            NSLog("A child was tapped!!!")
            
            // The value of the child is indexPath.row - actualPosition - 1
            NSLog("The value of the child is \(self.dataSource[parent].childs[indexPath.row - actualPosition - 1])")
            
            return
        }
        
        self.tableView.beginUpdates()
        self.updateCells(parent, index: indexPath.row)
        self.tableView.endUpdates()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return !self.findParent(indexPath.row).isParentCell ? 150.0 : 50.0
    }
    
}
