//
//  Models.swift
//  DrawPadAndEPubReader
//
//  Created by Hosung, Lee on 2017. 6. 11..
//  Copyright © 2017년 hosung. All rights reserved.
//

import Foundation
import RealmSwift

class DrawNote: Object {
    dynamic var id = 0
    dynamic var saved = false
    dynamic var user = ""
    dynamic var title: String?
    let paths = List<DrawPath>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class DrawPath: Object {
    dynamic var saved = false
    dynamic var completed = false
    dynamic var color: String?
    let bushsize = RealmOptional<Int>()
    let points = List<DrawPoint>()
}

class DrawPoint: Object {
    dynamic var x: Double = 0
    dynamic var y: Double = 0
}

class EPubHighLight: Object {
    dynamic var id = 0
    dynamic var bookId = ""
    dynamic var content: String?
    dynamic var contentPost: String?
    dynamic var contentPre: String?
    dynamic var date: String?
    dynamic var highlightId: String?
    let page = RealmOptional<Int>()
    dynamic var type: String?
    let currentPagerPostion = RealmOptional<Int>()
    let currentWebviewScrollPos = RealmOptional<Int>()
    dynamic var note: String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class UserProfile: Object {
    dynamic var id = 0
    dynamic var name = ""
    dynamic var email: String?
    dynamic var passwd: String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
