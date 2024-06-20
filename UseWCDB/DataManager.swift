//
//  DataManager.swift
//  UseWCDB
//
//  Created by 张云飞 on 2024/6/20.
//

import Foundation
import WCDBSwift


let ZYFManager = DataManager.shared

let tabA = "TableModelA"
let tabB = "TableModelB"

// 单例类，管理数据库的初始化和操作
final class DataManager {
    static let shared = DataManager() // 单例实例

    let database: Database // WCDB 数据库实例
    
    private init() {
        // 数据库文件路径
        let databasePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/datames.db"
        // 创建数据库实例
        database = Database(at: URL(fileURLWithPath: databasePath))
        
        // 创建表单 a
        createTable(for: TableModelA.self, tableName: tabA)
        // 创建表单 b
        createTable(for: TableModelB.self, tableName: tabB)
    }
    // 创建表的方法，接收表的数据模型类型和表名
    func createTable<T: TableCodable>(for type: T.Type, tableName: String) {
        do {
           let have = try database.isTableExists(tableName)
            if have == false {
                do {
                    try database.create(table: tableName, of: type)
                } catch {
                    print("create error: \(error)")
                }
            }
        } catch {
            print("isTableExists error: \(error)")
        }
    }
    
    // 插入数据的方法，接收一个数据模型对象和表名 wcdb 是同步执行的
    func insert<T: TableCodable>(object: T, intoTable tableName: String,completion: @escaping () -> Void = {}) {
        DispatchQueue.global(qos: .background).async {[weak self] in
            guard let self = self else {return}
            do {
                try database.insert(object, intoTable: tableName)
                completion()
            } catch {
                print("\(error)")
            }
        }
        
    }
    
    // 查询数据的方法，返回指定表中的所有对象
    func getObjects<T: TableCodable>(fromTable tableName: String, completion: @escaping ([T]) -> Void) {
        DispatchQueue.global(qos: .background).async {[weak self] in
            guard let self = self else {return}
            do {
                let objects: [T] = try self.database.getObjects(fromTable: tableName)
                DispatchQueue.main.async {
                    completion(objects)
                }
            } catch {
                print("error: \(error)")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    // 条件查询
    func getObjectsForConditions<T: TableCodable>(fromTable tableName: String, condition: Condition? = nil, completion: @escaping ([T]) -> Void) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            do {
                let objects: [T] = try self.database.getObjects(fromTable: tableName, where: condition)
                DispatchQueue.main.async {
                    completion(objects)
                }
            } catch {
                print("error: \(error)")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    // 删除数据的方法
    func delete(fromTable tableName: String, condition: Condition? = nil,completion: @escaping () -> Void = {}) {
        do {
            try database.delete(fromTable: tableName, where: condition)
            completion()
        } catch {
            print("删除数据错误")
        }
    }
    
    // 改
    func updateData<T: TableCodable >(fromTable tableName: String,model: T,elements:[PropertyConvertible],condition: Condition? = nil,completion: @escaping () -> Void = {}) {
        DispatchQueue.global(qos: .background).async {[weak self] in
            guard let self = self else { return }
            do {
                try self.database.update(table: tableName, on: elements, with: model,where: condition)
                completion()
            } catch {
                print("Update error==\(error)")
            }
        }
    }
}
