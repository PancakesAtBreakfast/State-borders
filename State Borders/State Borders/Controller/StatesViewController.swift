//
//  StatesViewController.swift
//  State Borders
//
//  Created by Niso on 10/16/19.
//  Copyright © 2019 Niso. All rights reserved.
//

import UIKit
import Alamofire

class StatesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedAlphabetic: UISegmentedControl!
    @IBOutlet weak var segmentedAreaSize: UISegmentedControl!
    
    // MARK: - Properties
    private var statesList = [State]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData { (states: [State]) in
            self.tableView.reloadData()
        }
        
    }
    
    // MARK: - Get Data for all states
    private func getData(completion: @escaping ([State]) -> Void) {
        Alamofire.request(ApiService.getAllStates)
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching state data base: \(String(describing: response.result.error))")
                    return
                }
                
                guard let value = response.result.value as? [Any] else {
                    print("Error while fetching state: \(String(describing: response.result.error))")
                    return
                }
                
                self.statesData(value)
                
                completion(self.statesList)
        }
    }
    
    private func statesData(_ jsonArray: [Any]) {
        self.statesList = jsonArray.map({ State($0 as! NSDictionary) })
    }
    
    // Sort alphabetically
    @IBAction func segmentedAlphabeticTapped(_ sender: Any) {
        let segmentedIndex = segmentedAlphabetic.selectedSegmentIndex
        switch segmentedIndex {
        case 1:
            statesList = statesList.sorted { $0.name > $1.name }
            self.tableView.reloadData()
        default:
            statesList = statesList.sorted { $0.name < $1.name }
            self.tableView.reloadData()
        }
    }
    
    // Sort area
    @IBAction func segmentedAreaSizeTapped(_ sender: Any) {
        let segmentedIndex = segmentedAreaSize.selectedSegmentIndex
        switch segmentedIndex {
        case 1:
            // Small
            statesList = statesList.sorted { $0.area < $1.area }
            // Remove states without area size
            for _ in statesList {
                if let index = statesList.firstIndex(where: {$0.area == 0.0}) {
                    statesList.remove(at: index)
                }
            }
            self.tableView.reloadData()
        default:
            // Big
            statesList = statesList.sorted { $0.area > $1.area }
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedRow = tableView.indexPathForSelectedRow
        
        if let indexPath = selectedRow {
            if let bordersScreen = segue.destination as? BordersViewController {
                bordersScreen.selectedState = statesList[indexPath.row]
            }
            
        }
    }
}

// MARK: - TableView
extension StatesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if statesList.count != 0 {
            return statesList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "statesCell", for: indexPath)
        let state = statesList[indexPath.row]
        
        cell.textLabel?.text = state.name
        cell.detailTextLabel?.text = state.nativeName
        
        return cell
    }
    
}
