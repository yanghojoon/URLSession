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
        collectionView.dragInteractionEnabled = true
        
        return collectionView
    }()
    private let networkManager = NetworkManager()
    private let disposeBag = DisposeBag()
    private var images = [Image]()
    
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
//            cell.configure(item: image)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Image>( // cellForRowAt
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, image in
                let cell = collectionView.dequeueConfiguredReusableCell(
                    using: cellRegistration,
                    for: indexPath,
                    item: image
                )
                cell.configure(item: image)
                
                return cell
        })
    }
    
    private func fetchImageData(page: Int) {
        let api = ImageListAPI(page: page)
        
        NetworkManager().fetchData(api: api, decodingType: [Image].self)
            .withUnretained(self)
            .subscribe(onNext: { vc, image in
                var snapshot = NSDiffableDataSourceSnapshot<Section, Image>() // 띄워주게 될 데이터
                snapshot.appendSections([.basic])
                snapshot.appendItems(image)
                vc.images = image
                vc.dataSource?.apply(snapshot, animatingDifferences: true)
            })
        .disposed(by: disposeBag)
    }
    //        NetworkManager().fetchData(
    //            api: ImageListAPI(page: 1),
    //            decodingType: [Image].self) { result in
    //                result.map { print($0) }
    //            }
    
    private func render() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "정렬", style: .done, target: self, action: #selector(sortSnapshot))
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc
    private func sortSnapshot() {
        images = images.sorted(by: { $0.createdAt > $1.createdAt })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Image>()
        snapshot.appendSections([.basic])
        snapshot.appendItems(images)
        
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func setAttributes() {
        collectionView.delegate = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
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

extension ViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard let item = dataSource?.itemIdentifier(for: indexPath) else {
            return []
        }
        
        let itemProvider = NSItemProvider(object: item.id as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        var destination: IndexPath = IndexPath()
        if let indexPatch = coordinator.destinationIndexPath {
            destination = indexPatch
        } else {
            let item = collectionView.numberOfItems(inSection: .zero)
            destination = IndexPath(item: item - 1, section: .zero)
        }
        
        if coordinator.proposal.operation == .move {
            editSnapshot(coordinator: coordinator, destination: destination, collectionView: collectionView)
        }
    }
    
    private func editSnapshot(
        coordinator: UICollectionViewDropCoordinator,
        destination: IndexPath,
        collectionView: UICollectionView
    ) {
        if let item = coordinator.items.first,
           let origin = item.sourceIndexPath,
           let fromItem = dataSource?.itemIdentifier(for: origin),
           let toItem = dataSource?.itemIdentifier(for: destination),
           var snapshot = dataSource?.snapshot() {
            
            if destination.row > origin.row {
                snapshot.moveItem(fromItem, afterItem: toItem)
            } else {
                snapshot.moveItem(fromItem, beforeItem: toItem)
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.dataSource?.apply(snapshot, animatingDifferences: false)
            }
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        dropSessionDidUpdate session: UIDropSession,
        withDestinationIndexPath destinationIndexPath: IndexPath?
    ) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        
        return UICollectionViewDropProposal(operation: .forbidden)
    }
}
