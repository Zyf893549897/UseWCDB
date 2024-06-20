//
//  ViewController.swift
//  UseWCDB
//
//  Created by 张云飞 on 2024/6/20.
//

import UIKit
import WCDBSwift
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 增   插入数据采用泛型  统一管理
        let modA = TableModelA()
        modA.mesa = "123"
        modA.mesb = "123"
        ZYFManager.insert(object: modA, intoTable: tabA) {
            // 成功以后做什么
            print("插入数据成功======")
        }
        let modB = TableModelB()
        modB.mesa = "5555"
        modB.mesb = "666"
        ZYFManager.insert(object: modB, intoTable: tabB)
        
        
        
        
        // 查
        // 全部查询
        ZYFManager.getObjects(fromTable: tabA) {[weak self] (objs: [TableModelA]) in
            guard let self = self else {return}
            print("查询数据=====\(objs)")
        }
        // 条件查询   查询  mesa == 123 的所有数据
        ZYFManager.getObjectsForConditions(fromTable: tabA, condition: TableModelA.Properties.mesa == "123") {[weak self] (objs:[TableModelA]) in
            guard let self = self else {return}
            print("条件查询数据=====\(objs)")     // 测试时屏蔽下方修改 代码  因为异步执行 改了以后看不到了
        }

        
        
        // 改
        modA.mesa = "345"
        modA.mesb = "111"
        ZYFManager.updateData(fromTable: tabA, model: modA, elements: [TableModelA.Properties.mesa,TableModelA.Properties.mesb])
        // 修改以后查询
        ZYFManager.getObjects(fromTable: tabA) {[weak self] (objs: [TableModelA]) in
            guard let self = self else {return}
            for m in objs {
                print("====asdf===\(m.mesa)===\(m.mesb)")
            }
        }
        
        
        
        
        
//
//        // 删 所有数据
//        ZYFManager.delete(fromTable: tabA)
//        // 删除id为10 的数据
//        ZYFManager.delete(fromTable: tabA, condition: (TableModelA.Properties.id == 1))
//        // 删除 特定条件的数据
//        ZYFManager.delete(fromTable: tabA, condition: (TableModelA.Properties.mesa == "123"))
        
    }


}

