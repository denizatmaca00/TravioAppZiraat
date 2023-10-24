//
//  Generics.swift
//  MvvmBir
//
//  Created by web3406 on 10/23/23.
//

import UIKit
import Alamofire



//MARK: -- Generic protocol. assosiatedType protocollere generic tipler tanımlamak için kullanılır.
protocol Fetchable {

    associatedtype T
    
    func getData(name:T)
    

}


//MARK: -- Generic Class with generic protocol
class APIHelper<T>:Fetchable {
   
    
    func getData(name:T) {
        guard let user = name as? User else { return }
        print(user.name)
    }
    
   
}


//MARK: -- Generic Class
class Movie<T> {
    
    init(name:T){
        
        print(name)
    }
    
    func test(name:T){
        
    }
    
}

protocol Prot {
    associatedtype T
    var test:T? { get }
    func customFunc(item:T)->T
}

class NetworkHelper<T>:Prot {
    
    typealias Kind = T
    var test: T?
    
    func customFunc(item: T) -> T {
        return item
    }

}

class Helper<T>:Prot {
    typealias Item = T
    var test: T?
    func customFunc(item: T) -> T {
        
        print(item)
        return item
    }
}

class GenericsVC: UIViewController {
   
    let helper = APIHelper<User>()
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        let movie = Movie(name: "Deneme")
       
        let test = APIHelper<Int>()
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  helper.getData(name: Person(userName: "asdkjaşskdljalksdjalkd", userSurname: "", id: ""))
       
        
    }
    
}
