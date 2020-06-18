//
//  Item.swift
//  ToDoListApp
//
//  Created by yumi on 2020/06/16.
//  Copyright © 2020 Yumi Takahashi. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    let items = List<Item>()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
