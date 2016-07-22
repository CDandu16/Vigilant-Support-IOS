//
//  GlobalV.swift
//  Vigilant Support
//
//  Created by Chaitanya Madduru on 6/21/16.
//  Copyright © 2016 Vigilant Technologies. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct GlobalV {
    static var email:Int?;
}
//func loadProjects(){
//    print("hi")
//    Alamofire.request(.GET,"http://192.168.0.71:3000/api/projects/"+GlobalV.email).responseJSON{
//        response in if let JSONValues = response.result.value{
//            let json = JSON(JSONValues)
//            if let projects = json["Projects"].array{
//                for project in projects {
//                    if let title = project["name"].string{
//                        let projectAdd = projectModel(name: title)
//                       // self.projectsUsed += [projectAdd]
//                    }
//                }
//            }
//        }
//        //self.projectsTable.reloadData()
//    }
//}
