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
        lbl.font = UIFont(name: "Poppins-Bold", size: 36)
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
        tv.register(CustomVisitCellVC.self, forCellReuseIdentifier: "favoritesCell")
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
            tv.leading.equalToSuperview()
            tv.width.equalToSuperview()
            tv.height.equalToSuperview()
        })
    }
    
}

extension VisitsVC:UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favoritesCell", for: indexPath) as? CustomVisitCellVC else {
            fatalError("cell does not exist")
        }
        
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.visitCellViewModel = cellVM
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (219+16)
    }
    
//    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        // here navigation to placeDetail page will be implemented
//        navigationController?.pushViewController(SignUpVC(), animated: true)
//        print(indexPath.row)
//        return indexPath
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailVC()
        vc.viewModel.currentPlace = viewModel.favorites[indexPath.row]
        print("\(viewModel.favorites[indexPath.row]) resim")
        navigationController?.pushViewController(vc, animated: true)
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct VisitsVC_Preview: PreviewProvider {
    static var previews: some View{
        
        VisitsVC().showPreview()
    }
}
#endif
