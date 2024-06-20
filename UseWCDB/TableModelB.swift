//
//  TableModelB.swift
//  UseWCDB
//
//  Created by 张云飞 on 2024/6/20.
//

import UIKit
import HandyJSON
import WCDBSwift

final class TableModelB: NSObject,HandyJSON,TableCodable {
    var id: Int? = nil // 主键
    
    // 定义其他数据字段
    var mesa: String = ""
    var mesb: String = ""
    
    
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = TableModelB
        case id
        case mesa
        case mesb
        
        static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(id, isPrimary: true,isAutoIncrement: true) // 定义主键 并且主键自增长
        }
    }
    required override init() {
    }
    func mapping(mapper: HelpingMapper) {
    }
}
