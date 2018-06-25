

import Foundation

class Category: NSObject, NSCoding {
    
    //MARK: Properties
    var id: Int
    var name: String
    var includedTasks: [Task] = []
    
    //MARK: Types
    struct PropertyKey {
        static let id = "id"
        static let name = "name "
        static let includedTasks = "includedTasks"
    }
    
    //MARK: Initializators
    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeInteger(forKey: PropertyKey.id)
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            print("Unable to decode the category name")
            return nil
        }
        guard let includedTasks = aDecoder.decodeObject(forKey: PropertyKey.includedTasks) as? [Task] else {
            print("Unable to decode the category tasks")
            return nil
        }
        
        self.init(categoryId: id, categoryName: name, includedTasks: includedTasks)
    }
    
    init(categoryId: Int, categoryName: String, includedTasks: [Task]) {
        self.id = categoryId
        self.name = categoryName
        self.includedTasks = includedTasks
    }
    
    convenience init(categoryName: String) {
        self.init(categoryId: Int(arc4random_uniform(1) + 1000), categoryName: categoryName, includedTasks: [])
    }
    
    //MARK: NSObject
    override func isEqual(_ object: Any?) -> Bool {
        return id == (object as? Category)?.id
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: PropertyKey.id)
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(includedTasks, forKey: PropertyKey.includedTasks)
    }
    
}
