//
//  ProjectTableViewController.swift
//  Vigilant Support
//
//  Created by Chaitanya Madduru on 6/21/16.
//  Copyright © 2016 Vigilant Technologies. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import Alamofire
import SwiftyJSON
import Crashlytics

class ProjectTableViewController: UITableViewController {
    /// The number of elements in the data source
    var total: Int!
    
    //name of listview
    var projectTitle: String?
    
    /// The data source
    var dataSource: [Person]!
    
    //The people
    var person: [Person]!
    
    var viewLaidOut: Bool!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor = UIColor.clearColor();
        self.tableView.separatorStyle = .None
        self.view.backgroundColor = UIColor(red: 0.9,green: 0.9,blue: 0.9, alpha: 1)
        self.tableView.backgroundColor = UIColor(red: 0.9,green: 0.9,blue: 0.9, alpha: 1)
        self.title = self.projectTitle
        self.viewLaidOut = false;
        print(total)
//        self.loadProjects()
    }
    
    override func viewDidLayoutSubviews() {
        if(self.view?.viewWithTag(2) != nil){
            let cardView = self.view.viewWithTag(2)
            cardView!.alpha = CGFloat(1)
            cardView!.layer.masksToBounds = false;
            cardView!.layer.shadowOffset = CGSizeMake(0,0)
            cardView!.layer.cornerRadius = 2;
            cardView!.layer.shadowRadius = 2;
            cardView!.layer.shadowPath = UIBezierPath(rect: CGRect(x: CGFloat(0),y: CGFloat(0),width: cardView!.bounds.width,height: cardView!.bounds.height)).CGPath
            cardView!.layer.shadowOpacity = 0.5;
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


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
            let job_title = self.view.viewWithTag(110) as? UILabel
            child!.text =  self.dataSource[indexPath.row].name
            job_title!.text = self.dataSource[indexPath.row].job_title
            job_title!.textAlignment = .Center
            child!.textAlignment = .Center
        
            let thumb = self.view.viewWithTag(60) as? UIImageView
            thumb?.imageWithUrl(url: self.dataSource[indexPath.row].picture!)
        
        
            let emlBtn = self.view.viewWithTag(10) as? subclassedUIButton
            let callBtn = self.view.viewWithTag(20) as? subclassedUIButton
            let txtBtn = self.view.viewWithTag(30) as? subclassedUIButton
        
            emlBtn?.string = self.dataSource[indexPath.row].email
            //emlBtn?.layer.cornerRadius = 2
            callBtn?.string = self.dataSource[indexPath.row].phone
            //emlBtn?.layer.cornerRadius = 2
            txtBtn?.string = self.dataSource[indexPath.row].phone
            //emlBtn?.layer.cornerRadius = 2
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
    
//    func load_image(urlString: String){
//        var imgUrl: NSURL = NSURL(string: urlString)!
//        let request: NSURLRequest = NSURLRequest(URL: imgUrl)
//        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?, error: NSError?) ->Void in
//            if error == nil {
//               
//                thumb = UIImageView(image: UIImage(data: data!))
//            }
//        })
//    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 260 ;
    }

    

}
