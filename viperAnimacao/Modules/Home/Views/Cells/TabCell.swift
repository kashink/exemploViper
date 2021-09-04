//
//  TabCell.swift
//  viperAnimacao
//
//  Created by fleury on 04/09/21.
//

import UIKit

class TabCell: UICollectionViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    
    static var leftPadding = CGFloat(12)
    static var rightPadding = CGFloat(12)
    static var topPadding = CGFloat(0.0)
    static var bottomPadding = CGFloat(0.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(text: String) {
        textLabel.text = text
    }
}
