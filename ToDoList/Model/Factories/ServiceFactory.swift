//
//  ServiceFactory.swift
//  ToDoList
//
//  Created by Nikolay Sereda on 22.06.2018.
//  Copyright © 2018 Nikolay Sereda. All rights reserved.
//

import Foundation

enum ServiceType {
    case ram
    case fileStorage
}

class ServiceFactory {
    
    static var service: ServiceProtocol?
    
    static func initService(type: ServiceType) {
        switch type {
        case .ram:
            service = Service.shared
        case .fileStorage:
            service = FileService.shared
        }
    }
}
