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
    var selectedDisk: IndexPath = IndexPath(row: 0, section: 0)
    var previousSelectedDisk: IndexPath = IndexPath(row: 0, section: 0)
    
    static var leftPadding = CGFloat(0.0)
    static var rightPadding = CGFloat(0.0)
    static var topPadding = CGFloat(0.0)
    static var bottomPadding = CGFloat(0.0)
    
    static var unselectedOffset = CGFloat(-50.0)
    
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.diskList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiskCell", for: indexPath) as? DiskCell else { return UICollectionViewCell() }
        
        cell.setup(
            image: self.diskList[indexPath.section].downloadedImage ?? UIImage(),
            selectedDisk: self.selectedDisk,
            previousSelectedDisk: self.previousSelectedDisk,
            indexPath: indexPath
        )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case self.selectedDisk.section:
            return UIEdgeInsets.init(top: DiskListCell.topPadding, left: DiskListCell.leftPadding, bottom: DiskListCell.bottomPadding, right: DiskListCell.rightPadding)
        case self.selectedDisk.section - 1:
            return UIEdgeInsets.init(top: DiskListCell.topPadding, left: DiskListCell.unselectedOffset, bottom: DiskListCell.bottomPadding, right: DiskListCell.rightPadding)
        case self.selectedDisk.section + 1:
            return UIEdgeInsets.init(top: DiskListCell.topPadding, left: DiskListCell.leftPadding, bottom: DiskListCell.bottomPadding, right: DiskListCell.unselectedOffset)
        default:
            return UIEdgeInsets.init(top: DiskListCell.topPadding, left: DiskListCell.unselectedOffset, bottom: DiskListCell.bottomPadding, right: DiskListCell.unselectedOffset)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.collectionView.scrollToItem(at:indexPath, at: .centeredHorizontally, animated: true)
        self.selectedDisk = indexPath
        self.collectionView.reloadData()
        self.collectionView.performBatchUpdates(nil, completion: { _ in
            self.previousSelectedDisk = self.selectedDisk
        })
    }
}
