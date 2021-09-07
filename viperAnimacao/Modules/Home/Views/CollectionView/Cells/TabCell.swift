//
//  TabCell.swift
//  viperAnimacao
//
//  Created by Roberto Ruiz on 04/09/21.
//

import UIKit

class TabCell: UICollectionViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    
    static var leftPadding = CGFloat(12)
    static var rightPadding = CGFloat(12)
    static var topPadding = CGFloat(0.0)
    static var bottomPadding = CGFloat(0.0)
    
    static var unselectedTextFont = UIFont.systemFont(ofSize: 16, weight: .regular)
    static var selectedTextFont = UIFont.systemFont(ofSize: 18, weight: .bold)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(text: String, selected: Bool) {
        textLabel.text = text
        
        textLabel.font = selected ? TabCell.selectedTextFont : TabCell.unselectedTextFont
    }
}
