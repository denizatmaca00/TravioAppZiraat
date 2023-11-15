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
    
    var expandedIndexPaths:[IndexPath] = [IndexPath]()
    var selectedIndexPath: IndexPath = IndexPath(row: 0, section: 0)
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
    
//    private lazy var leftBarButton: UIBarButtonItem = {
//        let leftBarButton = UIBarButtonItem()
//        leftBarButton.tintColor = .white
//        leftBarButton.image = UIImage(named: "leftArrow")
//        leftBarButton.target = self
//        leftBarButton.action = #selector(backButtonTapped)
//        return leftBarButton
//    }()
    
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
        //        tv.allowsSelection = true
        //        tv.allowsMultipleSelection = false
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    
    //MARK: -- Component Actions
    
    @objc func backButtonTapped(){
        print("annen")
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
        
        //        tableView.allowsSelection = true
        //        tableView.allowsMultipleSelection = false
        
        
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        
        //self.navigationItem.leftBarButtonItem = leftBarButton
        
        self.view.addSubviews(lblHeader, contentViewBig)
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
            tv.top.equalToSuperview().offset(85)
            tv.leading.equalToSuperview().offset(24)
            tv.trailing.equalToSuperview().offset(-24)
            tv.bottom.equalToSuperview()
            
        })
        
        lblHeader.snp.makeConstraints({lbl in
            lbl.top.equalToSuperview().offset(startY)
            lbl.leading.equalToSuperview().offset(72)
            
        })
        
//        self.view.addSubview(leftBarButton)
//        leftBarButton.snp.makeConstraints({btn in
//            btn.width.equalTo(24)
//            btn.height.equalTo(21)
//            btn.centerY.equalTo(lblHeader)
//            btn.leading.equalToSuperview().offset(24)
//        })
        
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
//        cell.animate()
        cell.dropCellViewModel?.isExpanded = false
        return cell
    }
    
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //
        guard let faqItem = tableView.cellForRow(at: indexPath) as? DropCell else {return}
        
        faqItem.toggleCellData(data: viewModel.descriptions[indexPath.row])
        
        if selectedIndexPath == nil{
            selectedIndexPath = indexPath
            self.tableView.selectRow(at: selectedIndexPath, animated: true, scrollPosition: .none)
            
            faqItem.toExpand.toggle()
        }
        
        if selectedIndexPath == indexPath{
            print("Deselect triggered")
            DispatchQueue.main.async {
                self.tableView.deselectRow(at: self.selectedIndexPath, animated: true)
            
            faqItem.toExpand.toggle()
            }
        }
        else{
            print("expanding cell at \(indexPath.row)")
            // expand cell
            
            DispatchQueue.main.async {
                //self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            }
            // update selected cell
            selectedIndexPath = indexPath
        }
        print("Selected IndexPath: \(selectedIndexPath)")
        print(expandedIndexPaths)

        tableView.beginUpdates()
//        UIView.animate(withDuration: 0.3, animations: {faqItem.dropView.alpha = 1})
        //self.tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        tableView.endUpdates()

        
        // Create animation for cell
        self.tableView.performBatchUpdates(nil)
    }
    */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let lastSelectedIndexPath = lastSelectedIndexPath{
            makeCellUnselected(in: tableView, on: selectedIndexPath)
            guard lastSelectedIndexPath != indexPath else {
                tableView.deselectRow(at: lastSelectedIndexPath, animated: true)
                self.lastSelectedIndexPath = nil
                return
            }
        }
        // highlight cell
        makeCellSelected(in: tableView, on: indexPath)
        lastSelectedIndexPath = indexPath
    }
    
    func makeCellSelected(in tableView: UITableView, on indexPath: IndexPath){
        
        if let cell = tableView.cellForRow(at: indexPath) as? DropCell{
            if (indexPath.row == 0) || (indexPath.row == 1) || (indexPath.row == 2) {
                print("+selected \(indexPath)")
                cell.toExpand.toggle()
                cell.layer.borderWidth = 2.0
                cell.layer.borderColor = UIColor.red.cgColor
                cell.layer.shadowOffset = CGSize.init(width: 0.5, height: 0.5)
            }
        }
    }
    
    func makeCellUnselected(in tableView: UITableView, on indexPath: IndexPath){
        if let cell = tableView.cellForRow(at: indexPath) as? DropCell{
            print("--deselected \(indexPath)")
            cell.toExpand.toggle()
            cell.layer.borderWidth = 0.1
            cell.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    // On deselect cell
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
//        guard let faqItem = tableView.cellForRow(at: indexPath) as? DropCell else {return}
////        faqItem.isSelected.toggle()
//        
//        self.tableView.beginUpdates()
//        self.tableView.deselectRow(at: indexPath, animated: true)
//        self.tableView.endUpdates()
//        guard let faqItem = tableView.cellForRow(at: indexPath) as? DropCell else {return}
//        tableView.beginUpdates()
//        UIView.animate(withDuration: 0.3, animations: {faqItem.dropView.alpha = 0})
//        //self.tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
//        tableView.endUpdates()
        //        if let index = selectedIndexPaths.index(of: indexPath) {
        //            print("trigger selectPath on DeselectRowAt")
        //            selectedIndexPaths.remove(at: index)
        //        }
        
        //        tableView.deselectRow(at: indexPath, animated: true)
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
        if selectedIndexPath == indexPath { return UITableView.automaticDimension }
        else{
            return 73+12
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
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
