//
//  Category.swift
//  ToDoListApp
//
//  Created by yumi on 2020/06/17.
//  Copyright © 2020 Yumi Takahashi. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    
    let items = List<Item>()
}
