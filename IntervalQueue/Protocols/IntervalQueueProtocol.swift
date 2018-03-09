//
//  IntervalQueueProtocol.swift
//  IntervalQueue
//
//  Created by Hussein Habibi on 2/18/18.
//  Copyright © 2018 Hussein.Juybari. All rights reserved.
//

import Foundation

protocol IntervalQueueDelegate: class{
    func dequeueWithTick(_ object: NSObject)
    func dequeueArrayWithTick(_ objects: NSArray)
}
