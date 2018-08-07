import UIKit

var str = "Hello, playground"

class Firebase
{

    func createUser(username: String, password: String, completion: (Bool, Int) -> Void) {
        //Firebase hace 'algo' con el usuario y la contraseña..
        
        let success = true
        let userID = 2700162
        
        completion(success, userID)
        
    }
    
}


class App
{
    
    func registerUserPressed() {
        let name = "Juan Gabriel"
        let password = "123456"
        
        let firebase = Firebase()
        firebase.createUser(username: name, password: password) { (success, userID) in
            print("Registro satisfactorio? \(success)")
            print("ID de usuario : \(userID)")
        }
        
    }
    
}


let app = App()
app.registerUserPressed()
