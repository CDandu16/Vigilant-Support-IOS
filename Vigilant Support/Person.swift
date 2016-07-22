//
//  Person.swift
//  Vigilant Support
//
//  Created by Chaitanya Madduru on 6/21/16.
//  Copyright © 2016 Vigilant Technologies. All rights reserved.
//

import UIKit

class Person{
    var name:String?
    var phone:String?
    var email:String?
    var picture:String?

    init(name: String, phone: String, email: String,picture: String){
        self.name = name
        self.phone = phone
        self.email = email
        self.picture = picture;
    }
}
