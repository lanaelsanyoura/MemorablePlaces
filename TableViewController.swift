//
//  TableViewController.swift
//  MemorablePlaces
//
//  Created by Lana Sanyoura on 1/1/17.
//  Copyright © 2017 Lana Sanyoura. All rights reserved.
//

import UIKit
import CoreLocation

class TableViewController: UITableViewController {
    var memorablePlaces : [String :  String] =  [:] // dict of dictionaries
    var orderedAddress = [String]()
    var activeRow = -1
    @IBOutlet var table: UITableView!
    
    @IBAction func addPlace(_ sender: AnyObject) {
        activeRow = -1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        let userMem = UserDefaults.standard.object(forKey: "memorablePlaces")
        let orderedAdd = UserDefaults.standard.object(forKey: "orderedAddress")
        
        if userMem != nil {
            memorablePlaces = userMem as! [String: String]
            orderedAddress = orderedAdd as! [String]
        }
        table.reloadData()
        activeRow = -1
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orderedAddress.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = orderedAddress[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = table.cellForRow(at: indexPath)
        if cell?.textLabel?.text != nil {
            activeRow = indexPath.row
            performSegue(withIdentifier: "toMap", sender: nil)
            

        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMap"  {
            let map = segue.destination as! ViewController // destinationViewController is now called destination
            if activeRow > -1 {
                map.address = orderedAddress[activeRow]
                map.throughRow = true
                
            } else {
                map.throughRow = false
            }
            }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            memorablePlaces.removeValue(forKey: orderedAddress[indexPath.row])
            orderedAddress.remove(at: indexPath.row)
            UserDefaults.standard.setValue(memorablePlaces, forKey: "memorablePlaces")
            UserDefaults.standard.setValue(orderedAddress, forKey: "orderedAddress")
            table.deleteRows(at: [indexPath], with: .fade)
        }
          
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

