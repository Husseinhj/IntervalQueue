//
//  IntervalQueue.swift
//  IntervalQueue
//
//  Created by Hussein Habibi on 2/18/18.
//  Copyright © 2018 Hussein.Juybari. All rights reserved.
//

import Foundation

class IntervalQueue: NSObject, IntervalQueueInitProtocol, IntervalQueueMethodsProtocol {
    
    //MARK:- Properties
    
    var maxLength: NSInteger = 0
    
    var infiniteLength: Bool = false
    
    var keepObjects: Bool = false
    
    var dequeueCount: NSInteger = 1
    
    var delegate: IntervalQueueDelegate?

    var isStartedDequeuingPeriodic: Bool {
        get { return self.timer != nil }
    }
    
    private var _intervalTime: TimeInterval = 0.0
    var intervalTime: TimeInterval {
        set {
            _intervalTime = newValue
            //Reset timer
            self.stopWorkPeriodic()
            
            //Instantiate new instance of timer with new interval
            if _intervalTime > 0 {
                self.startTimer()
            }
        }
        get {
            return _intervalTime
        }
    }
    
    //MARK:-
    
    private var timer: Timer?
    private var queueArray: Array<QueueItem>?
    
    //MARK:- init
    
    override init() {
        super.init()
        self.initQueueProperties(0, 1, 50)
    }
    
    func initInfiniteLength() {
        self.initQueueProperties(0, 1, 0)
    }
    
    func initWithMax(_ maxLength: NSInteger) {
        self.initQueueProperties(0, 1, maxLength)
    }
    
    func initWithInterval(_ intervalTime: TimeInterval) {
        self.initQueueProperties(intervalTime, 1, 0)
    }
    
    func initWithInterval(_ intervalTime: TimeInterval, _ dequeueCount: NSInteger) {
        self.initQueueProperties(intervalTime, dequeueCount, 0)
    }
    
    func initWithIntervalAndFinitLength(_ intervalTime: TimeInterval, _ maxLength: NSInteger) {
        self.initQueueProperties(intervalTime, 1, maxLength)
    }
    
    func initQueueProperties(_ intervalTime: TimeInterval, _ dequeueCount: NSInteger , _ maxLength: NSInteger) {
        self.queueArray = Array<QueueItem>.init()
        
        self.maxLength = maxLength
        self.intervalTime = intervalTime
        self.dequeueCount = dequeueCount
        
        if self.maxLength == 0 {
            self.infiniteLength = true
        }
    }
    
    //MARK:- public methods
    
    func peekFirstObject() -> NSObject? {
        if !self.isEmpty() {
            let item = self.queueArray?.first
            return item?.object
        }
        return nil
    }
    
    func peekLastObject() -> NSObject? {
        if !self.isEmpty() {
            let item = self.queueArray?.first
            return item?.object
        }
        return nil
    }
    
    func dequeue() -> NSObject? {
        let itm = dequeue(1)?.first
        return itm?.object
    }
    
