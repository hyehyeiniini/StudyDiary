//
//  NewProfileViewController.swift
//  StudyDiary
//
//  Created by Chris lee on 5/6/24.
//

import UIKit
import PhotosUI

class NewProfileViewController: UIViewController {
    
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var mbtiTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var interestTextField: UITextField!
    @IBOutlet weak var favoriteTextField: UITextField!
    
    @IBOutlet weak var countingLabel: UILabel!
    @IBOutlet weak var neccessaryInfoLabel: UILabel!
    
    private lazy var tfArray: [UITextField] = []
    var newProfile: Profile?
    var delegate: NewProfileViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(#function )
        delegate?.dismissWithProfile(profile: newProfile)
    }
    
    func setup() {
        // ImageView 관련 설정
        // 제스처인식기 생성
        let tapImageViewRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        // 이미지뷰가 상호작용할 수 있게 설정
        coverImageView.isUserInteractionEnabled = true
        // 이미지뷰에 제스처인식기 연결
        coverImageView.addGestureRecognizer(tapImageViewRecognizer)
        // UI 관련 설정
        print("coverimageview frame height: \(coverImageView.frame.height)")
        coverImageView.layer.cornerRadius = coverImageView.frame.height / 2
        coverImageView.clipsToBounds = true
        
        // Textfield 관련 설정
        tfArray = [nameTextField, descriptionTextField, mbtiTextField, locationTextField, interestTextField, favoriteTextField]
        
        tfArray.forEach { textField in
            textField.delegate = self
            textField.autocorrectionType = .no
            textField.spellCheckingType = .no
        }
        descriptionTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - 프로필 추가 버튼 동작
    @IBAction func addButtonTapped(_ sender: Any) {
        neccessaryInfoLabel.textColor = UIColor.systemGray2
        
        if nameTextField.text!.isEmpty {
            neccessaryInfoLabel.textColor = .red
            nameTextField.layer.borderWidth = 1
            nameTextField.layer.borderColor = UIColor.red.cgColor
            nameTextField.layer.cornerRadius = 5
            nameTextField.clipsToBounds = true
            return
        } else {
            nameTextField.layer.borderWidth = 0
        }
        
        if descriptionTextField.text!.isEmpty {
            neccessaryInfoLabel.textColor = .red
            descriptionTextField.layer.borderWidth = 1
            descriptionTextField.layer.borderColor = UIColor.red.cgColor
            descriptionTextField.layer.cornerRadius = 5
            descriptionTextField.clipsToBounds = true
            return
        } else {
            nameTextField.layer.borderWidth = 0
        }
        
        newProfile = Profile(imageUrlToStr: "", coverImage: coverImageView.image, name: nameTextField.text!, description: descriptionTextField.text!, mbti: mbtiTextField.text!, location: [locationTextField.text!], interest: [interestTextField.text!], favorite: [favoriteTextField.text!])
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - 권한을 거부했을 때 띄어주는 Alert 함수
    /**
     - Parameters:
     - type: 권한 종류
     */
    func showAlert(
        _ message: String
    ) {
        if let appName = Bundle.main.infoDictionary!["CFBundleDisplayName"] as? String {
            let alertVC = UIAlertController(
                title: "설정",
                message: message,
                preferredStyle: .alert
            )
            let cancelAction = UIAlertAction(
                title: "취소",
                style: .cancel,
                handler: nil
            )
            let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            }
            alertVC.addAction(cancelAction)
            alertVC.addAction(confirmAction)
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    // MARK: 이미지뷰 클릭시 호출될 함수
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        // 갤러리 접근 권한 허용 여부 체크
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            switch status {
            case .notDetermined:
                DispatchQueue.main.async {
                    self.showAlert("갤러리를 불러올 수 없습니다. 핸드폰 설정에서 사진 접근 허용을 모든 사진으로 변경해주세요.")
                }
            case .denied, .restricted:
                DispatchQueue.main.async {
                    self.showAlert("갤러리를 불러올 수 없습니다. 핸드폰 설정에서 사진 접근 허용을 모든 사진으로 변경해주세요.")
                }
            case .authorized, .limited: // 모두 허용, 일부 허용
                self.pickImage() // ⭐️ 갤러리 불러오는 동작을 할 함수
            @unknown default:
                print("PHPhotoLibrary::execute - \"Unknown case\"")
            }
        }
    }
  
    // ⭐️ 갤러리 불러오기
    func pickImage(){
        let photoLibrary = PHPhotoLibrary.shared()
        var configuration = PHPickerConfiguration(photoLibrary: photoLibrary)

        configuration.selectionLimit = 1 //한번에 가지고 올 이미지 갯수 제한
        configuration.filter = .any(of: [.images]) // 이미지, 비디오 등의 옵션

        DispatchQueue.main.async { // 메인 스레드에서 코드를 실행시켜야함
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            picker.isEditing = true
            self.present(picker, animated: true, completion: nil) // 갤러리뷰 프리젠트
        }
    }
}


extension NewProfileViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true) // 1
        
        let itemProvider = results.first?.itemProvider // 2
        
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) { // 3
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in // 4
                DispatchQueue.main.async {
                    self.coverImageView.image = image as? UIImage // 5
                }
            }
        } else {
            // TODO: Handle empty results or item provider not being able load UIImage
        }
    }
}
    

extension NewProfileViewController: UITextFieldDelegate {
    @objc func textFieldEditingChanged() {
        let maxLength = 20
        if let text = descriptionTextField.text {
            if text.count > maxLength {
                descriptionTextField.resignFirstResponder()
            }
            
            // 초과되는 텍스트 제거
            if text.count >= maxLength {
                // 20글자 넘어가면 자동으로 키보드 내려감
                countingLabel.text = "\(maxLength)/\(maxLength)"
                countingLabel.textColor = .red
                
                let index = text.index(text.startIndex, offsetBy: maxLength)
                let newString = text[text.startIndex..<index]
                descriptionTextField.text = String(newString)
            } else {
                countingLabel.text = "\(text.count)/\(maxLength)"
                countingLabel.textColor = .gray
            }
        }
    }
    

}

protocol NewProfileViewControllerDelegate {
    func dismissWithProfile(profile: Profile?)
}
