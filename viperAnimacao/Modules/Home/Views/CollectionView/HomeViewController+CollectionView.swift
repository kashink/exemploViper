//
//  HomeViewController+CollectionView.swift
//  viperAnimacao
//
//  Created by Roberto Ruiz on 05/09/21.
//

import UIKit
import Foundation

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presenter.outputs.homeData.value?.tabList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabCell", for: indexPath) as? TabCell else { return UICollectionViewCell() }
        
        cell.setup(
            text: self.presenter.outputs.homeData.value?.tabList[indexPath.row] ?? "",
            selected: indexPath == self.presenter.outputs.selectedTab.value
        )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let fakeLabel: UILabel = UILabel()
        fakeLabel.font = indexPath == self.presenter.outputs.selectedTab.value ? TabCell.selectedTextFont : TabCell.unselectedTextFont
        fakeLabel.text = self.presenter.outputs.homeData.value?.tabList[indexPath.row] ?? ""
        return CGSize(width: fakeLabel.intrinsicContentSize.width + 24, height: 76)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: TabCell.topPadding, left: TabCell.leftPadding, bottom: TabCell.bottomPadding, right: TabCell.rightPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.presenter.inputs.tabSelectedTrigger.onNext(indexPath)
    }
}
