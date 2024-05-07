//
//  CalendarViewController.swift
//  StudyDiary
//
//  Created by Chris lee on 5/6/24.
//

import UIKit

@available(iOS 16.0, *)
class CalendarViewController: UIViewController {
    lazy var dateView: UICalendarView = {
        var view = UICalendarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.wantsDateDecorations = true
        return view
    }()
    
    var decorations = UICalendarView.Decoration()
    var selectedDate: [DateComponents] = []
    
    var taskManager = TaskManager()
    var flag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setCalendar()
        setupAutolayout()
    }

    // 네비게이션 바 설정
    func setupUI() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    fileprivate func setCalendar() {
        dateView.delegate = self
        
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        dateView.selectionBehavior = dateSelection
    }
    
    func setupAutolayout() {
        view.addSubview(dateView)
        
        let dateViewConstraints = [
            dateView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            dateView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            dateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ]
        
        NSLayoutConstraint.activate(dateViewConstraints)
    }
    
    func reloadDateView(date: Date?) {
        if date == nil { return }
        let calendar = Calendar.current
        dateView.reloadDecorations(forDateComponents: [calendar.dateComponents([.day, .month, .year], from: date!)], animated: true)
    }
    
    // prepare세그웨이(데이터 전달)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewTask" {
            let newTaskVC = segue.destination as! NewTaskViewController
            // 배열에서 아이템을 꺼내서, 다음화면으로 전달
            if #available(iOS 17.0, *) {
                newTaskVC.delegate = self
            }
        }
        
        if segue.identifier == "toTaskTable" {
            let taskTableVC = segue.destination as! TaskTableViewController
            // 배열에서 아이템을 꺼내서, 다음화면으로 전달
            taskTableVC.taskManager = self.taskManager
        }
    }
    
}

@available(iOS 16.0, *)
extension CalendarViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        
    }
    
    // UICalendarView
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        for selectedDateComponent in selectedDate {
            if dateComponents.year == selectedDateComponent.year &&
                dateComponents.month == selectedDateComponent.month &&
                dateComponents.day == selectedDateComponent.day{
                return UICalendarView.Decoration.default(color: .systemBlue, size: .medium)
            }
        }
        return nil
    }
}



@available(iOS 16.0, *)
extension CalendarViewController: NewTaskViewControllerDelegate {
    func dismissWithNewTask(task: Task?) {
        guard let task = task else { return }
        taskManager.addTask(task: task)
        
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_KR")
        
        let dateComponents = calendar.dateComponents(
            [.year, .month, .day],
            from: task.startDate
        )
        
        selectedDate.append(dateComponents)
        dateView.reloadDecorations(
            forDateComponents: [dateComponents],
            animated: true
        )
    }
}
