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
    @IBOutlet weak var tableView: UITableView!
    var presenter: HomePresenterInterface!
    private let disposeBag = DisposeBag()
    
    var selectedTabView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
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
        
        tableView.register(UINib(nibName: "DiskListCell", bundle: Bundle(for: DiskListCell.self)), forCellReuseIdentifier: "DiskListCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        selectedTabView.backgroundColor = UIColor.red
        self.collectionView.addSubview(selectedTabView)
        
        presenter.outputs.isLoading
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { _ in
                
            }).disposed(by: disposeBag)
        
        presenter.outputs.homeData
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.collectionView.reloadData()
                self?.tableView.reloadData()
            }).disposed(by: disposeBag)
        
        presenter.outputs.selectedTab
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] selectedTab in
                self?.collectionView.reloadData()
                self?.collectionView.performBatchUpdates(nil, completion: { _ in
                    if let indexPath = selectedTab, let frame = self?.collectionView.layoutAttributesForItem(at:indexPath)?.frame {
                        self?.collectionView.scrollToItem(at:indexPath, at: .centeredHorizontally, animated: true)
                        let animationDuration = self?.selectedTabView.frame.height == 0 ? 0.0 : 0.5
                        UIView.animate(withDuration: animationDuration, animations: {
                            self?.selectedTabView.frame = CGRect(x: frame.minX + 12, y: frame.maxY, width: frame.width - 24, height: 1)
                        })
                    }
                })
            }).disposed(by: disposeBag)
        
        presenter.outputs.error
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { _ in
            }).disposed(by: disposeBag)
        
        presenter.inputs.viewDidLoadTrigger.onNext(())
    }
}

extension HomeViewController: Viewable {}
