//
//  IntervalQueueInitProtocol.swift
//  IntervalQueue
//
//  Created by Hussein Habibi on 2/18/18.
//  Copyright © 2018 Hussein.Juybari. All rights reserved.
//

import Foundation

/**
 Protocol of constructors in IntervalQueue
 */
protocol IntervalQueueInitProtocol {
    /**
     Constructor for get instantiate of queue which has Infinite length.
     */
    func initInfiniteLength()
    
    /**
     Constructor for get instantiate of queue which has @max length.
     
     NOTE : If queue was full, skipping queuing objects.
     
     NOTE : If maxLength paramter was less than 1, queue use Infinit length.
     
     - parameters:
     - maxLength: maximum length of queue.
     */
    func initWithMax(_ maxLength: NSInteger)
    
    /**
     Constructor for get instantiate of queue
     
     - parameters:
     - intervalTime: dequeue from queue in interval was set
     */
    func initWithInterval(_ intervalTime:TimeInterval)
    
    /**
     Constructor for get instantiate of queue
     
     - parameters:
        - intervalTime: dequeue from queue in interval was set
        - dequeueCount: count of dequeue for each interval.
     */
    func initWithInterval(_ intervalTime:TimeInterval,_ dequeueCount:NSInteger)
    
    /**
     Constructor for get instantiate of queue.
     
     NOTE : If queue was full, skipping queuing objects.
     
     NOTE : If maxLength paramter was less than 1, queue use Infinit length.
     
     - parameters:
        - intervalTime: dequeue from queue in interval was set
        - maxLength: maximum length of queue.
     
     */
    func initWithIntervalAndFinitLength(_ intervalTime:TimeInterval,_ maxLength: NSInteger)
}
