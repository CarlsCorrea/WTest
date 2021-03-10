//
//  ViewController.swift
//  WTest
//
//  Created by Carlos Correa on 06/03/2021.
//

import UIKit

final class PostalCodeViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    let activityIndicator = UIActivityIndicatorView()
    let searchBar = UISearchBar()

    private let viewModel: PostalCodeViewModel
    private var postalCodes: [PostalCode] = []
    
    init(viewModel: PostalCodeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.viewWillApper()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "PostalCodeCell", bundle: nil), forCellReuseIdentifier: "PostalCodeCell")
        
        activityIndicator.style = .large
        self.view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        DispatchQueue.main.async{
            self.activityIndicator.startAnimating()
        }
        
        viewModel.viewDidLoad(delegate: self)
    }
    
    func showDownloadError() {
        print("error")
    }
    
}

extension PostalCodeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postalCodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostalCodeCell", for: indexPath)
        (cell as? PostalCodeCell)?.prepareCell(with: postalCodes[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? PostalCodeCell)?.reuse()
    }
}

extension PostalCodeViewController: PostalCodeViewModelDelegate {
    func setupSearchBar(title: String) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = title
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func tableViewReloadData() {
        DispatchQueue.main.async{
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
        }
    }
    
    func setPostalCodes(postalCodes: [PostalCode]) {
        self.postalCodes = postalCodes
    }
    
    func setTitle(_ title: String) {
        self.title = title
    }
}

extension PostalCodeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchBarSearchButtonClicked(inputText: searchBar.text )
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchBarSearchButtonClicked(inputText: searchBar.text )
    }
}
