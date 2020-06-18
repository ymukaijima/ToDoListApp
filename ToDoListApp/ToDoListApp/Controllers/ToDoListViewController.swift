//
//  ViewController.swift
//  ToDoListApp
//
//  Created by yumi on 2020/06/16.
//  Copyright © 2020 Yumi Takahashi. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // searchBarの入力部分の背景色を白にする
        searchBar.searchTextField.backgroundColor = UIColor.white
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let colorHex = selectedCategory?.color {
            // カテゴリーの名前をタイトルとして使う
            title = selectedCategory!.name
            
            // navBarの背景色を決める
            guard let navBar = navigationController?.navigationBar else {
                fatalError("Navigationcontroller does not exist.")
            }
            
            if let navBarColor = UIColor(hexString: colorHex) {
                
                navBar.backgroundColor = navBarColor
                
                // navBarのtitle以外の部分の色の変更
                navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
                
                // searchBarの背景色をnavBarと同じ色にする
                searchBar.barTintColor = navBarColor
                // searchBarのカーソル色をnavBarと同じ色にする
                searchBar.tintColor = navBarColor

            }
        }
        
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // もしtodoItemsがnilだったら1として扱う
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
        
            // 行数によってグラデーションになるように背景色を決める
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
                
                cell.backgroundColor = color
                // コントラストによってテキストの色を変更
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                // コントラストによってチェックマークの色を変更
                cell.tintColor = ContrastColorOf(color, returnFlat: true)
            }
            
            // 選択したTodoListにチェックマークをつける
            // すでにチェックマークがついていたらはずす
            // Ternary operatorを使ってみる
            // value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 選択したTodoListにチェックマークをつけるための準備
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    // doneはBoolなのでCellを選択した時にtrue→falese, false→trueにする
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        // TodoListをクリックした後はハイライトが消えるようにする
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        // SwipeしてDeleteButtonをクリックした時にDeleteできるようにする
        if let item = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write{
                    self.realm.delete(item)
                }
            } catch {
                print("Error deleting Item, \(error)")
            }
        }
    }
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // ユーザーがアラート内のAddItemボタンををクリックした時に起こること
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    
    }
    
    //MARK: - Model Manupulation Methods
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()

    }
}

//MARK: - Search bar Methods
extension ToDoListViewController: UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // searchButtonをクリックして検索をした際、Dateが古いものからフィルターがかかる
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // searchBarに何も入力されていないとき
        if searchBar.text?.count == 0 {
            loadItems()
            // 元の画面に戻す
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}


