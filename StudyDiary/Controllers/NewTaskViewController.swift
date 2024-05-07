//
//  NewTaskViewController.swift
//  StudyDiary
//
//  Created by Chris lee on 5/6/24.
//


import UIKit

class NewTaskViewController: UIViewController, UITextFieldDelegate {
    // MARK: - 상단 스택 구현
    private lazy var upsideStackView: UIStackView = {
        let stview = UIStackView(arrangedSubviews: [cancelButton, subLabel, addButton])
//        stview.layer.borderWidth = 1
//        stview.layer.borderColor = UIColor.blue.cgColor
        stview.spacing = 60
        stview.axis = .horizontal
        stview.distribution = .fillEqually
        stview.alignment = .fill
        return stview
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.contentHorizontalAlignment = .left
        button.setTitle("취소", for: .normal)
        button.titleLabel?.font = UIFont.labelFontSize
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(cancleButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let subLabel: UILabel = {
        let label = UILabel()
        
        label.text = "새로운 일정"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.labelTextColor
        label.lineBreakMode = .byClipping
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.contentHorizontalAlignment = .right
        button.setTitle("추가", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - 할 일 제목 텍스트필드
    private lazy var taskNameTextfield: UITextField = {
        var tf = UITextField()
        // tf.frame.size.height = 48
        tf.text = "나의 할일"
        tf.backgroundColor = .clear
        tf.font = UIFont.taskNameFontSize
        tf.textColor = .black
        tf.tintColor = .white
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.keyboardType = .default
        return tf
    }()
    
    // MARK: - 시작 스택뷰 정의
    private lazy var startView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
    
        view.addSubview(startStackView)
        return view
    }()
    
    private lazy var startStackView: UIStackView = {
        let stview = UIStackView(arrangedSubviews: [startLabel, startDatePicker])
        stview.spacing = 0
        stview.axis = .horizontal
        stview.distribution = .fill
        stview.alignment = .fill
        return stview
    }()
    
    private let startLabel: UILabel = {
        let label = UILabel()
        
        label.text = "시작"
        label.font = UIFont.labelFontSize
        label.textColor = UIColor.labelTextColor
        return label
    }()
    
    private lazy var startDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        
        return datePicker
    }()
    
    // MARK: - 종료 스택뷰 정의
    private lazy var finishView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        view.addSubview(finishStackView)
        return view
    }()
    
    private lazy var finishStackView: UIStackView = {
        let stview = UIStackView(arrangedSubviews: [finishLabel, finishDatePicker])
        stview.spacing = 0
        stview.axis = .horizontal
        stview.distribution = .fill
        stview.alignment = .fill
        return stview
    }()
    
    private let finishLabel: UILabel = {
        let label = UILabel()
        
        label.text = "종료"
        label.font = UIFont.labelFontSize
        label.textColor = UIColor.labelTextColor
        return label
    }()
    
    private lazy var finishDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        
        return datePicker
    }()
    
    // MARK: - 설명 스택뷰 정의
    private lazy var descriptionView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        view.addSubview(descriptionTextfield)
        return view
    }()
    
    private lazy var descriptionTextfield: UITextView = {
        var tf = UITextView()
        tf.backgroundColor = .clear
        
        // textview는 placeholder 적용 안됨
        tf.text = "설명..."
        tf.textColor = UIColor.lightGray
        tf.font = UIFont.systemFont(ofSize: 17)
        tf.tintColor = .white
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.keyboardType = .default
    
        return tf
    }()
    
    // MARK: - 스택뷰 정의
    private lazy var mainStackView: UIStackView = {
        let stview = UIStackView(arrangedSubviews: [startView, finishView, descriptionView])
        stview.spacing = 15
        stview.axis = .vertical
        stview.distribution = .fill
        stview.alignment = .fill
        return stview
    }()
    
    private lazy var finalStackView: UIStackView = {
        let stview = UIStackView(arrangedSubviews: [taskNameTextfield, mainStackView])
        stview.spacing = 25
        stview.axis = .vertical
        stview.distribution = .fill
        stview.alignment = .fill
        return stview
    }()
    
    var newTask: Task?
    var delegate: NewTaskViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDelegate()
        setupAutoLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.dismissWithNewTask(task: newTask)
    }
    
    func setupUI() {
        view.backgroundColor = .systemGray6
        view.addSubview(upsideStackView)
        view.addSubview(finalStackView)
    }
    
    func setupDelegate() {
        taskNameTextfield.delegate = self
        descriptionTextfield.delegate = self
    }
    
    func setupAutoLayout() {
        let topConstant: CGFloat = 15
        let leadingConstant: CGFloat = 20
        let trailingConstant: CGFloat = -20
        
        // 상단 스택 뷰
        upsideStackView.translatesAutoresizingMaskIntoConstraints = false
        upsideStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: topConstant).isActive = true
        upsideStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: leadingConstant).isActive = true
        upsideStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: trailingConstant).isActive = true
        
        
        // 하단 스택 뷰
        finalStackView.translatesAutoresizingMaskIntoConstraints = false
        finalStackView.topAnchor.constraint(equalTo: upsideStackView.topAnchor, constant: 60).isActive = true
        finalStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        finalStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        // 시작 뷰 개별설정
        startView.translatesAutoresizingMaskIntoConstraints = false
        startView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        startStackView.translatesAutoresizingMaskIntoConstraints = false
        startStackView.leadingAnchor.constraint(equalTo: startView.leadingAnchor, constant: 13).isActive = true
        startStackView.trailingAnchor.constraint(equalTo: startView.trailingAnchor, constant: -10).isActive = true
        startStackView.centerYAnchor.constraint(equalTo: startView.centerYAnchor).isActive = true
        
        // 종료 뷰 개별설정
        finishView.translatesAutoresizingMaskIntoConstraints = false
        finishView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        finishStackView.translatesAutoresizingMaskIntoConstraints = false
        finishStackView.leadingAnchor.constraint(equalTo: finishView.leadingAnchor, constant: 13).isActive = true
        finishStackView.trailingAnchor.constraint(equalTo: finishView.trailingAnchor, constant: -10).isActive = true
        finishStackView.centerYAnchor.constraint(equalTo: finishView.centerYAnchor).isActive = true
        
        // 텍스트필드 설정
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        descriptionTextfield.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextfield.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor, constant: 10).isActive = true
        descriptionTextfield.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor, constant: -10).isActive = true
        descriptionTextfield.topAnchor.constraint(equalTo: descriptionView.topAnchor, constant: 10).isActive = true
        descriptionTextfield.bottomAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: -10).isActive = true
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - datePicker 값이 변할때마다 동작하는 함수
    @objc func dateChange(_ sender: UIDatePicker) {
        
    }
    
    @objc func cancleButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        newTask = Task(
            taskName: taskNameTextfield.text!,
            startDate: startDatePicker.date,
            finishDate: finishDatePicker.date,
            description: descriptionTextfield.text)
        dismiss(animated: true)
    }
    
}

// MARK: - description tf의 플레이스홀더 구현
extension NewTaskViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        // TextColor로 처리합니다. text로 처리하게 된다면 placeholder와 같은걸 써버리면 동작이 이상하겠죠?
        if textView.textColor == UIColor.lightGray {
            textView.text = nil // 텍스트를 날려줌
            textView.textColor = UIColor.black
        }
        
    }
    
    // UITextView의 placeholder
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "설명..."
            textView.textColor = UIColor.lightGray
        }
    }
    
}


protocol NewTaskViewControllerDelegate {
    func dismissWithNewTask(task: Task?)
}

