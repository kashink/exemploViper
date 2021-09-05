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
    
    var selectedDisk = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(image: UIImage, selected: Bool) {
        if !selectedDisk && !selected {
            self.rotateView(view: self.bgView, selected: selected, duration: 0)
        }
        
        self.selectedDisk = selected
        self.diskImage.image = image
        self.rotateView(view: self.bgView, selected: selected, duration: 1)
    }
    
    func downloadFromUrl(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func rotateView(view:UIView, selected: Bool, duration: Double) {
        UIView.animate(withDuration: duration, animations: {
            var transform: CATransform3D = CATransform3DMakeRotation(0, 0, 0, 0)
            
            if selected {
                transform = CATransform3DRotate(transform, 0, 0, 1, 0)
            } else {
                transform = CATransform3DRotate(transform, 90, 0, 1, 0)
            }
            
            view.layer.transform = transform
        })
    }
}
