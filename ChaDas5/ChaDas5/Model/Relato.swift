//
//  Relato.swift
//  ChaDas5
//
//  Created by Julia Rocha on 06/12/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import Foundation
import Firebase

class Relato{
    
    var conteudo:String
    var autor:String
    var data:Date
    var status:String
    var id:String {
        return data.keyString+autor
    }

    init(conteudo:String, autor:String) {
        self.conteudo = conteudo
        self.autor = autor
        self.data = Date()
        self.status = "active"
        fbSave()
    }
    
    var asDictionary:[String:Any] {
        var result:[String:Any] = [:]
        result["conteudo"] = self.conteudo
        result["autor"] = self.autor
        result["data"] = self.data.keyString
        result["status"] = self.status
        return result
    }
    

    func fbSave() {
        FBRef.db.collection("stories").document(self.id).setData(self.asDictionary)
        guard let userID = UserManager.instance.currentUser else {
            return
        }
    }
    
    
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
    
