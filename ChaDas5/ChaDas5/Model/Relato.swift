//
//  Relato.swift
//  ChaDas5
//
//  Created by Julia Rocha on 06/12/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import Foundation
import Firebase

class Relato {
    
    var conteudo:String
    var autor:String
    var data:Date
    var id:String {
        return data.keyString+autor
    }

    init(conteudo:String, autor:String) {
        self.conteudo = conteudo
        self.autor = autor
        self.data = Date()
        fbSave()
    }
    
    var asDictionary:[String:Any] {
        var result:[String:Any] = [:]
        result["conteudo"] = self.conteudo
        result["autor"] = self.autor
        result["data"] = self.data.keyString
        return result
    }
    

    func fbSave() {
       
        //SALVAR NA COLEÇÃO COM ID CUSTOMIZADO
        FBRef.db.collection("Feed").document(self.id).setData(self.asDictionary)
        
        //PEGAR TODOS OS DOCS DA COLEÇÃO
        
//        let docRef = FBRef.db.collection("Feed")
//
//        docRef.getDocuments { (querySnapshot, err) in
//            print("************ To Aqui ************")
//                    if let err = err {
//                        print("Document error")
//
//                    } else {
//                        for document in querySnapshot!.documents {
//                            print(document.documentID)
//                        }
//                    }
//                }
    }
    
    
    
    //PAGINACAO SCROLLVIEW
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//        //print("offsetY: \(offsetY) | contHeight-scrollViewHeight: \(contentHeight-scrollView.frame.height)")
//        if offsetY > contentHeight - scrollView.frame.height - 50 {
//            // Bottom of the screen is reached
//            if !fetchingMore {
//                paginateData()
//            }
//        }
//    }
//
//    // Paginates data
//    func paginateData() {
//
//        fetchingMore = true
//
//        var query: Query!
//
//        if rides.isEmpty {
//            query = db.collection("rides").order(by: "price").limit(to: 6)
//            print("First 6 rides loaded")
//        } else {
//            query = db.collection("rides").order(by: "price").start(afterDocument: lastDocumentSnapshot).limit(to: 4)
//            print("Next 4 rides loaded")
//        }
//
//        query.getDocuments { (snapshot, err) in
//            if let err = err {
//                print("\(err.localizedDescription)")
//            } else if snapshot!.isEmpty {
//                self.fetchingMore = false
//                return
//            } else {
//                let newRides = snapshot!.documents.compactMap({Ride(dictionary: $0.data())})
//                self.rides.append(contentsOf: newRides)
//
//                //
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
//                    self.tableView.reloadData()
//                    self.fetchingMore = false
//                })
//
//                self.lastDocumentSnapshot = snapshot!.documents.last
//            }
//        }
//    }
    
    //OUTRA OPCAO DE PAGINACAO
    
//    func paginate() {
//    let first = FBRef.db.collection("Feed").order(by: "data").limit(to: 25)
//
//
//    first.addSnapshotListener { (snapshot, error) in
//    guard let snapshot = snapshot else {
//    print("Error retreving reports: \(error.debugDescription)")
//    return
//    }
//
//    guard let lastSnapshot = snapshot.documents.last else {
//    return
//    }
//
//    let next = FBRef.db.collection("Feed")
//    .order(by: "data")
//    .start(afterDocument: lastSnapshot)
//
//    // Use the query for pagination.
//    // ...
    //  }
    
    //ALTERAR DADOS DO RELATO
//    let docRef = db.collection("Feed").document(doc key)
//
//
//    docRef.updateData([
//    "active": true
//    ]) { err in
//    if let err = err {
//    print("Error updating document: \(err)")
//    } else {
//    print("Document successfully updated")
//    }
//    }
    
}
    
