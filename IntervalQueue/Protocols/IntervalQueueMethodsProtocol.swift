//
//  IntervalQueueMethods.swift
//  IntervalQueue
//
//  Created by Hussein Habibi on 2/18/18.
//  Copyright © 2018 Hussein.Juybari. All rights reserved.
//

import Foundation

protocol IntervalQueueMethodsProtocol {
    
    //MARK: Properties
    var maxLength: NSInteger {get set}
    
    var infiniteLength: Bool {get set}
    
    /**
     Keep objects in queue when class was deinit or app was terminated
     */
    var keepObjects: Bool {get set}
    
    var dequeueCount : NSInteger {get set}

    /**
     Check dequeuing periodic was started or not
     */
    var isStartedDequeuingPeriodic: Bool {get}

    var intervalTime : TimeInterval {get set}
    
    var delegate : IntervalQueueDelegate? {get set}

    //MARK: dequeue
    
    /**
     Peek first object in queue and keep it in queue.
     
     - returns :
        First object in queue
     */
    func peekFirstObject() -> NSObject?
    
    /**
     Peek last object in queue and keep it in queue.
     
     - returns :
        Last object in queue
     */
    func peekLastObject() -> NSObject?
    
    /**
     Dequeue object in queue and remove it on queue.
     
     - returns :
        Objects in queue
     */
    func dequeue() -> NSObject?
    
    //MARK: enqueue
    
    /**
     Enqueue object to queue.
     
     - returns :
        Enqueue object or not.
     */
    func enqueue(_ object: NSObject) -> Bool
    
    /**
     Enqueue object to queue with priority.
     
     - parameters:
     - object : object to enqueue
     - priority : enqueue object to queue with priority. describe on priorityType
     */
    func enqueue(_ object: NSObject,_ priority:priorityType) -> Bool
    
    //MARK: states
    
    /**
     If your queue was not Infinite give you state of queue for checking is full or not
     
     - returns :
        Is full or not
     */
    func isFull() -> Bool
    
    /**
     Checking is queue empty or not
     
     - returns :
        Is empty or not
     */
    func isEmpty() -> Bool
    
    //MARK: methods
    
    /**
     Stop dequeuing periodic
     */
    func stopWorkPeriodic()
}