    func dequeue(_ count:Int) -> Array<QueueItem>? {
        if self.isEmpty() {
            print("Sorry queue is empty :-( ......")
            return nil
        }
        
        var arrayOfObjects:[QueueItem]? = []
        
        var countOfQueue:Int = (self.queueArray?.count)!
        if countOfQueue > count {
            countOfQueue = count
        }
        
        //High priority
        let highPriObjects = self.queueArray?.filter({$0.priority == .high})
        let countOfHighPriObjects = (highPriObjects?.count)!
        
        if countOfHighPriObjects > 0 {
            if countOfHighPriObjects < countOfQueue {
                arrayOfObjects = highPriObjects!
            } else {
                let dropedArray = highPriObjects?.dropLast(countOfHighPriObjects-countOfQueue)
                arrayOfObjects = Array(dropedArray!)
            }
        }
        
        // Normal priority
        
        if arrayOfObjects?.count != count {
            let normalPriObjects = self.queueArray?.filter({$0.priority == .normal})
            let countOfNormalPriObjects = (normalPriObjects?.count)!
            
            if countOfNormalPriObjects > 0 {
                let diff = count - (normalPriObjects?.count)!
                if countOfNormalPriObjects < diff {
                    //Append two array
                    arrayOfObjects = arrayOfObjects! + normalPriObjects!
                } else {
                    let dropedArray = highPriObjects?.dropLast(countOfNormalPriObjects-diff)
                    arrayOfObjects = Array(dropedArray!)
                }
            }
        }
        
        //Low priority
        
        if arrayOfObjects?.count != count {
            let lowPriObjects = self.queueArray?.filter({$0.priority == .low})
            let countOfLowPriObjects = (lowPriObjects?.count)!
            
            if countOfLowPriObjects > 0 {
                let diff = count - (lowPriObjects?.count)!
                if countOfLowPriObjects < diff {
                    //Append two array
                    arrayOfObjects = arrayOfObjects! + lowPriObjects!
                } else {
                    let dropedArray = highPriObjects?.dropLast(countOfLowPriObjects-diff)
                    arrayOfObjects = Array(dropedArray!)
                }
            }
        }
        // Remove from it from queueArray
        let removedFromQueue = self.queueArray?.drop(while: { (mainItm) -> Bool in
            return arrayOfObjects!.contains(where: { (queueItm) -> Bool in
                return mainItm.object == queueItm.object &&
                    mainItm.priority == queueItm.priority
            })
        })
        self.queueArray = Array(removedFromQueue!)
        
        if arrayOfObjects?.count == count {
            return arrayOfObjects
        }
        return nil
    }
    
    func enqueue(_ object: NSObject) -> Bool {
        return self.enqueue(object, .normal)
    }
    
    func enqueue(_ object: NSObject, _ priority: priorityType) -> Bool {
        if isFull() {
            print("Sorry queue is full :-( ......")
            return false
        }
        
        //Add object to queue array
        let item = QueueItem.init(object: object, priority: priority)
        let index = self.getIndexForThisPriority(priority)
        
        if index == -1 || index == nil {
            self.queueArray?.append(item)
        } else {
            self.queueArray?.insert(item, at: index!)
        }
        
        //If timer was stopped start it.
        if !self.isStartedDequeuingPeriodic && self.intervalTime > 0 {
            self.startTimer()
        }
        return true
    }
    
    func isFull() -> Bool {
        return maxLength == self.queueArray?.count && !self.infiniteLength
    }
    
    func isEmpty() -> Bool {
        return self.queueArray == nil || self.queueArray?.count == 0
    }
    
    func stopWorkPeriodic() {
        self.timer?.invalidate()
        self.timer = nil;
    }
    
    //MARK:- private methods
    
    private func getIndexForThisPriority(_ priority: priorityType) -> Int?{
        if priority == .high {
            let lastItem = self.queueArray?.enumerated().lazy.first(where:{$0.element.priority == .high});
            if (lastItem != nil) {
                return lastItem?.offset
            }
            return 0
        }
        return -1
    }
    
    private func startTimer(){
        if self.timer == nil {
            self.timer =  Timer.scheduledTimer(
                timeInterval: self.intervalTime,
                target      : self,
                selector    : #selector(timerTick),
                userInfo    : nil,
                repeats     : true)
        }
    }
    
    //MARK:- timer delegate
    
    @objc private func timerTick() {
        if (self.delegate != nil) {
            if self.dequeueCount > 1 {
                if ((self.delegate?.dequeueArrayWithTick) != nil) {
                    let objects = NSMutableArray.init()
                    
                    self.dequeue(self.dequeueCount)?.forEach({ (itm) in
                        objects.add(itm.object)
                    })
                    
                    self.delegate?.dequeueArrayWithTick(objects.copy() as! NSArray)
                }
            } else {
                if ((self.delegate?.dequeueWithTick) != nil) {
                    self.delegate?.dequeueWithTick(self.dequeue()!)
                }
            }
        }
    }
}
