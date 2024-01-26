//
//  DogTableViewCell.swift
//  DogsInformation
//
//  Created by Surachet Yaitammasan on 15/1/24.
//

import UIKit

class DogTableViewCell: UITableViewCell {
	
	@IBOutlet weak var dogNameLabel: UILabel!
	@IBOutlet weak var originLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	
	func config(with data: DogsModel) {
		dogNameLabel.text = data.name
		originLabel.text = data.origin
	}
}
