//
//  TaskTableViewController.swift
//  StudyDiary
//
//  Created by Chris lee on 5/7/24.
//

import UIKit

class TaskTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var taskManager: TaskManager?
    var taskArray: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupData()
    }
    
    
    func setupTableView() {
        // 델리게이트 패턴의 대리자 설정
        tableView.dataSource = self
        
        // 셀의 높이 설정
        tableView.rowHeight = 110
    }
    
    func setupData() {
        guard let taskManager = taskManager else { return }
        taskArray = taskManager.getTaskArray()
    }

}

extension TaskTableViewController: UITableViewDataSource {
    // 1) 테이블뷰에 몇개의 데이터를 표시할 것인지(셀이 몇개인지)를 뷰컨트롤러에게 물어봄
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    // 2) 셀의 구성(셀에 표시하고자 하는 데이터 표시)을 뷰컨트롤러에게 물어봄
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = taskArray[indexPath.row]
        
        // (힙에 올라간)재사용 가능한 셀을 꺼내서 사용하는 메서드 (애플이 미리 잘 만들어 놓음)
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        
        cell.taskNameLabel.text = task.taskName
        
        cell.colorBarView.layer.cornerRadius = 3
        cell.colorBarView.clipsToBounds = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier:"ko_KR")
        dateFormatter.dateFormat = "yyyy년 MM월 dd일" // 2020-08-13
        let dateStr = dateFormatter.string(from: task.startDate) // 현재 시간의 Date를 format에 맞춰 string으로 반환
        cell.dateLabel.text = dateStr
        
        dateFormatter.dateFormat = "a h:mm"
        let timeStr = dateFormatter.string(from: task.startDate)
        cell.durationLabel.text = timeStr
        
        cell.selectionStyle = .none
        return cell
    }
    
    
}
