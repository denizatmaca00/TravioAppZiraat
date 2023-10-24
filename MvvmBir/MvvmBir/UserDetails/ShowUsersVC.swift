//
//  ShowUsersVC.swift
//  MvvmBir
//
//  Created by web3406 on 10/23/23.
//

import UIKit
import SnapKit


class ShowUsersVC: UIViewController {
    
    var usersInfo: [User]?

    
    lazy var viewModel = UserListViewModel()
    
    public lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0 //sağdan soldan
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        cv.register(UserTableCell.self, forCellWithReuseIdentifier: "cell")
        cv.isPagingEnabled = true
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    
    private lazy var btnPlus: UIButton = {
        let b = UIButton()
        b.setTitle("+", for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.backgroundColor = .systemBlue
        b.addTarget(self, action: #selector(btnAddTapped), for: .touchUpInside)
        b.tintColor = .white
        return b
    }()

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//    }
    
    @objc func btnAddTapped() {
        let vc = UsersVC()
        self.navigationController?.pushViewController(vc, animated: true)
        print("tdfhfgj")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initVM()

    }


    func initVM() {
   
        viewModel.reloadTableViewClosure = { [weak self] () in
           
                self?.collectionView.reloadData()
            
        }
    }
    
    private func setupViews() {
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        self.view.addSubviews(collectionView, btnPlus)
        setupLayout()
    }
    
    private func setupLayout() {
        collectionView.snp.makeConstraints({ table in
            table.edges.equalToSuperview()
        })
        btnPlus.snp.makeConstraints({ btn in
            btn.bottom.equalToSuperview().offset(-100)
            btn.trailing.equalToSuperview().offset(-50)
            btn.leading.equalToSuperview().offset(230)
        })
    }
}



extension ShowUsersVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return usersInfo!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserTableCell
        let obj = usersInfo![indexPath.row]
        cell.configure(object: obj)
        return cell
        
    } 

}
extension ShowUsersVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 80)
    }

}


