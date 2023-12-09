//
//  MessagesManager.swift
//  columbiamarketplace
//
//  Created by Keir Keenan on 12/3/23.
//

//import Foundation
//import FirebaseFirestore
//import FirebaseFirestoreSwift
//
//class MessagesManager: ObservableObject {
//    @Published private(set) var messages: [Message] = []
//    @Published private(set) var lastMessageId: String = ""
//
//    // Create an instance of our Firestore database
//    let db = Firestore.firestore()
//
//    // On initialize of the MessagesManager class, get the messages from Firestore
//    init() {
//        getMessages()
//    }
//
//    // Read message from Firestore in real-time with the addSnapShotListener
//    func getMessages() {
//        db.collection("messages").addSnapshotListener { querySnapshot, error in
//
//            // If we don't have documents, exit the function
//            guard let documents = querySnapshot?.documents else {
//                print("Error fetching documents: \(String(describing: error))")
//                return
//            }
//
//            // Mapping through the documents
//            self.messages = documents.compactMap { document -> Message? in
//                do {
//                    // Converting each document into the Message model
//                    // Note that data(as:) is a function available only in FirebaseFirestoreSwift package - remember to import it at the top
//                    return try document.data(as: Message.self)
//                } catch {
//                    // If we run into an error, print the error in the console
//                    print("Error decoding document into Message: \(error)")
//
//                    // Return nil if we run into an error - but the compactMap will not include it in the final array
//                    return nil
//                }
//            }
//
//            // Sorting the messages by sent date
//            self.messages.sort { $0.timestamp < $1.timestamp }
//
//            // Getting the ID of the last message so we automatically scroll to it in ContentView
//            if let id = self.messages.last?.id {
//                self.lastMessageId = id
//            }
//        }
//    }
//
//    // Add a message in Firestore
//    func sendMessage(text: String) {
//        do {
//            // Create a new Message instance, with a unique ID, the text we passed, a received value set to false (since the user will always be the sender), and a timestamp
//            let newMessage = Message(id: "\(UUID())", text: text, received: false, timestamp: Date())
//
//            // Create a new document in Firestore with the newMessage variable above, and use setData(from:) to convert the Message into Firestore data
//            // Note that setData(from:) is a function available only in FirebaseFirestoreSwift package - remember to import it at the top
//            try db.collection("messages").document().setData(from: newMessage)
//
//        } catch {
//            // If we run into an error, print the error in the console
//            print("Error adding message to Firestore: \(error)")
//        }
//    }
//}

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class MessagesManager: ObservableObject {
    @Published private(set) var messages: [Message] = []
    @Published private(set) var lastMessageId: String = ""
    
    // Create an instance of our Firestore database
    let db = Firestore.firestore()
    
    // On initialize of the MessagesManager class, get the messages from Firestore
    init(senderID: String, receiverID: String) {
        getMessages(senderID: senderID, receiverID: receiverID)
    }

    // Read message from Firestore in real-time with the addSnapShotListener
    func getMessages(senderID: String, receiverID: String) {
        db.collection("users").document(senderID).addSnapshotListener { senderDocument, senderError in
            if let senderError = senderError {
                print("Error fetching sender document: \(senderError)")
                return
            }
            
            guard let senderDocument = senderDocument, senderDocument.exists else {
                print("Sender document not found.")
                return
            }
            
            let senderData = senderDocument.data()
            
            guard let messagesData = senderData?["messages"] as? [String: [[String: Any]]],
                  let receiverMessagesData = messagesData[receiverID] else {
                print("Messages data not found for the receiver.")
                return
            }
            
            // Mapping through the receiver's messages
            self.messages = receiverMessagesData.compactMap { messageData -> Message? in
                do {
                    // Converting each message data into the Message model
                    return try Firestore.Decoder().decode(Message.self, from: messageData)
                } catch {
                    // If we run into an error, print the error in the console
                    print("Error decoding message data into Message: \(error)")
                    return nil
                }
            }
            
            // Sorting the messages by timestamp
            self.messages.sort { $0.timestamp < $1.timestamp }
            
            // Getting the ID of the last message so we automatically scroll to it in ContentView
            if let id = self.messages.last?.id {
                self.lastMessageId = id
            }
        }
    }
    
    // Add a message in Firestore
    func sendMessage(text: String, senderID: String, receiverID: String) {
        do {
            // Create a new Message instance
            let newMessage_s = Message(id: "\(UUID())", text: text, received: false, timestamp: Date())
            let newMessage_r = Message(id: "\(UUID())", text: text, received: true, timestamp: Date())
            
            // Convert the Message into Firestore data
            let messageData_s = try Firestore.Encoder().encode(newMessage_s)
            let messageData_r = try Firestore.Encoder().encode(newMessage_r)
            
            // Update the sender's document with the new message data
            db.collection("users").document(senderID).updateData([
                "messages.\(receiverID)": FieldValue.arrayUnion([messageData_s])
            ]) { error in
                if let error = error {
                    print("Error adding message to Firestore: \(error)")
                }
            }
            
            // Update the receiver's document with the new message data
            db.collection("users").document(receiverID).updateData([
                "messages.\(senderID)": FieldValue.arrayUnion([messageData_r])
            ]) { error in
                if let error = error {
                    print("Error adding message to receiver's Firestore: \(error)")
                }
            }
            
        } catch {
            // If we run into an error, print the error in the console
            print("Error encoding message to Firestore: \(error)")
        }
    }
}
