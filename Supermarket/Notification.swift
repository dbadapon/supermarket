//
//  Notification.swift
//  Supermarket
//
//  Created by Alvin Magee on 7/24/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import Foundation
import Parse

class Notification {
    
    enum Field {
        case Sender, Receiver, Message, Seen, PostObject
        
        var key: String {
            switch (self) {
            case .Sender:
                return "sender"
            case .Receiver:
                return "receiver"
            case .Message:
                return "message"
            case .Seen:
                return "seen"
            case .PostObject:
                return "postObject"

            }
        }
    }
    
    var sender: PFUser { // so why do all of these things have to be optional?
        get {
            return parseObject[Field.Sender.key] as! PFUser
        }
        set {
            parseObject[Field.Sender.key] = newValue
        }
    }
    
    var receiver: PFUser {
        get {
            return parseObject[Field.Receiver.key] as! PFUser
        }
        set {
            parseObject[Field.Receiver.key] = newValue
        }
    }
    
    var message: String {
        get {
            return parseObject[Field.Message.key] as! String
        }
        set {
            parseObject[Field.Message.key] = newValue
        }
    }
    
    var seen: Bool {
        get {
            return parseObject[Field.Seen.key] as! Bool
        }
        set {
            parseObject[Field.Seen.key] = newValue
        }
    }
    
    var postObject: PFObject {
        get {
            return parseObject[Field.PostObject.key] as! PFObject
        }
        set {
            parseObject[Field.PostObject.key] = newValue
        }
    }
    
    var parseObject: PFObject
    
    
    init(_ parseObject: PFObject? = nil) {
        self.parseObject = parseObject ?? PFObject(className: "Notification")
    }
    
    
    class func createNotification(withSender sender: PFUser, withReceiver receiver: PFUser, withMessage message: String, withPostObject postObject: PFObject) -> Notification {
        
        let newNotification = Notification()
        newNotification.sender = sender
        newNotification.receiver = receiver
        newNotification.message = message
        newNotification.seen = false
        newNotification.postObject = postObject
        
        newNotification.parseObject.saveInBackground { (success, error) in
            if let error = error {
                print ("The notification error was: \(error.localizedDescription)")
            } else if success {
                print ("success saving the notification")
            } else {
                print ("there was no error saving the notification, but it was also not successful")
            }
        }
        
        return newNotification
    }
    
    func save() {
        self.parseObject.saveInBackground { (success, error) in
            if let error = error {
                print ("problem saving notification: \(error.localizedDescription)")
            } else if success {
                print ("saving the notification was a success")
            } else {
                print ("there was no error, but the noficiation was not successfully saved")
            }
        }
    }
    
}
