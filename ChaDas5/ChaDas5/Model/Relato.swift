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

    init(conteudo:String, autor:String, data:Date) {
        self.conteudo = conteudo
        self.autor = autor
        self.data = data
        fbSave()
    }
    
    var asDictionary:[String:Any] {
        var result:[String:Any] = [:]
        result["conteudo"] = self.conteudo
        result["autor"] = self.autor
//        result["data"] = self.data
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
    
    
}
