//
//  DetailProfileViewController.swift
//  StudyDiary
//
//  Created by Chris lee on 5/5/24.
//

import UIKit

class DetailProfileViewController: UIViewController {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var profileMessageLabel: UILabel!
    @IBOutlet weak var mbtiDescription: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var interestLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    

    var profileData: Profile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        guard let profileData = profileData else { return }
        
        // 사진을 아직 다운받기 전이라면?
        if profileData.coverImageView == nil {
            coverImageView.downloadImage(from: profileData.imageUrlToStr)
        } else {
            coverImageView.image = profileData.coverImage
        }
        
        NameLabel.text = profileData.name
        
        profileMessageLabel.text = profileData.description
        profileMessageLabel.setLineSpacing(spacing: 5)
        
        mbtiDescription.text =  profileData.mbti
        locationLabel.text = profileData.location.joined(separator: ", ")
        interestLabel.text = profileData.interest.joined(separator: ", ")
        favoriteLabel.text = profileData.favorite.joined(separator: ", ")
        
        [mbtiDescription, locationLabel, interestLabel, favoriteLabel].forEach { label in
            guard let text = label.text else { return }
            if text.isEmpty {
                label.text = "비어 있음"
            }
        }
        
    }
    
}
