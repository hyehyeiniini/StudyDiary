//
//  ProfileTableViewCell.swift
//  StudyDiary
//
//  Created by Chris lee on 5/3/24.
//

import UIKit

/*
 추가해야 할 기능:
  1. profileImageView 둥그렇게 깎기
  2. profileMessageLabel border 추가, 색 변경하기
 */

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileMessageLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileMessageLabel.setLineSpacing(spacing: 4)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
    }

}
