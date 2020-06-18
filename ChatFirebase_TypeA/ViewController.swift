import UIKit
import AVFoundation
import UserNotifications


class ViewController: UIViewController , UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var player: AVAudioPlayer?
    
    
    @IBOutlet weak var textField: UITextField!
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    //keyboard will show upon text field click

    @objc func keyboardWillShow(_ notification: Notification) {
        if textField.isFirstResponder {
            
        }
    }
    //keyboard will hide upon click outside of the text field 

    @objc func keyboardWillHide(_ notification: Notification) {
        if textField.isFirstResponder {
            
            view.frame.origin.y = 0
        }
    }
    
    //gets the height of the keyboard based on the screen size of the current device
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
       
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //text field declaration
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newText: NSString = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        
        if newText.length < 1 {
            
            
        } else {
            
        }
        return true
    }
    
    //alerts the user through a notification (upon chat exit) that there may be messages to be viewed
    
    @IBAction func tabAction(_ sender: Any) {
        let newText: NSString = textField.text! as NSString
        if newText.length < 1 {
            print("put in the Display Name")
        }
        else {
            playSound()
            sendNotification(title: "AllChat", body: "You may have new messages...")
        }
        
    }
    
    //retrieves as a dictionary all of the user's information which is stored in the database.
    
    var pickOption = ["Bill Clark", "Johnson Alexander", "Barbra Lucia", "Lara Nilson", "New User"]
    
    var dic1 : Dictionary<String, String> = ["name":"Bill Clark", "email":"bill@real.com", "uid":"x3MJt6nnNjaSj8rOn1VHEmDPOkf2"]
    var dic2 : Dictionary<String, String> = ["name":"Johnson Alexander", "email":"john@real.com", "uid":"27biHRO1WOdAUaBuw6VcgfKRS6w2"]
    var dic3 : Dictionary<String, String> = ["name":"Barbra Lucia", "email":"babarian@real.com", "uid":"bWJF1ZZOjIetWXQts7h8kHzIC7F3"]
    var dic4 : Dictionary<String, String> = ["name":"Lara Nilson", "email":"lara@real.com", "uid":"vrWTzUbQH4TRLNGL0SwKvfCY2mo1"]
    var dic5 : Dictionary<String, String> = ["name":"New User", "email":"newuser@real.com", "uid":"pGpX1GwrqzOJU622SiEhYxiRaa92"]
    
    var arrDic = NSMutableDictionary()
    
    
    var pickerView: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        
        pickerView = UIPickerView()
        pickerView.delegate = self
        
        textField.inputView = pickerView
        arrDic.setValue(dic1, forKey: "bill")
        arrDic.setValue(dic2, forKey: "john")
        arrDic.setValue(dic3, forKey: "babarian")
        arrDic.setValue(dic4, forKey: "lara")
        arrDic.setValue(dic5, forKey: "nilson")
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = pickOption[row]
        
        switch row {
        case 0:
            
            FirebaseDataHelper.instance.signIn(email: "bill@real.com", password: "123456") {
                self.openChattingView("bill")
            }
            
            break;
            
        case 1:
            
            FirebaseDataHelper.instance.signIn(email: "john@real.com", password: "123456") {
                self.openChattingView("john")
            }
            
            break;
            
        case 2:
            
            FirebaseDataHelper.instance.signIn(email: "babarian@real.com", password: "123456") {
                self.openChattingView("babarian")
            }
            
            break;
            
        case 3:
            
            FirebaseDataHelper.instance.signIn(email: "lara@real.com", password: "123456") {
                self.openChattingView("lara")
            }
            
            break;
            
        case 4:
            
            FirebaseDataHelper.instance.signIn(email: "nilson@real.com", password: "123456") {
                self.openChattingView("nilson")
            }
            
            
            break;
        default:
            break;
            
        }
        
        self.view.endEditing(true)
    }
    
    //retrieves user data from the database to be used by the "chatting view" as the user's credentials
    
    func openChattingView(_ name: String) {
        
        let rdic : Dictionary<String, String> = self.arrDic.object(forKey: name) as! Dictionary<String, String>
        
        let ref = FirebaseDataHelper.instance.chatRef.child(FirebaseDataHelper.instance.currentUserUid!)
        
        let data: Dictionary<String, AnyObject> = [
            "name": rdic["name"] as AnyObject,
            "uid": rdic["uid"] as AnyObject,
            "email": rdic["email"] as AnyObject
        ]
        print(ref.key as Any)
        ref.updateChildValues(data) { (err, ref) in
            guard err == nil else {
                print(err as Any)
                return
            }
            
            let data2: Dictionary<String, AnyObject> = [
                "name": rdic["name"] as AnyObject,
                "uid": rdic["uid"] as AnyObject
            ]
            
            let ref2 = FirebaseDataHelper.instance.groupRef.childByAutoId()
            ref2.updateChildValues(data2) { (err, ref3) in
                guard err == nil else {
                    print(err as Any)
                    return
                }
                
                print(ref.key as Any)
                let vc = UIStoryboard(name: "ChatSB",bundle:nil).instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
                vc.groupKey = ref.key
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    //sound to be played upon user logs
    
    func playSound(){
        let path = Bundle.main.path(forResource: "ding", ofType: "mp3")!
        
        let url = URL(fileURLWithPath: path)
        
        do{
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        }catch{
        }
    }
    
    func initNotifications() -> UNUserNotificationCenter{
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]){ (granted, error) in
            //error handling
        }
        return center
    }
    
    func sendNotification(title: String, body: String){
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]){ (granted, error) in
            //error handling
        }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        
        //let date = Date().addingTimeInterval(5)
        
        //let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (10), repeats: false)
        
        let uuidString = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        center.add(request){(error) in
        }
    }
}
