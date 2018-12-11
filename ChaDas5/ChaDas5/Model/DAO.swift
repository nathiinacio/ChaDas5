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
    
    
    let dadosSeg1 = [1,2,3,4,5]
    let dadosSeg2 = [6,7,8,9,0]
    var todosOsDados:[[Int]] {
        return [dadosSeg1, dadosSeg2]
    }

}
