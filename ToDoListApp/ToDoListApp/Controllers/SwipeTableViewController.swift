//
//  SwipeTableViewController.swift
//  ToDoListApp
//
//  Created by yumi on 2020/06/18.
//  Copyright © 2020 Yumi Takahashi. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TableViewの高さを決める
        tableView.rowHeight = 80.0
        
        // tableViewを囲っている線を消す
        tableView.separatorStyle = .none
        
    }
    
    // TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
    }
    
    // SwipeCellKitの設定
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        // Swipeしてdeleteをクリックしたらdeleteできる
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            self.updateModel(at: indexPath)
        }

        // delete iconを設定
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
    
    // 参照 https://github.com/SwipeCellKit/SwipeCellKit
    // SwipeしきったときにもDeleteできるようにするOption
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
        // Update our data model.
    }
    
}
