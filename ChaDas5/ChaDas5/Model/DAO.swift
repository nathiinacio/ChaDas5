//
//  DAO.swift
//  ChaDas5
//
//  Created by Gabriela Szpilman on 11/12/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import Foundation

class DAO {
    static let instance = DAO()
    private init(){}
    
    let teas = ["ginger", "black tea", "chamomille", "kska", "kwjalj", "jsjsj"]
    
    let dadosSeg1 = ["relato 1", "relato 2", "relato 3", "relato 8"]
    let dadosSeg2 = ["relato 4", "relato 5", "relato 6"]
    var todosOsDados:[[String]] {
        return [dadosSeg1, dadosSeg2]
    }

}
