//
//  Item.swift
//  StrikeMeOff!
//
//  Created by Sidhant Chadha on 8/28/18.
//  Copyright © 2018 AMoDynamics, Inc. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    //Inverse relationship in Swift. Many to One.
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
