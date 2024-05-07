//
//  TaskManager.swift
//  StudyDiary
//
//  Created by Chris lee on 5/7/24.
//

import Foundation

class TaskManager {
    
    var taskArray: [Task] = []
    
    func getTaskArray() -> [Task] {
        return taskArray
    }
    
    func addTask(task: Task) {
        taskArray.append(task)
    }
}
