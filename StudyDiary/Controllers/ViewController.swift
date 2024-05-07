//
//  ViewController.swift
//  StudyDiary
//
//  Created by Chris lee on 5/3/24.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    var profileArray: [Profile] = []
    var profileDataManager = ProfileDatagManager()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupData()
    }

    func setupTableView() {
        // 델리게이트 패턴의 대리자 설정
        tableView.dataSource = self
        tableView.delegate = self
        
        // 셀의 높이 설정
        tableView.rowHeight = 110
    }
    
    func setupData() {
        profileDataManager.getProfileArray(){ profiles in
            guard let profiles = profiles else { return }
            
            // 데이터를 성공적으로 받아오고 난 이후
            self.profileArray = profiles
            
            // 테이블뷰 리로드
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        // 새 프로필 추가 화면으로 이동
        performSegue(withIdentifier: "toNewProfile", sender: sender)
    }
    
}

extension ViewController: UITableViewDataSource {
    // 1) 테이블뷰에 몇개의 데이터를 표시할 것인지(셀이 몇개인지)를 뷰컨트롤러에게 물어봄
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileArray.count
    }
    
    // 2) 셀의 구성(셀에 표시하고자 하는 데이터 표시)을 뷰컨트롤러에게 물어봄
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profile = profileArray[indexPath.row]
        
        // (힙에 올라간)재사용 가능한 셀을 꺼내서 사용하는 메서드 (애플이 미리 잘 만들어 놓음)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
        
        /* 이 코드.. 뭔가 문제가 있다.
        // 사진을 아직 다운받기 전이라면?
        if profile.coverImage == nil {
            cell.profileImageView.downloadImage(from: profile.imageUrlToStr)
            // 다운받은 이후에 사진 저장? -> 여기서 동기화 문제 발생하는듯..
            profileArray[indexPath.row].coverImage = cell.profileImageView.image
        } else {
            cell.profileImageView.image = profile.coverImage
        }
         */
        
        if profile.coverImage != nil {
            cell.profileImageView.image = profile.coverImage
        } else {
            cell.profileImageView.downloadImage(from: profile.imageUrlToStr)
        }
        
        
        cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.height / 2
        cell.profileImageView.clipsToBounds = true
        cell.nameLabel.text = profile.name
        cell.profileMessageLabel.text = profile.description
        cell.selectionStyle = .none
        return cell
    }
    
    
}


extension ViewController: UITableViewDelegate {
    // 셀이 선택이 되었을때 어떤 동작을 할 것인지 뷰컨트롤러에게 물어봄
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 세그웨이를 실행(예시코드)
        performSegue(withIdentifier: "toDetail", sender: indexPath)
    }
    
    // prepare세그웨이(데이터 전달)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            let detailVC = segue.destination as! DetailProfileViewController
            let index = sender as! IndexPath
            
            // 배열에서 아이템을 꺼내서, 다음화면으로 전달
            detailVC.profileData = profileArray[index.row]
        }
        
        if segue.identifier == "toNewProfile" {
            let newProfileVC = segue.destination as! NewProfileViewController
            newProfileVC.delegate = self
        }
    }
}

extension ViewController: NewProfileViewControllerDelegate {
    func dismissWithProfile(profile: Profile?) {
        if let profile = profile {
            print("새 프로필 추가: \(profile)")
            profileArray.append(profile)
            tableView.reloadData()
        }
    }
}
