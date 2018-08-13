import UIKit

let defaults = UserDefaults.standard

let userLevelKey = "UserLevel"

enum UserDefaultsKey : String {
    case userLevel = "UserLevel"
    case musicVolume = "MusicVolume"
    case easyMode = "EasyMode"
    case username = "UserName"
}

defaults.set(5, forKey: userLevelKey)
defaults.set(0.4, forKey: UserDefaultsKey.musicVolume.rawValue)
defaults.set(true, forKey: UserDefaultsKey.easyMode.rawValue)
defaults.set("Juan Gabriel", forKey: UserDefaultsKey.username.rawValue)
defaults.set(Date(), forKey: "LastLogin")

let array = [1,2,3,4,5]
defaults.set(array, forKey: "NumArray")

let dict = ["name": "Juan Gabriel", "age": 30, "studied": "Matemáticas", "money": 30.75] as [String : Any]
defaults.set(dict, forKey: "UserData")




let level = defaults.integer(forKey: userLevelKey)
let volume = defaults.float(forKey: UserDefaultsKey.musicVolume.rawValue)
let name = defaults.string(forKey: UserDefaultsKey.username.rawValue)
let lastLogin = defaults.object(forKey: "LastLogin")

let numbers = defaults.array(forKey: "NumArray") as! [Int]
let userdata = defaults.dictionary(forKey: "UserData")




class Coding{
    var language = "Swift"
    
    static let sharedCoding = Coding()
}

let myCoding = Coding.sharedCoding
myCoding.language = "Objective-C"

let yourCoding = Coding.sharedCoding
print(yourCoding.language)

