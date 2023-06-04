//
//  DetailViewController.swift
//  TestTaskCoin
//
//  Created by 123 on 03.06.2023.
//

import Foundation
import UIKit

protocol DetailDisplayLogic: AnyObject {
    func displayData(viewModel: Detail.Model.ViewModel.ViewModelData)
}

class DetailViewController: UIViewController, DetailDisplayLogic {
    private let lineView1 = LineView()
    private let lineView2 = LineView()
    private let backButton = UIButton(imageName: "back")
    
    private var viewModel: ResponseDataModel.CoinModel
    
    var interactor: DetailBusinessLogic?
    var router: (NSObjectProtocol & DetailRoutingLogic)?
    
    init(viewModel: ResponseDataModel.CoinModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setup()
        interactor?.makeRequest(request: .processViewModel(viewModel))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let viewController        = self
        let interactor            = DetailInteractor()
        let presenter             = DetailPresenter()
        let router                = DetailRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBackButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLine(view: lineView1)
        setupLine(view: lineView2)
    }
    
    func displayData(viewModel: Detail.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayData(let coinModel):
            self.viewModel = coinModel
        }
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = viewModel.name
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        
        let horSVForButtonAndTitle = UIStackView(arrangedSubviews: [backButton, titleLabel])
        horSVForButtonAndTitle.axis = .horizontal
        horSVForButtonAndTitle.spacing = 16
        
        NSLayoutConstraint.activate([
            backButton.heightAnchor.constraint(equalToConstant: (navigationController?.navigationBar.bounds.height ?? 4) - 4),
            backButton.widthAnchor.constraint(equalTo: backButton.heightAnchor, multiplier: 1)
        ])
        
        navigationController?.navigationBar.barStyle = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: horSVForButtonAndTitle)
    }
    
    private func setupLine(view: UIView) {
        let lineLayer2 = CALayer()
        lineLayer2.frame = CGRect(x: 0, y: lineView2.bounds.height / 4, width: 1, height: view.bounds.height / 2)
        lineLayer2.backgroundColor = UIColor.white.withAlphaComponent(0.1).cgColor
        view.layer.addSublayer(lineLayer2)
    }
    
    private func setupUI() {
        let bgImageView = UIImageView()
        view.addSubview(bgImageView)
        bgImageView.image = UIImage(named: "bg")
        bgImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bgImageView.topAnchor.constraint(equalTo: view.topAnchor),
            bgImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bgImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bgImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let svForMaketCap = UIStackView(partName: "Market Cap", statisticText: viewModel.marketCapUsd ?? "")
        let svForSupply = UIStackView(partName: "Supply", statisticText: viewModel.supply ?? "")
        let svForVolume = UIStackView(partName: "Volume 24Hr", statisticText: viewModel.volumeUsd24Hr ?? "")
        
        let horSVForStatistic = UIStackView(arrangedSubviews: [svForMaketCap, lineView2, svForSupply, lineView1, svForVolume])
        horSVForStatistic.distribution = .equalSpacing
        
        let priceLabel = UILabel(text: viewModel.priceUsd, textColor: .white, font: .systemFont(ofSize: 24))
        let percentLabel = UILabel(text: viewModel.changePercent24Hr ?? "", textColor: .green, font: .systemFont(ofSize: 14))
        if viewModel.changePercent24Hr?.first == "-" {
            percentLabel.textColor  = UIColor(named: "percentageRedColor")
        } else {
            percentLabel.textColor = UIColor(named: "percentageGreenColor")
        }
        
        let horSVForPrice = UIStackView(arrangedSubviews: [priceLabel, percentLabel])
        horSVForPrice.axis = .horizontal
        horSVForPrice.spacing = 10
        
        horSVForStatistic.translatesAutoresizingMaskIntoConstraints = false
        horSVForPrice.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(horSVForStatistic)
        view.addSubview(horSVForPrice)
        
        NSLayoutConstraint.activate([
            horSVForPrice.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            horSVForPrice.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            horSVForStatistic.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            horSVForStatistic.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            horSVForStatistic.topAnchor.constraint(equalTo: horSVForPrice.topAnchor, constant: 40)
        ])
        
        setupNavigationBar()
    }
    
    private func setupBackButton() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        backButton.addTarget(self, action: #selector(backAction), for: .allEvents)
    }
    
    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

extension DetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
