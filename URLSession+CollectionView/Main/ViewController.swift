//
//  ViewController.swift
//  URLSession+CollectionView
//
//  Created by 양호준 on 2023/10/15.
//

import UIKit

import RxSwift
import SnapKit

final class ViewController: UIViewController {
    enum Section: CaseIterable {
        case basic
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 4
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGray6
        collectionView.showsHorizontalScrollIndicator = false
        
        
        return collectionView
    }()
    private let networkManager = NetworkManager()
    private let disposeBag = DisposeBag()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Image>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAttributes()
        render()
        configureDataSource()
        fetchImageData(page: 1)
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ImageCell, Image> { cell, indexPath, image in // register
            cell.configure(item: image)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Image>( // cellForRowAt
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, image in
                let cell = collectionView.dequeueConfiguredReusableCell(
                    using: cellRegistration,
                    for: indexPath,
                    item: image
                )
                
                return cell
        })
    }
    
    private func fetchImageData(page: Int) {
        let api = ImageListAPI(page: page)
        
//        NetworkManager().fetchData(
//            api: ImageListAPI(page: 1),
//            decodingType: [Image].self) { result in
//                result.map { print($0) }
//            }
        
        NetworkManager().fetchData(api: api, decodingType: [Image].self)
            .withUnretained(self)
            .subscribe(onNext: { vc, image in
                var snapshot = NSDiffableDataSourceSnapshot<Section, Image>() // 띄워주게 될 데이터
                snapshot.appendSections([.basic])
                snapshot.appendItems(image)
                vc.dataSource?.apply(snapshot, animatingDifferences: true)
            })
        .disposed(by: disposeBag)
    }
    
    private func render() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setAttributes() {
        collectionView.delegate = self
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: view.bounds.width, height: 100)
    }
}
