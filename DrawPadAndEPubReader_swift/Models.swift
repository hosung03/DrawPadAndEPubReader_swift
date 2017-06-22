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
    let color = RealmOptional<Int>()
    let bushsize = RealmOptional<Int>()
    let points = List<DrawPoint>()
}

class DrawPoint: Object {
    dynamic var x: Double = 0
    dynamic var y: Double = 0
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
