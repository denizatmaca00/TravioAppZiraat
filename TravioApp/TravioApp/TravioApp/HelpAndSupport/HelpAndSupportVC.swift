//
//
//  HelpAndSupportVC.swift
//  TravioApp
//
//  Created by Aydın Erol on 2.11.2023.
//
//

import UIKit
import SnapKit

class HelpAndSupportVC: UIViewController {
    
    //MARK: -- Properties
    
    var lastSelectedIndexPath: IndexPath?
    
    private let viewModel:HelpAndSupportVM = {
        return HelpAndSupportVM()
    }()
    
    private lazy var lblHeader:UILabel = {
        let lbl = UILabel()
        lbl.text = "Help&Support"
        lbl.textColor = .white
        lbl.font = .Fonts.pageHeader32.font
        return lbl
    }()
    
    private lazy var lblPageTitle:UILabel = {
        let lbl = UILabel()
        lbl.text = "FAQ"
        lbl.textColor = UIColor(named: "backgroundColor")
        lbl.font = .Fonts.header24.font
        return lbl
    }()
    
    private lazy var leftBarButton: UIButton = {
        let leftBarButton = UIButton()
        leftBarButton.tintColor = .white
        leftBarButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        leftBarButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return leftBarButton
    }()
    
    //MARK: -- Views
    
    private lazy var contentViewBig: AppView = {
        let view = AppView()
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 73*4
        tv.separatorStyle = .none
        tv.backgroundColor = .clear
        
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
        
        tableView.allowsMultipleSelection = false
        
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        
        self.view.addSubviews(lblHeader, contentViewBig, leftBarButton)
        
        contentViewBig.addSubviews(lblPageTitle, tableView)
        
        setupLayout()
    }
    
    func setupLayout() {
        
        let startY = self.view.bounds.origin.y + 50
        
        // Add here the setup for layout
        contentViewBig.snp.makeConstraints ({ view in
            view.height.equalToSuperview().multipliedBy(0.8)
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.bottom.equalToSuperview()
            
        })
        
        tableView.snp.makeConstraints({ tv in
            tv.top.equalToSuperview()
            tv.leading.equalToSuperview()
            tv.trailing.equalToSuperview()
            tv.bottom.equalToSuperview()
            
        })
        
        lblHeader.snp.makeConstraints({lbl in
            lbl.top.equalToSuperview().offset(startY)
            lbl.leading.equalToSuperview().offset(72)
            
        })
        
        leftBarButton.snp.makeConstraints({btn in
            btn.width.equalTo(24)
            btn.height.equalTo(21)
            btn.centerY.equalTo(lblHeader)
            btn.leading.equalToSuperview().offset(24)
            
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
        
        let cellViewModel = viewModel.getCellViewModel(idx: indexPath)
        
        cell.dropCellViewModel = cellViewModel
        cell.dropCellViewModel?.isExpanded = false
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        /// Create animation for cell
        self.tableView.performBatchUpdates(nil, completion: nil)
        
        switch self.lastSelectedIndexPath {
        case nil:
            /// case to select cell
            self.tableView.beginUpdates()
            makeCellSelected(in: tableView, on: indexPath)
            self.lastSelectedIndexPath = indexPath
            self.tableView.endUpdates()
            
        case indexPath:
            /// case to deselect cell
            self.tableView.beginUpdates()
            makeCellUnselected(in: tableView, on: self.lastSelectedIndexPath!)
            self.lastSelectedIndexPath = nil
            self.tableView.endUpdates()
            
        default:
            /// case when another cell is already expanded and it is not the last clicked cell
            self.tableView.beginUpdates()
            self.lastSelectedIndexPath = indexPath
            makeCellSelected(in: tableView, on: self.lastSelectedIndexPath!)
            self.lastSelectedIndexPath = nil
            self.tableView.endUpdates()
        }
    }
    
    func makeCellSelected(in tableView: UITableView, on indexPath: IndexPath){
        
        if let cell = tableView.cellForRow(at: indexPath) as? DropCell{
            if (indexPath.row == 0) || (indexPath.row == 1) || (indexPath.row == 2) {
                cell.toExpand.toggle()
            }
        }
    }
    
    func makeCellUnselected(in tableView: UITableView, on indexPath: IndexPath){
        if let cell = tableView.cellForRow(at: indexPath) as? DropCell{
            cell.toExpand.toggle()
        }
    }
    
    /// On deselect cell
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let lastIdx = lastSelectedIndexPath else {return}
        
        /// Create animation for cell
        self.tableView.performBatchUpdates(nil)
        self.tableView.beginUpdates()
        makeCellUnselected(in: tableView, on: self.lastSelectedIndexPath!)
        self.lastSelectedIndexPath = nil
        self.tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 85-26
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
