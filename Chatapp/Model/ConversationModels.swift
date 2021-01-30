//
//  ConversationModels.swift
//  Chatapp
//
//  Created by dnamicro on 2021/01/30.
//

import Foundation

struct Conversation {
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date: String
    let text: String
    let isRead: Bool
}
