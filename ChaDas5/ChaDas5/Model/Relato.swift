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
    
//    func toDictionary(_ dictionary: Data) -> [String:Any] {
//        var result:[String:Any] = [:]
//        result["conteudo"] = dictionary.
//        result["autor"] = dictionary["autor"]
//        result["data"] = dictionary["conteudo"]
//        return result
//    }
// 
    

    func fbSave() {
       
        //SALVAR NA COLEÇÃO COM ID CUSTOMIZADO
        FBRef.db.collection("Feed").document(self.id).setData(self.asDictionary)
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
    
