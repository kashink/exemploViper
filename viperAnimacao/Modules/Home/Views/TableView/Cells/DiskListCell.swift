//
//  DiskListCell.swift
//  viperAnimacao
//
//  Created by fleury on 05/09/21.
//

import UIKit

class DiskListCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var diskList: [HomeFeedDiskEntity] = []
    var selectedDisk: IndexPath? = nil
    
    static var leftPadding = CGFloat(12)
    static var rightPadding = CGFloat(12)
    static var topPadding = CGFloat(0.0)
    static var bottomPadding = CGFloat(0.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(UINib(nibName: "DiskCell", bundle: Bundle(for: DiskCell.self)), forCellWithReuseIdentifier: "DiskCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setup(diskList: [HomeFeedDiskEntity]) {
        self.diskList = diskList
        self.collectionView.reloadData()
    }
}

extension DiskListCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.diskList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiskCell", for: indexPath) as? DiskCell else { return UICollectionViewCell() }
        
        cell.setup(
            image: self.diskList[indexPath.row].downloadedImage ?? UIImage(),
            selected: indexPath == self.selectedDisk
        )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 176, height: 176)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: DiskListCell.topPadding, left: DiskListCell.leftPadding, bottom: DiskListCell.bottomPadding, right: DiskListCell.rightPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.collectionView.scrollToItem(at:indexPath, at: .centeredHorizontally, animated: true)
        self.selectedDisk = indexPath
        self.collectionView.reloadData()
    }
}
