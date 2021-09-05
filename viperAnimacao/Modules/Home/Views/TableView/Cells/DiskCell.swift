//
//  DiskCell.swift
//  viperAnimacao
//
//  Created by fleury on 05/09/21.
//

import UIKit

class DiskCell: UICollectionViewCell {
    @IBOutlet weak var diskImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(urlString: String) {
        if let url = URL(string: urlString) {
            self.downloadFromUrl(from: url) { data, _, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async { [weak self] in
                    self?.diskImage.image = UIImage(data: data)
                }
            }
        }
    }
    
    func downloadFromUrl(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
