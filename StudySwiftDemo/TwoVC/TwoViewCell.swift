//
//  TwoViewCell.swift
//  StudySwiftDemo
//
//  Created by StYiWe on 2020/9/12.
//  Copyright © 2020 stYiwe. All rights reserved.
//

import UIKit

class TwoViewCell: UITableViewCell {

    
    @IBOutlet weak var imgV: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
