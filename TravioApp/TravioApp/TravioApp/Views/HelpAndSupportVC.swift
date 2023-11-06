//
//
//  HelpAndSupportVC.swift
//  TravioApp
//
//  Created by Aydın Erol on 2.11.2023.
//
//
import UIKit
import TinyConstraints
import SnapKit

class HelpAndSupportVC: UIViewController {
    
    //MARK: -- Properties
    
    private let viewModel:HelpAndSupportVM = {
        return HelpAndSupportVM()
    }()
    
    private lazy var lblHeader:UILabel = {
        let lbl = UILabel()
        lbl.text = "Help&Support"
        lbl.textColor = .white
        lbl.font = UIFont(name: "Poppins-Bold", size: 32)
        return lbl
    }()
    
    private lazy var lblPageTitle:UILabel = {
        let lbl = UILabel()
        lbl.text = "FAQ"
        lbl.textColor = UIColor(named: "backgroundColor")
        lbl.font = UIFont(name: "Poppins-SemiBold", size: 24)
        return lbl
    }()
    
    private lazy var leftBarButton: UIBarButtonItem = {
        let leftBarButton = UIBarButtonItem()
        leftBarButton.tintColor = .white
        leftBarButton.image = UIImage(named: "leftArrow")
        leftBarButton.target = self
        leftBarButton.action = #selector(backButtonTapped)
        return leftBarButton
    }()
    
    //MARK: -- Views
    
    private lazy var contentViewBig: UIView = {
       let view = UIView()
       view.backgroundColor = UIColor(named: "viewBackgroundColor")
       view.clipsToBounds = true
       view.layer.cornerRadius = 80
       view.layer.maskedCorners = [.layerMinXMinYCorner]
       return view
   }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 73*4
        tv.separatorStyle = .none
        
        tv.register(DropCell.self, forCellReuseIdentifier: DropCell.reuseIdentifier)
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    //MARK: -- Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        initVM()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let bottomSpace: CGFloat = 10.0
        self.tableView.frame = self.tableView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: bottomSpace, right: 0))
    }
    
    //MARK: -- Component Actions
    
    @objc func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: -- Private Methods
    
    func initVM(){
       
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.fetchData()
    }
    
    //MARK: -- UI Methods
    
    func setupViews() {
        // Add here the setup for the UI
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        self.view.addSubviews(lblHeader, contentViewBig)
        contentViewBig.addSubviews(lblPageTitle, tableView)
        
        setupLayout()
    }
    
    func setupLayout() {
        
//        let limits = self.view.safeAreaLayoutGuide.snp
//        self.navigationItem.titleView?.layer
        let startY = self.view.bounds.origin.y + 50
        
        // Add here the setup for layout
        contentViewBig.snp.makeConstraints ({ view in
            view.height.equalToSuperview().multipliedBy(0.8)
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.bottom.equalToSuperview()
            
        })
        
        tableView.snp.makeConstraints({ tv in
            tv.top.equalToSuperview().offset(120)
            tv.leading.equalToSuperview().offset(24)
            tv.trailing.equalToSuperview().offset(-24)
            tv.bottom.equalToSuperview()
            
        })
        
        lblHeader.snp.makeConstraints({lbl in
            lbl.top.equalToSuperview().offset(startY)
            lbl.leading.equalToSuperview().offset(72)
            
        })
        
        lblPageTitle.snp.makeConstraints({ lbl in
            lbl.top.equalToSuperview().offset(44)
            lbl.leading.equalToSuperview().offset(24)
            
        })
    }
}

extension HelpAndSupportVC:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DropCell.reuseIdentifier, for: indexPath) as? DropCell else{
            fatalError("cell does not exist")}
//        guard let cell = tableView.cellForRow(at: indexPath) as? DropCell else { fatalError("cell does not exist") }
        let cellViewModel = viewModel.getCellViewModel(idx: indexPath)
        cell.dropCellViewModel = cellViewModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // animasyon
        self.tableView.performBatchUpdates(nil)
        
        guard let faqItem = tableView.cellForRow(at: indexPath) as? DropCell else {return}
        faqItem.dropCellViewModel!.isExpanded.toggle()
        //tableView.rowHeight = 72
//        let content = viewModel.getCellViewModel(idx: indexPath)
        print(indexPath.row)
//        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        guard let cell = tableView.cellForRow(at: indexPath) as? DropCell else{
//            fatalError("cell does not exist")
//        }
//        //        cell.hideDetailView()
//        tableView.rowHeight = 72
//        tableView.reloadRows(at: [indexPath], with: .automatic)
//        print(indexPath)
//        
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
        return UITableView.automaticDimension
    }
    
    
   
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let verticalPadding:CGFloat = 8
//        
//        let maskLayer = CALayer()
//        maskLayer.backgroundColor = UIColor.black.cgColor
//        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
//        cell.layer.mask = maskLayer
//        tableView.contentInset.bottom = -verticalPadding/2
//        tableView.contentInset.top = -verticalPadding/2
//    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = .green //UIColor(named: "viewBackgroundColor")

        return header
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        12
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct HelpAndSupportVC_Preview: PreviewProvider {
    static var previews: some View{
        
        HelpAndSupportVC().showPreview().ignoresSafeArea(.all)
    }
}
#endif
