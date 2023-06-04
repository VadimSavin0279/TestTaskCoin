//
//  CoinsViewController.swift
//  TestTaskCoin
//
//  Created by 123 on 03.06.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CoinsDisplayLogic: AnyObject {
    func displayData(viewModel: Coins.Model.ViewModel.ViewModelData)
}

class CoinsViewController: UIViewController, CoinsDisplayLogic {
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.searchTextField.backgroundColor = .clear
        searchController.searchBar.searchTextField.layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor
        searchController.searchBar.searchTextField.layer.borderWidth = 1
        searchController.searchBar.searchTextField.layer.cornerRadius = 12
        searchController.searchBar.searchTextField.clearButtonMode = .never
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = ""
        searchController.searchBar.isTranslucent = false
        searchController.searchBar.searchTextField.textColor = .white
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gray]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes , for: .normal)
        return searchController
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 72
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.description())
        tableView.backgroundView = UIImageView(image: UIImage(named: "bg"))
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let searchButton = UIButton(imageName: "search")
    
    private let titleLable: UILabel = {
        let titleLable = UILabel()
        titleLable.attributedText = NSAttributedString(string: "Trending Coins", attributes: [NSAttributedString.Key.kern: 0.48])
        titleLable.font = .systemFont(ofSize: 30, weight: .semibold)
        titleLable.textColor = .white
        return titleLable
    }()
    private let refresh = UIRefreshControl()
    
    var interactor: CoinsBusinessLogic?
    var router: (NSObjectProtocol & CoinsRoutingLogic)?
    
    private var viewModel = CoinsViewModel(allData: [], currentData: []) {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var isLoading = false
    private var isRefreshing = false
    private var isSearching = false {
        didSet {
            if isSearching {
                viewModel.currentData = []
            } else {
                viewModel.currentData = viewModel.allData
            }
        }
    }
    private var timer: Timer?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        let viewController        = self
        let interactor            = CoinsInteractor()
        let presenter             = CoinsPresenter()
        let router                = CoinsRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        setupUI()
        addTargets()
        interactor?.makeRequest(request: .getCoins)
    }
    
    func displayData(viewModel: Coins.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .dispalyCoins(let coins):
            if isSearching {
                showCoinsFromSearch(coins: coins)
            } else {
                self.viewModel.allData.append(contentsOf: coins)
                self.viewModel.currentData = self.viewModel.allData
            }
        case .displayRefreshingCoins(let coins):
            self.viewModel.allData = coins
            self.viewModel.currentData = self.viewModel.allData
        case .error:
            break
        }
        DispatchQueue.main.async {
            self.isLoading = false
            self.refresh.endRefreshing()
        }
    }
    
    private func addTargets() {
        searchButton.addTarget(self, action: #selector(showSearchBar), for: .allEvents)
        refresh.addTarget(self, action: #selector(refreshTableView), for: .allEvents)
    }
    
    private func showCoinsFromSearch(coins: [ResponseDataModel.CoinModel]) {
        DispatchQueue.main.async {
            if self.searchController.searchBar.text?.isEmpty ?? true {
                self.viewModel.currentData = []
            } else {
                self.viewModel.currentData = coins
            }
        }
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        tableView.addSubview(refresh)
        tableView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            searchButton.heightAnchor.constraint(equalToConstant: (navigationController?.navigationBar.bounds.height ?? 4) - 4),
            searchButton.widthAnchor.constraint(equalTo: searchButton.heightAnchor, multiplier: 1)
        ])
        
        navigationController?.navigationBar.barStyle = .black
        showTitleLableAndSearchButton()
    }
    
    private func showTitleLableAndSearchButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLable)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchButton)
        navigationItem.rightBarButtonItem?.customView?.isHidden = false
    }
    
    private func setupDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        searchController.searchBar.delegate = self
    }
    
    @objc private func showSearchBar(sender: UIButton) {
        isSearching = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchController.searchBar)
        navigationItem.rightBarButtonItem?.customView?.isHidden = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { _ in
            self.searchController.searchBar.searchTextField.becomeFirstResponder()
            self.timer?.invalidate()
        })
    }
    
    @objc private func refreshTableView() {
        if !isLoading {
            if isSearching {
                guard let text = searchController.searchBar.text, !text.isEmpty else {
                    refresh.endRefreshing()
                    return
                }
                isLoading = true
                interactor?.makeRequest(request: .search(text))
            } else {
                isLoading = true
                interactor?.makeRequest(request: .refreshing)
            }
        }
    }
}

extension CoinsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.description(), for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        cell.setupCell(model: viewModel.currentData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.allData.count - 3 && !isLoading && !isSearching {
            isLoading = true
            interactor?.makeRequest(request: .getCoins)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(DetailViewController(viewModel: viewModel.currentData[indexPath.row]), animated: true)
    }
}

extension CoinsViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        showTitleLableAndSearchButton()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        if !searchText.isEmpty {
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { _ in
                self.isLoading = true
                self.interactor?.makeRequest(request: .search(searchText))
            })
        } else {
            self.viewModel.currentData = []
        }
    }
}
