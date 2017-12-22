//
//  SendMessageHandler.swift
//  ChatForWork
//
//  Created by DevOminext on 12/18/17.
//  Copyright © 2017 Nguyen Dinh Dung. All rights reserved.
//

import UIKit
import Firebase

extension ChatLogController {
    func sendMessageWithProperties(properties: [String: AnyObject]) {
        let ref = Database.database().reference().child("message")
        let childRef = ref.childByAutoId()
        let messageId = childRef.key
        let toId = user != nil ? UserDefaults.standard.string(forKey: "UserID") : UserDefaults.standard.string(forKey: "GroupID")
        let fromId = Auth.auth().currentUser!.uid
        let timeStamp: NSNumber = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        let negativeTimeStamp: NSNumber = NSNumber(value: -(Int(NSDate().timeIntervalSince1970)))
        var messageStatus: String?
        
        if toId == UserDefaults.standard.string(forKey: "UserID") {
            let userRef = Database.database().reference().child("user").child(toId!)
            userRef.observeSingleEvent(of: .value, with: {( DataSnapshot) in
                let dictionary = DataSnapshot.value as! [String: AnyObject]
                let lastTimeLoggin = dictionary["lastTimeLoggin"] as! NSNumber
                let lastTimeLogout = dictionary["lastTimeLogout"] as! NSNumber
                let chattingWith = dictionary["chattingWith"] as! String
                
                if chattingWith == fromId {
                    messageStatus = "Seen"
                } else
                { if Int(lastTimeLoggin) <= Int(lastTimeLogout) {
                    messageStatus = "Sent"
                } else if Int(lastTimeLoggin) > Int(lastTimeLogout) {
                    messageStatus = "Received"
                    } }
                
                var values = ["toId": toId!, "fromId": fromId, "timeStamp": timeStamp, "negativeTimeStamp": negativeTimeStamp, "messageId": messageId, "messageStatus": messageStatus!] as [String : AnyObject]
                
                //append properties dictionary on to values
                //key $0, value $1
                properties.forEach({values[$0] =  $1})
                
                childRef.updateChildValues(values, withCompletionBlock: {
                    (error ,ref) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    let userMessaegRef1 = Database.database().reference().child("user-message").child(fromId).child(toId!)
                    let userMessaegRef2 = Database.database().reference().child("user-message").child(toId!).child(fromId)
                    userMessaegRef1.updateChildValues([messageId: 1])
                    userMessaegRef2.updateChildValues([messageId: 1])
                    
                })
                
            })
        }   else if toId == UserDefaults.standard.string(forKey: "GroupID") {
            var values = ["toId": toId!, "fromId": fromId, "timeStamp": timeStamp, "negativeTimeStamp": negativeTimeStamp, "messageId": messageId, "messageStatus": "Sent"] as [String : AnyObject]
            properties.forEach({values[$0] =  $1})
            
            childRef.updateChildValues(values, withCompletionBlock: {
                (error ,ref) in
                if error != nil {
                    print(error!)
                    return
                }
                let groupUsersRef = Database.database().reference().child("group-users").child(toId!)
                let userMessageRef2 = Database.database().reference().child("user-message").child(toId!)
                groupUsersRef.updateChildValues([fromId: 1])
                userMessageRef2.updateChildValues([messageId: 1])
                
                groupUsersRef.observe(.childAdded, with: {
                    (DataSnapshot) in
                    let userId = DataSnapshot.key
                    let userMessaegRef1 = Database.database().reference().child("user-message").child(userId).child(toId!)
                    userMessaegRef1.updateChildValues([messageId: 1])
                }, withCancel: nil)
            })
        }
    }
    
    func observeUserMessage() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        UserDefaults.standard.setValue(user?.checkOnline, forKey: "CheckOnline")
        
        let userMessageRef = (user?.id) == nil ? Database.database().reference().child("user-message").child((group?.id)!) : Database.database().reference().child("user-message").child(uid).child((user?.id)!)
        
        userMessageRef.observe(.childAdded, with: {
            (DataSnapshot) in
            let messageId  = DataSnapshot.key
            let messageRef = Database.database().reference().child("message").child(messageId)
            messageRef.observeSingleEvent(of: .value, with: {
                (DataSnapshot) in
                
                guard let dictionary = DataSnapshot.value as? [String: AnyObject] else {
                    return
                }
                
                let message = Message(dictionary: dictionary)
                let dateString = self.getDateFromMessage(message: message, index: 0)
                if message.fromId != Auth.auth().currentUser?.uid {
                    let messageStatusRef = Database.database().reference(withPath: "message/\(message.messageId ?? "")/messageStatus")
                    messageStatusRef.setValue("Seen")
                }
                
                DispatchQueue.main.async {
                    self.messages.append(message)
                    self.dateStrings.append(dateString)
                    if self.dateStrings.count == 1 || self.dateStrings[self.dateStrings.count - 1] > self.dateStrings[self.dateStrings.count - 2] {
                        self.textForHeaders.append(dateString)
                    }
                    
                    self.chatLogTableView.reloadData()
//                    self.chatLogTableView.insertRows(at: [IndexPath(row: self.messages.count - 1, section: 0)], with: .automatic)
                    self.tableViewScroll()
                    self.chatLogTableView.layoutIfNeeded()
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    func getDateFromMessage(message: Message, index: Int) -> String{
        let seconds = message.timeStamp?.doubleValue
        let messageTimeStamp = NSDate(timeIntervalSince1970: seconds!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "dd/MM/yyyy"
        
        let dateString: String = dateFormatter.string(from: messageTimeStamp as Date)
        let dateString2: String = dateFormatter2.string(from: messageTimeStamp as Date)
        if index == 0 {
            return dateString2 }
        return dateString
    }
    
}
