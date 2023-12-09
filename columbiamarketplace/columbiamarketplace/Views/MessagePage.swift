//
//  MessagePage.swift
//  columbiamarketplace
//
//  Created by Keir Keenan on 11/15/23.
//

//import Foundation
//import SwiftUI
//
//// Mock contact data structure
//struct Contact {
//    let id: Int
//    let name: String
//}
//
//struct MessagePage: View {
//    // Mock contact data
//    @State private var contacts: [Contact] = [
//        Contact(id: 1, name: "John Doe"),
//        Contact(id: 2, name: "Jane Smith"),
//        Contact(id: 3, name: "Alice Johnson"),
//        Contact(id: 4, name: "John Doe"),
//        Contact(id: 5, name: "Jane Smith"),
//        Contact(id: 6, name: "Alice Johnson"),
//        Contact(id: 7, name: "John Doe"),
//        Contact(id: 8, name: "Jane Smith"),
//        Contact(id: 9, name: "Alice Johnson")
//        // Add more contacts as needed
//    ]
//
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(contacts, id: \.id) { contact in
//                    NavigationLink(destination: ContactDetailsView(contactName: contact.name)) {
//                        Image("user_placeholder")
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 50, height: 50)
//                            .cornerRadius(50)
//
//                        Text(contact.name)
//                    }
//                }
//                .onDelete(perform: deleteContact)
//            }
//            .navigationTitle("Messages")
//            .navigationBarItems(trailing: EditButton())
//        }
//    }
//
//    // Function to delete a contact
//    private func deleteContact(at offsets: IndexSet) {
//        contacts.remove(atOffsets: offsets)
//    }
//}
//
//// ContactDetailsView to display contact's name
//struct ContactDetailsView: View {
//    let contactName: String
//
//    @StateObject var messagesManager = MessagesManager()
//
//    var body: some View {
//        VStack {
//            VStack {
////                TitleRow()
//                HStack(spacing: 20) {
//                    Image("user_placeholder")
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 50, height: 50)
//                        .cornerRadius(50)
//
//                    VStack(alignment: .leading) {
//                        Text(contactName)
//                            .font(.title).bold()
//
//                        Text("uni@columbia.edu")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//
//                }
//                .padding()
//
//                ScrollViewReader { proxy in
//                    ScrollView {
//                        ForEach(messagesManager.messages, id: \.id) { message in
//                            MessageBubble(message: message)
//                        }
//                    }
//                    .padding(.top, 10)
//                    .background(.white)
//                    .cornerRadius(30, corners: [.topLeft, .topRight]) // Custom cornerRadius modifier added in Extensions file
//                    .onChange(of: messagesManager.lastMessageId) { id in
//                        // When the lastMessageId changes, scroll to the bottom of the conversation
//                        withAnimation {
//                            proxy.scrollTo(id, anchor: .bottom)
//                        }
//                    }
//                }
//            }
////            .background(Color("Peach"))
//
//            MessageField()
//                .environmentObject(messagesManager)
//        }
//    }
//}
//
//
//struct MessagePage_Previews: PreviewProvider {
//    static var previews: some View {
//        MessagePage()
//    }
//}

import Foundation
import SwiftUI

// Mock contact data structure
struct Contact {
    let id: Int
    let name: String
}

struct MessagePage: View {
    // Mock contact data
    @State private var contacts: [Contact] = [
        Contact(id: 1, name: "Ninibini")
//        Contact(id: 2, name: "Jane Smith"),
//        Contact(id: 3, name: "Alice Johnson"),
//        Contact(id: 4, name: "John Doe"),
//        Contact(id: 5, name: "Jane Smith"),
//        Contact(id: 6, name: "Alice Johnson"),
//        Contact(id: 7, name: "John Doe"),
//        Contact(id: 8, name: "Jane Smith"),
//        Contact(id: 9, name: "Alice Johnson")
        // Add more contacts as needed
    ]

    var body: some View {
        NavigationView {
            List {
                ForEach(contacts, id: \.id) { contact in
                    NavigationLink(destination: ContactDetailsView(contactName: contact.name)) {
                        Image("user_placeholder")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .cornerRadius(50)
                        
                        Text(contact.name)
                    }
                }
                .onDelete(perform: deleteContact)
            }
            .navigationTitle("Messages")
            .navigationBarItems(trailing: EditButton())
        }
    }

    // Function to delete a contact
    private func deleteContact(at offsets: IndexSet) {
        contacts.remove(atOffsets: offsets)
    }
}

// ContactDetailsView to display contact's name
struct ContactDetailsView: View {
    let contactName: String
    
    @StateObject private var messagesManager = MessagesManager(senderID: "Baob9oLmeWTwqDbhyUMltH8djVA2", receiverID: "0fPmTjbk3xWHrvLzxeUHRFI8GQ32")
        
    var body: some View {
        VStack {
            VStack {
//                TitleRow()
                HStack(spacing: 20) {
                    Image("user_placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .cornerRadius(50)
                    
                    VStack(alignment: .leading) {
                        Text(contactName)
                            .font(.title).bold()
                        
                        Text("hc1234")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                .padding()
                
                ScrollViewReader { proxy in
                    ScrollView {
                        ForEach(messagesManager.messages, id: \.id) { message in
                            MessageBubble(message: message)
                        }
                    }
                    .padding(.top, 10)
                    .background(.white)
                    .cornerRadius(30, corners: [.topLeft, .topRight]) // Custom cornerRadius modifier added in Extensions file
                    .onChange(of: messagesManager.lastMessageId) { id in
                        // When the lastMessageId changes, scroll to the bottom of the conversation
                        withAnimation {
                            proxy.scrollTo(id, anchor: .bottom)
                        }
                    }
                }
            }
//            .background(Color("Peach"))
            
            MessageField()
                .environmentObject(messagesManager)
        }
    }
}


struct MessagePage_Previews: PreviewProvider {
    static var previews: some View {
        MessagePage()
    }
}
