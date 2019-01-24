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
        FBRef.stories.document(self.id).setData(self.asDictionary)
    }

    
}
    
