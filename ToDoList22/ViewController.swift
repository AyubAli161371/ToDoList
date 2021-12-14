//
//  ViewController.swift
//  ToDoList22
//
//  Created by Ayub Ali on 14/12/2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    // object of coredata of database
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: -  for Table
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
        
    }()
    
    private var models = [ToDoListItems]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "To Do List"
        
        view.addSubview(tableView)
        getAllItems()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(didTapAdd))
    }
    
    
    // MARK: - for alert and textfied to add new item
    @objc private func didTapAdd(){
        let alert = UIAlertController(title: "New Item ",
                                      message: "Enter new item",
                                      preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: {[weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else{
                return
            }
            self?.creatItems(name: text)
            
        }))
        present(alert,animated: true)
        
    }
    
    
    
    // MARK: -  for Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.name
        return cell
    }
    
    
    // MARK: - for select row
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = models[indexPath.row]
        
        let sheet  = UIAlertController(title: "Edit",
                                      message: "nill",
                                      preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Cancal", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            
            let alert = UIAlertController(title: "Edit Item ",
                                          message: "Edit your item",
                                          preferredStyle: .alert)
        
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.name
            alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: {[weak self] _ in
                guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else{
                    return
                }
                self?.updateItems(item: item, newName: newName)
                
            }))
            self.present(alert,animated: true)
            
        }))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {[weak self] _ in
            self?.deleteItems(item: item)
        }))
        present(sheet,animated: true)
    }
    
    
    
    // MARK: - core data
    func getAllItems()
    {
        do{
            models = try context.fetch(ToDoListItems.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch{
            //error
        }
    }

    func creatItems(name: String)
    {
       let newItems = ToDoListItems(context: context)
        newItems.name = name
        newItems.createdAt = Date()
        
        do{
            try context.save()
            getAllItems()
        }
        catch
        {
            
        }
    }
    
    func deleteItems(item: ToDoListItems)
    {
        context.delete(item)
        do{
            try context.save()
            getAllItems()
        }
        catch
        {
            
        }
    }
    func updateItems(item: ToDoListItems, newName: String)
    {
        item.name = newName
        do{
            try context.save()
            getAllItems()
        }
        catch
        {
            
        }
        
    }
}

