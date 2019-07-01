//
//  RestaurantTableViewController.swift
//  Nerde Yesem
//
//  Created by umur yavuz on 28.06.2019.
//  Copyright © 2019 umur yavuz. All rights reserved.
//

import UIKit

protocol ListActions{
    func didTapCell(_ viewModel: RestaurantListViewModel)
}
class RestaurantTableViewController: UITableViewController {

    var viewModels = [RestaurantListViewModel](){
        didSet {
            tableView.reloadData()
        }
    }
    
    var delegate: ListActions?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModels.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantTableViewCell

        let vm = viewModels[indexPath.row]
        cell.configure(with: vm)

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vm = viewModels[indexPath.row]
        delegate?.didTapCell(vm)
    }

}
