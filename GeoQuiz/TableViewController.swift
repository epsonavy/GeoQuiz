//
//  TableViewController.swift
//  GeoQuiz
//
//  Created by Pei Liu on 11/30/16.
//  Copyright © 2016 Pei Liu. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UIAlertViewDelegate  {
    
    var singleton : Singleton! = Singleton.sharedInstance
    var popUpMessage: UIAlertView = UIAlertView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popUpMessage.addButtonWithTitle("OK")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Singleton.sharedInstance.fourLocations.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("CapitalCell", forIndexPath: indexPath) as! CapitalViewCell
        
        let item = singleton.fourLocations[indexPath.row]
        cell.label.text = item

        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = singleton.fourLocations[indexPath.row]
        
        let title = "Capital of \(item)?"
        let message = "Are you sure this is correct?"
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        ac.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "Confirm", style: .Default , handler: {
            (action) -> Void in
            if item == self.singleton.currentPin?.hidetitle {
                print("Correct!")
                self.singleton.score = self.singleton.score + 1
                self.singleton.answerCorrect = true
                self.popUpMessage.title = "You got it right! Score + 1"
                self.popUpMessage.show()
                self.navigationController?.popToRootViewControllerAnimated(true)
            } else {
                print("Wrong!")
                self.popUpMessage.title = "You got the wrong Capital!"
                self.popUpMessage.show()
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        })
        ac.addAction(deleteAction)
        
        presentViewController(ac, animated: true, completion: nil)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

}
