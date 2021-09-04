//
//  HomeViewController.swift
//  viperAnimacao
//
//  Created by fleury on 04/09/21.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var presenter: HomePresenterInterface!
    private let disposeBag = DisposeBag()
    
    init() {
        super.init(nibName: "HomeViewController", bundle: Bundle(for: HomeViewController.self))
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        collectionView.register(UINib(nibName: "TabCell", bundle: Bundle(for: TabCell.self)), forCellWithReuseIdentifier: "TabCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        presenter.outputs.isLoading
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { _ in
//                print(isLoading)
            }).disposed(by: disposeBag)
        
        presenter.outputs.homeData
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.collectionView.reloadData()
            }).disposed(by: disposeBag)
        
        presenter.outputs.error
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { _ in
//                self?.tableView.reloadData()
            }).disposed(by: disposeBag)
        
        presenter.inputs.viewDidLoadTrigger.onNext(())
    }
}

extension HomeViewController: Viewable {}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presenter.outputs.homeData.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabCell", for: indexPath) as? TabCell else { return UICollectionViewCell() }
        
        cell.setup(text: self.presenter.outputs.homeData.value[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let fakeLabel: UILabel = UILabel()
        fakeLabel.font = UIFont(name: "System", size: 17)
        fakeLabel.text = self.presenter.outputs.homeData.value[indexPath.row]
        return CGSize(width: fakeLabel.intrinsicContentSize.width + 24, height: 76)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: TabCell.topPadding, left: TabCell.leftPadding, bottom: TabCell.bottomPadding, right: TabCell.rightPadding)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }

}
