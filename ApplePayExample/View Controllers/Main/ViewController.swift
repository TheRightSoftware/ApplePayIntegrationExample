//
//  ViewController.swift
//  ApplePayExample
//
//  Created by Farrukh Javeid on 06/05/2019.
//  Copyright © 2019 The Right Software. All rights reserved.
//

import UIKit

struct Fruit {
    let name: String!
    let image: String!
    let price: Int!
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Properties
    fileprivate var fruits: [Fruit]!
    fileprivate var selectedFruit: Fruit!
    
    //MARK:- UIViewController Lifecycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
        //data source array
        fruits = [Fruit]()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //loading the content
        loadJsonFileContents()
        tableView.reloadData()
    }

     //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "showFruitDetails" {
            
            let detailController = segue.destination as! DetailsViewController
            detailController.selectedFruit = selectedFruit
        }
    }

    //MARK:- Helper Methods
    fileprivate func loadJsonFileContents() {
        
        let asset = NSDataAsset(name: "fruits", bundle: Bundle.main)
        if let fruitsDictionary = try? JSONSerialization.jsonObject(with: asset!.data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] {
            
            if let fruitsArray = fruitsDictionary["fruits"] as? [[String: Any]] {
                
                for currentFruitDictionary in fruitsArray {
                    
                    //name
                    var fruitName = ""
                    if let name = currentFruitDictionary["name"] as? String {
                        fruitName = name
                    }
                    
                    //image
                    var fruitImage = ""
                    if let image = currentFruitDictionary["image"] as? String {
                        fruitImage = image
                    }

                    //price
                    var fruitPrice = 0
                    if let price = currentFruitDictionary["price"] as? Int {
                        fruitPrice = price
                    }

                    //model
                    let fruit = Fruit(name: fruitName, image: fruitImage, price: fruitPrice)
                    fruits.append(fruit)
                }
            }
        }
    }
}

extension ViewController {
    
    //MARK:- UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fruits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FruitsTableViewCell", for: indexPath) as? FruitsTableViewCell {
            
            cell.selectionStyle = .blue
            cell.initCellWitFruit(fruit: fruits[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
    //MARK:- UITableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //making the segue to the detail page
        selectedFruit = fruits[indexPath.row]
        performSegue(withIdentifier: "showFruitDetails", sender: nil)
    }
}
