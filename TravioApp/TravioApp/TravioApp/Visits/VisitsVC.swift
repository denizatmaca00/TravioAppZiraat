//
//
//  VisitsVC.swift
//  TravioApp
//
//  Created by Aydın Erol on 26.10.2023.
//
//

import UIKit

class VisitsVC: UIViewController {
    
    //MARK: -- Properties
    
    private lazy var viewModel: VisitsVM = {
        return VisitsVM()
    }()
    
    private lazy var lblHeader:UILabel = {
        let lbl = UILabel()
        lbl.text = "My Visits"
        lbl.font = .Fonts.pageHeader36.font
        lbl.textColor = UIColor(named: "textColorReversed")
        
        return lbl
    }()
    
    //MARK: -- Views
    
    private lazy var contentViewBig : UIView = {
        let view = AppView()
        return view
    }()
    
    private lazy var tableView:UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.backgroundColor = .clear
        tv.register(CustomVisitCell.self, forCellReuseIdentifier: CustomVisitCell.reuseIdentifier)
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
    
    // fetch data and refresh tableView each time view appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initVM()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //MARK: -- Component Actions
    
    
    //MARK: -- Private Methods
    func initVM(){
       
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.initFetch()
    }
    
    //MARK: -- UI Methods
    func setupViews() {
        // Add here the setup for the UI
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.view.addSubviews(lblHeader, contentViewBig)
        contentViewBig.addSubview(tableView)
        
        setupLayout()
    }
    
    func setupLayout() {
        // Add here the setup for layout
        lblHeader.snp.makeConstraints({l in
            l.top.equalToSuperview().offset(48)
            l.leading.equalToSuperview().offset(24)
            l.trailing.equalToSuperview()
            
        })
        
        contentViewBig.snp.makeConstraints({ cv in
            cv.leading.equalToSuperview()
            cv.trailing.equalToSuperview()
            cv.height.equalToSuperview().multipliedBy(0.8)
            cv.bottom.equalToSuperview()
            
        })
        
        tableView.snp.makeConstraints({ tv in
            tv.top.equalToSuperview()
            tv.leading.equalToSuperview()
            tv.trailing.equalToSuperview()
            tv.bottom.equalToSuperview()
            
        })
    }
}

extension VisitsVC:UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let count = viewModel.numberOfCells else {return 0}
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomVisitCell.reuseIdentifier, for: indexPath) as? CustomVisitCell else {
            fatalError("Cell does not exist")
        }
        
        let cellData = viewModel.cellViewModels[indexPath.section]
        cell.configure(data: cellData)
     
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let baseWidth = CGFloat(self.tableView.frame.width)
        let imageHeight = CGFloat(219)
        let imageWidth = CGFloat(344)
        let imageRatio = CGFloat(imageHeight / imageWidth)
        let cellSpacerHeight = CGFloat(16)
        let horizontalPadding = CGFloat(24 * 2)
        
        let relativeWidth = CGFloat(CGFloat(baseWidth - horizontalPadding) * imageRatio) + cellSpacerHeight
        
        return relativeWidth
    }
    
    /// Push to DetailVC related to cell data
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailVC()
        vc.viewModel.placeId = viewModel.favorites[indexPath.section].place_id
        viewModel.getaVisitbyID()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0){
            return 25-6
        } else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.tabBarController?.tabBar.frame.size.height ?? 83.0
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct VisitsVC_Preview: PreviewProvider {
    static var previews: some View{
        
        VisitsVC().showPreview()
        CustomVisitCell().showPreview()
    }
}
#endif
