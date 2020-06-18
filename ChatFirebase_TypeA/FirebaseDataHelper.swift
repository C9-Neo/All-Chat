//allows for connection and retrieval of database resources

import UIKit

import Firebase

fileprivate let baseRef = Database.database().reference()
//Created to establish a connection with Google's firebase servers

class FirebaseDataHelper {

    static let instance = FirebaseDataHelper()
 
    let chatRef = baseRef.child("chat")
    
    let groupRef = baseRef.child("group")
    
    let messageRef = baseRef.child("message")
    
    var currentUserUid: String? {
        get {
            guard let uid = Auth.auth().currentUser?.uid else {
                return nil
            }
            return uid
        }
    }
    
    // authenticates that the user has been registered into the database
    func createUserInfoFromAuth(uid:String, userData: Dictionary<String, String>) {
        chatRef.child(uid).updateChildValues(userData)
    }
    // allows a user to sign into the chat room throws error elsewise
    func signIn(email withEmail: String, password: String, completion: @escaping () -> Void) {
        Auth.auth().signIn(withEmail: withEmail, password: password, completion: { (user, error) in
            guard error == nil else {
                print("Error Occurred during Sign In")
                return
            }
            completion()
        })
    }
    
}
