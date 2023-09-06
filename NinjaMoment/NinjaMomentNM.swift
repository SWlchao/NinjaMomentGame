import UIKit
import RealmSwift

class NinjaMomentNM: NSObject {

    static let NinjaMomentNMPath = "/NinjaMomentNM.realm"
    
    private class func NinjaMomentNM() -> Realm? {
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
        let dbPath = docPath.appending(NinjaMomentNMPath)
        // 传入路径会自动创建数据库
        
        guard let dbUrl = URL(string: dbPath) else {
            return nil
        }
        
        if let defaultRealm = try? Realm(fileURL: dbUrl) {
            print("数据库地址->\(defaultRealm.configuration.fileURL?.absoluteString ?? "")")
            return defaultRealm
        } else {
            return nil
        }
    }
}

extension NinjaMomentNM {
    //  配置数据库
    public class func configNinjaMomentNM() {
        // 这个方法主要用于数据模型属性增加或删除时的数据迁移，每次模型属性变化时，将 dbVersion 加 1 即可，Realm 会自行检测新增和需要移除的属性，然后自动更新硬盘上的数据库架构，移除属性的数据将会被删除。
        let dbVersion : UInt64 = 1
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
        let dbPath = docPath.appending(NinjaMomentNMPath)
        let config = Realm.Configuration(fileURL: URL.init(string: dbPath), inMemoryIdentifier: nil, syncConfiguration: nil, encryptionKey: nil, readOnly: false, schemaVersion: dbVersion, migrationBlock: { (migration, oldSchemaVersion) in
            
        }, deleteRealmIfMigrationNeeded: false, shouldCompactOnLaunch: nil, objectTypes: nil)
        Realm.Configuration.defaultConfiguration = config
        
        Realm.asyncOpen { result in
            if let _ = try? result.get() {
                print("Realm 服务器配置成功!")
            } else {
                print("Realm 数据库配置失败!")
            }
        }
    }
}

extension NinjaMomentNM {
    //MARK: 新增单条数据
    public class func addGameModel<T>(_ object: T) {
        
        guard let model = object as? Object else {
            print("Find nil object")
            return
        }
        
        guard let defaultRealm = self.NinjaMomentNM() else {
            print("Create database error")
            return
        }
        
        do {
            try defaultRealm.write {
                defaultRealm.add(model)
            }
            print(defaultRealm.configuration.fileURL ?? "")
        } catch { print("defaultRealm.write error") }
    }
    
    //MARK: 查询所有数据-条件查询
    class func queryGameModel<T> (object: T, filter: String? = nil) -> [T] {
        
        guard let defaultRealm = self.NinjaMomentNM() else {
            print("Create database error")
            return []
        }
        
        guard let modelType = T.self as? Object.Type else {
            print("Type error")
            return []
        }
        
        var objects: Results<Object>
        
        if let condition = filter {
            objects = defaultRealm.objects(modelType.self).filter(condition)
        } else {
            objects = defaultRealm.objects(modelType.self)
        }
        
        guard objects.count > 0 else { return [] }
        var models = [T]()
        for object in objects {
            if let model = object as? T {
                models.append(model)
            }
        }
        return models
    }
    
    //MARK: - 删除数据 - 必须带有主键
    public class func deleteGameModel<T>(_ object: T) {
        
        guard let model = object as? Object else {
            print("Find nil object")
            return
        }
        
        guard let defaultRealm = self.NinjaMomentNM() else {
            print("Create database error")
            return
        }
        
        do {
            try defaultRealm.write {
                defaultRealm.delete(model)
            }
        } catch {
            print("defaultRealm.write error - fail to edit")
        }
    }
    
    //MARK: - updataObject - 必须带有主键
    public class func updateGameModel<T>(_ object: T) {
        
        guard let defaultRealm = self.NinjaMomentNM() else {
            print("Create database error")
            return
        }
        
        guard let model = object as? Object else {
            print("object as? Object error")
            return
        }
        
        do {
            try defaultRealm.write {
                defaultRealm.add(model, update: .modified)
            }
        } catch {
            print("defaultRealm.write error - fail to edit")
        }
    }
}
