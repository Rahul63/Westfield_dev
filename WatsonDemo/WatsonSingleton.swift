//
//  WatsonSingleton.swift
//  WatsonDemo
//
//  Created by RAHUL on 4/6/17.
//  Copyright © 2017 Etay Luz. All rights reserved.
//

import Foundation

class watsonSingleton {
    
    static let sharedInstance : watsonSingleton = {
        let instance = watsonSingleton()
        return instance
    }()
    
    var isVoiceOn : Bool = false
    
}
