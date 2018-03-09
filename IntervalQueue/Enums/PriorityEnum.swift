//
//  PriorityEnum.swift
//  IntervalQueue
//
//  Created by Hussein Habibi on 2/18/18.
//  Copyright © 2018 Hussein.Juybari. All rights reserved.
//

import Foundation

/**
 priority in queue helps to insert important object in top of the queue.
 
 normal means enqueue at last of the queue.
 
 high means enqueue at end of last high object.
 
 low means enqueue at last of the queue, which means dequeue object if high or normal priority was not exists in queue.
 */
enum priorityType: Int {
    case normal = 0, high = 1 , low = 2
}
