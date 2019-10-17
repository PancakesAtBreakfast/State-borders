//
//  BordersViewController.swift
//  State Borders
//
//  Created by Niso on 10/16/19.
//  Copyright © 2019 Niso. All rights reserved.
//

import UIKit
import Alamofire

class BordersViewController: UIViewController {
    
    @IBOutlet weak var stateName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private var borderStatesList = [State]()
    var selectedState: State?
    private var borderState = [State]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set state name title
        if let stateNameTitle = selectedState?.name {
            stateName.text = stateNameTitle
        }
        
        loadBorders()
        
    }
    
    private func loadBorders() {
        
        guard let stateBorders = selectedState?.borders as? [String] else { return }
        
        if stateBorders.count != 0 {
            for stateId in stateBorders {
                getBordersData(stateID: stateId) { [weak self] (statesBordering: [State]) in
                    guard let strongSelf = self else { return }
                    
                    strongSelf.borderState = statesBordering
                    strongSelf.tableView.dataSource = self
                    strongSelf.tableView.reloadData()
                }
            }
        } else {
            self.tableView.dataSource = self
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Get Data for state borders
    private func getBordersData(stateID: String, completion: @escaping ([State]) -> Void) {
        Alamofire.request(ApiService.getStatesBorders(stateID: stateID))
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching state borders data base: \(String(describing: response.result.error))")
                    return
                }
                
                guard let value = response.result.value as? NSDictionary else {
                    print("Error while fetching state borders: \(String(describing: response.result.error))")
                    return
                }
                
                self.statesData(value)
                
                completion(self.borderStatesList)
        }
    }
    
    private func statesData(_ jsonDictionary: NSDictionary) {
        let name = jsonDictionary["name"] as? String ?? ""
        let nativeName = jsonDictionary["nativeName"] as? String ?? ""
        let area = jsonDictionary["area"] as? Double ?? 0.0
        let borders = jsonDictionary["borders"] as? NSArray ?? []
        let state = State(name: name, nativeName: nativeName, area: area, borders: borders)
        self.borderStatesList.append(state)
    }

}

// MARK: - TableView
extension BordersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if borderState.count != 0 {
            return borderState.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bordersCell", for: indexPath)
        
        cell.textLabel?.text = borderState[indexPath.row].name
        cell.detailTextLabel?.text = borderState[indexPath.row].nativeName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if borderState.count == 0 {
            return "This state does not border with any state"
        }
        return ""
    }
    
}
