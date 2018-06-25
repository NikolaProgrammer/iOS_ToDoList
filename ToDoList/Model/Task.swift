
import Foundation

class Task: NSObject, NSCoding{
   
    //MARK: Properties
    var id: Int
    var name: String 
    var notes: String
    var isReminded: Bool
    var isFinished: Bool
    var date: Date
    var priority: Priority
    var category: Category
    
    //MARK: Types
    
    struct PropertyKey {
        static let id = "id"
        static let name = "name "
        static let notes = "notes"
        static let isReminded = "isReminded"
        static let isFinished = "isFinished"
        static let date = "date"
        static let priority = "priority"
        static let category = "category"
    }
    
    //MARK: Initializators
    init(id: Int, name: String, notes: String, isReminded: Bool, isFinished: Bool, date: Date, priority: Priority, category: Category) {
        self.id = id
        self.name = name
        self.notes = notes
        self.isReminded = isReminded
        self.isFinished = isFinished
        self.date = date
        self.priority = priority
        self.category = category
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeInteger(forKey: PropertyKey.id)
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            print("Unable to decode the task name")
            return nil
        }
        guard let notes = aDecoder.decodeObject(forKey: PropertyKey.notes) as? String else {
            print("Unable to decode the notes")
            return nil
        }
        let isReminded = aDecoder.decodeBool(forKey: PropertyKey.isReminded)
        let isFinished = aDecoder.decodeBool(forKey: PropertyKey.isFinished)
        guard let date = aDecoder.decodeObject(forKey: PropertyKey.date) as? Date else {
            print("Unable to decode the date")
            return nil
        }
        guard let priorityStr = aDecoder.decodeObject(forKey: PropertyKey.priority) as? String else {
            print("Unable to decode the priority")
            return nil
        }
        guard let category = aDecoder.decodeObject(forKey: PropertyKey.category) as? Category else {
            print("Unable to decode the category")
            return nil
        }
        
        self.init(id: id, name: name, notes: notes, isReminded: isReminded, isFinished: isFinished, date: date, priority: Priority(rawValue: priorityStr)!, category: category)
    }
    
    convenience init(name: String, notes: String, isReminded: Bool, isFinished: Bool, date: Date, priority: Priority, category: Category) {
        self.init(id: Int(arc4random()), name: name, notes: notes, isReminded: isReminded, isFinished: isFinished, date: date, priority: priority, category: category)
    }
    
    //MARK: NSObject
    override func isEqual(_ object: Any?) -> Bool {
        return id == (object as? Task)?.id
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: PropertyKey.id)
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(notes, forKey: PropertyKey.notes)
        aCoder.encode(isReminded, forKey: PropertyKey.isReminded)
        aCoder.encode(isFinished, forKey: PropertyKey.isFinished)
        aCoder.encode(date, forKey: PropertyKey.date)
        aCoder.encode(priority.rawValue, forKey: PropertyKey.priority)
        aCoder.encode(category, forKey: PropertyKey.category)
    }
}

