//
//  ObjectSelection.swift
//  ARchitectureWithUI
//
//  Created by An Nguyen on 7/22/18.
//  Copyright © 2018 An Nguyen. All rights reserved.
//

import UIKit

class ObjectSelectionView: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var objects: [Object] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        objects = createArray()
        
        // Set delegate for tableView
        tableView.delegate = self
        tableView.dataSource = self
        
        //tableView.estimatedRowHeight = 200
        //tableView.rowHeight = UITableViewAutomaticDimension
    }

    func createArray() -> [Object] {
        var tempArray: [Object] = []
        
        let object1 = Object(image: #imageLiteral(resourceName: "house"), label: "house")
        let object2 = Object(image: #imageLiteral(resourceName: "building_04"), label: "building_04")
        
        tempArray.append(object1)
        tempArray.append(object2)
        
        return tempArray
    }
}

extension ObjectSelectionView: UITableViewDataSource, UITableViewDelegate {
    // Return total number of rows. Based on the array of objects
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    // Populate row cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        // Getting all the object variable
        let object = objects[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ObjectCell") as! ObjectCell
        
        // Calling func from Object Cell to generate the object
        cell.setObject(object: object)
        
        return cell
    }
    
    // Action when a row is clicked 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        <#code#>
    }
/**
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentImage = objects[indexPath.row].image
        let imageCrop = currentImage.getCropRatio()
        return tableView.frame.width / imageCrop
    }
}
*/
 
// Extension to give the correct size to the table cell
/**
extension UIImage {
    func getCropRatio() -> CGFloat {
        // Calculate the ratio of the image so that ratio can be used to dynamically change the table cell to fit the objects' image
        var widthRatio = self.size.width / self.size.height
        return widthRatio
    }
*/
}

