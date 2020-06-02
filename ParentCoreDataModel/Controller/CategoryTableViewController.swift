//
//  ControllerTableViewController.swift
//  ParentCoreDataModel
//
//  Created by Furkan sakızcı on 6.07.2019.
//  Copyright © 2019 Furkan sakızcı. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var categoryItems = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        loadCategory()
       
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryItems.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToParent", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ParentCoreDataViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryItems[indexPath.row]
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let item = categoryItems[indexPath.row]
        cell.textLabel?.text = item.name
        
        
        return cell
    }
   
    
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Kategori ekle", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Kategori", style: .default) { (action) in
            
            let newItem = Category(context: self.context)
            if(textField.text?.count != 0){
            newItem.name = textField.text!
            self.categoryItems.append(newItem)
            
            self.saveCategory()
            }
            else{
               return
            }
            }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Doldur"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert,animated: true , completion: nil)
    }
    
    func saveCategory(){
        
        do{
           try context.save()
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadCategory(){
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do{
            categoryItems = try context.fetch(request)
        }catch{
            print(error)
        }
    }
    
}
