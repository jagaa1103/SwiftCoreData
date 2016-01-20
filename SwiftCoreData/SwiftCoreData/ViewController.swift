//
//  ViewController.swift
//  SwiftCoreData
//
//  Created by Enkhjargal Gansukh on 1/19/16.
//  Copyright © 2016 Enkhjargal Gansukh. All rights reserved.
//

import UIKit
import CoreData

class tableViewController: UITableViewController {

    var listItems = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("addItem"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.fetchData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        let item = listItems[indexPath.row]
        cell.textLabel?.text = item.valueForKey("item") as? String
        
        return cell
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler: { (action: UITableViewRowAction!, indexPath: NSIndexPath) -> Void in
            self.deleteItem(indexPath.row)
        })
        
        return [deleteAction]
    }
    
    
    func addItem(){
        print("Add Button Clicked")
        let confirmView = UIAlertController(title: "Confirm View", message: "Add your Item", preferredStyle: .Alert)
        let confirmAction = UIAlertAction(title: "Add Item", style: UIAlertActionStyle.Default, handler: ({
            (_) in
            
                if let field = confirmView.textFields![0] as? UITextField{
                    self.saveItem(field.text!)
                    self.tableView.reloadData()
                }
            
            }))
        let cancelAction =  UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:nil)
        
        confirmView.addTextFieldWithConfigurationHandler({
            (textField) in
            textField.placeholder = "Insert Item..."
        })
        
        confirmView.addAction(confirmAction)
        confirmView.addAction(cancelAction)
        self.presentViewController(confirmView, animated: true, completion: nil)
    }
    
    func saveItem(insert_item: String){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("ListItems", inManagedObjectContext: managedContext)
        let item = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        item.setValue(insert_item, forKey: "item")
        do{
            try managedContext.save()
            listItems.append(item)
        }catch{
            print("error")
        }
    }
    
    func fetchData(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "ListItems")
        do{
            let results = try managedContext.executeFetchRequest(fetchRequest)
            listItems = results as! [NSManagedObject]
        }catch{
            print("error in Fetch")
        }
    }
    
    func deleteItem(index: Int){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        managedContext.deleteObject(listItems[index])
        listItems.removeAtIndex(index)
        self.tableView.reloadData()
    }

}

