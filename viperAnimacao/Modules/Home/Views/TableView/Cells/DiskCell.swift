//
//  DiskCell.swift
//  viperAnimacao
//
//  Created by fleury on 05/09/21.
//

import UIKit

class DiskCell: UICollectionViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var diskImage: UIImageView!
    
    @IBOutlet weak var imageLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageTopConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(image: UIImage, selectedDisk: IndexPath, previousSelectedDisk: IndexPath, indexPath: IndexPath) {
        let selected = indexPath == selectedDisk
        let direction = ((selectedDisk.section + 1) - (indexPath.section + 1)) * -1
        
        self.rotateView(view: self.bgView, selected: indexPath == previousSelectedDisk, duration: 0, direction: ((previousSelectedDisk.section + 1) - (indexPath.section + 1)) * -1)
        
        self.diskImage.image = image
        
        let duration = indexPath == selectedDisk || indexPath == previousSelectedDisk ? 1 : 0
        self.rotateView(view: self.bgView, selected: selected, duration: Double(duration), direction: direction)
    }
    
    func downloadFromUrl(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func rotateView(view:UIView, selected: Bool, duration: Double, direction: Int) {
        UIView.animate(withDuration: duration, animations: {
            var constant: CGFloat = 0
            var transform: CATransform3D = CATransform3DMakeRotation(0, 0, 0, 0)
            
            transform.m34 = -1 / 500
            if selected {
                transform = CATransform3DRotate(transform, 0, 1, 1, 1)
            } else {
                constant = 15
                let angle = direction < 0 ? 45 : -45
                transform = CATransform3DRotate(transform, CGFloat(angle), 0, 1, 0)
            }
            
            view.layer.transform = transform
            self.setImageConstraints(constant: constant)
        })
    }
    
    func setImageConstraints(constant: CGFloat) {
        self.imageLeftConstraint.constant = constant
        self.imageRightConstraint.constant = constant
        self.imageBottomConstraint.constant = constant
        self.imageTopConstraint.constant = constant
    }
}
