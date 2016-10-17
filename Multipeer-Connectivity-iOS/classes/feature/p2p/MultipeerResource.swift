//
//  MultipeerResource.swift
//  Multipeer-Connectivity-iOS
//
//  Created by Kohei Tabata on 2016/10/17.
//  Copyright © 2016年 Kohei Tabata. All rights reserved.
//

import Foundation

enum ResourceType: String {
    case text
}

struct MultipeerResource {
    let type: ResourceType
    let text: String

    init?(data: Data) {
        guard let dictionary: [String : Any] = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String : Any] else {
            return nil
        }

        guard
            let typeString: String = dictionary["type"] as? String,
            let type: ResourceType = ResourceType(rawValue: typeString),
            let text: String = dictionary["text"]  as? String else {
                return nil
        }

        self.type = type
        self.text = text
    }
}
