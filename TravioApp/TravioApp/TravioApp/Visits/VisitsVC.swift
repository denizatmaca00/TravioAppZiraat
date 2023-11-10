//
//
//  VisitsVC.swift
//  TravioApp
//
//  Created by Aydın Erol on 26.10.2023.
//
//
import UIKit
//import TinyConstraints
import SnapKit

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
        let view = UIView()
        view.backgroundColor = UIColor(named: "viewBackgroundColor")
        view.clipsToBounds = true
        view.layer.cornerRadius = 80
        view.layer.maskedCorners = [.layerMinXMinYCorner]
        
        return view
    }()
    
    private lazy var tableView:UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.backgroundColor = UIColor(named: "viewBackgroundColor")
        tv.register(CustomVisitCellVC.self, forCellReuseIdentifier: CustomVisitCellVC.reuseIdentifier)
        tv.delegate = self
        tv.dataSource = self
        
//        let refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
//        tv.refreshControl = refreshControl
        return tv
    }()
    @objc func refreshTableView(sender: UIRefreshControl){
        tableView.reloadData()

    }
    
    //MARK: -- Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        initVM()
        
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
        
        //let limits = self.view.safeAreaLayoutGuide.snp
        
        // Add here the setup for layout
        lblHeader.snp.makeConstraints({l in
            //l.top.equalTo(limits.top).offset(0)
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
            tv.top.equalToSuperview().offset(45)
            tv.leading.equalToSuperview()//.offset(24)
            tv.trailing.equalToSuperview()//.inset(24)
            tv.height.equalToSuperview()
        })
    }
    
}

extension VisitsVC:UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomVisitCellVC.reuseIdentifier, for: indexPath) as? CustomVisitCellVC else {
            fatalError("cell does not exist")
        }
        let cellData = viewModel.cellViewModels[indexPath.row]
        cell.configure(data: cellData)
        //viewModel.reloadTableViewClosure?()
     
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = viewModel.numberOfCells else {return 0}
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return (tableView.frame.width - (24 * 2)) * 0.6377 + 16
        //return (219+16)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // here navigation to placeDetail page will be implemented
        //navigationController?.pushViewController(DetailVC(), animated: true)
        print(indexPath.row)
        return indexPath
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       //tıklndığının placeidsini
//        let vc = DetailVC()
////        vc.viewModel.placeIdtest = viewModel.favorites[indexPath.row].place_id
////        viewModel.getaVisitbyID()
//        navigationController?.pushViewController(vc, animated: true)
        
        
//        let vc = DetailVC()
//        let vcc = MapVC()
      //  let vm = vc.DetailVM()
//        vc.viewModel.placeIdtest = vcc.viewModel.places[indexPath.row].id
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // refresh table when scrolled
        //        initVM()
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct VisitsVC_Preview: PreviewProvider {
    static var previews: some View{
        
        VisitsVC().showPreview()
        CustomVisitCellVC().showPreview()
    }
}
#endif
