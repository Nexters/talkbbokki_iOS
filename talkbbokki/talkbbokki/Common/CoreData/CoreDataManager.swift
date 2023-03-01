//
//  CoreDataManager.swift
//  talkbbokki
//
//  Created by USER on 2023/02/26.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    let topic = TopicData()
    let category = CategoryData()
}


