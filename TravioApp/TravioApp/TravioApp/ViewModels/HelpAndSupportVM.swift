//
//  
//  HelpAndSupportVM.swift
//  TravioApp
//
//  Created by Aydın Erol on 2.11.2023.
//
//

import UIKit
import SnapKit

class HelpAndSupportVM: UIViewController {
    
    //MARK: -- Properties
    
    var titles:[String] = ["How can I create a new account on Travio?", "How can I save a visit", "How does Travio work?"]
    var descriptions:[String] = ["lorem ipsum desc", "il domine ipsum", "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."]
    
    private var cellViewModels: [DropCellViewModel] = [DropCellViewModel]() {
        didSet{
            reloadTableViewClosure?()
        }
    }
    
    var reloadTableViewClosure: (()->())?
    
    var numberOfCells:Int{
        cellViewModels.count
    }
    
    var cellHeight:CGFloat{
        DropCell().dropView.frame.height
    }
    
    //MARK: -- Views
    
    
    //MARK: -- Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        fetchData()
       
    }
    
    //MARK: -- Component Actions
    
    //MARK: -- Private Methods
    
    public func fetchData() -> Void {
        
        var viewModels:[DropCellViewModel] = [DropCellViewModel]()
        
        for (title, desc) in zip(titles, descriptions) {
            viewModels.append(createCellViewModel(title: title, desc: desc))
        }
    
        self.cellViewModels = viewModels
    }
    
    private func createCellViewModel(title:String, desc:String) -> DropCellViewModel {
        let cvm = DropCellViewModel(title: title, description: desc)
        return cvm
    }
    
    func getCellViewModel(idx:IndexPath)->DropCellViewModel{
        
        return cellViewModels[idx.row]
    }
    
    //MARK: -- UI Methods
    func setupViews() {
        // Add here the setup for the UI
        self.view.addSubviews()
        
        setupLayout()
    }
    
    func setupLayout() {
        // Add here the setup for layout
       
    }
  
}

struct DropCellViewModel {
    var title:String
    var description:String
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct HelpSup_Preview: PreviewProvider {
    static var previews: some View{
        
        HelpAndSupportVC().showPreview()
    }
}
#endif
