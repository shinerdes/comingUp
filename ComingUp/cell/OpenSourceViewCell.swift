//
//  OpenSourceViewCell.swift
//  AdvancedToDoApp
//
//  Created by 김영석 on 2020/11/21.
//  Copyright © 2020 FastCampus. All rights reserved.
//

import UIKit

class OpenSourceViewCell: UITableViewCell {

    @IBOutlet weak var openSourceLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(title: String) {
        openSourceLbl.text = title
    
    }

}
