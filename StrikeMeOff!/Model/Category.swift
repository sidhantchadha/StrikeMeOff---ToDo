//
//  Category.swift
//  StrikeMeOff!
//
//  Created by Sidhant Chadha on 8/28/18.
//  Copyright © 2018 AMoDynamics, Inc. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    //Forward relationship in Swift. One to Many.
    let items = List<Item>()
    
}
