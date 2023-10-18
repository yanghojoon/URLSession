//
//  UICollectionView+Extension.swift
//  KakaoBankAppStoreSearch
//
//  Created by 양호준 on 2023/09/17.
//

import UIKit

protocol Reusable: AnyObject {
  static var reuseIdentifier: String { get }
}

extension Reusable {
  static var reuseIdentifier: String {
    return String(describing: self)
  }
}


extension UICollectionReusableView: Reusable { }

extension UICollectionView {
    func cellForItem<T: UICollectionViewCell>(atIndexPath indexPath: IndexPath) -> T {
        guard
            let cell = cellForItem(at: indexPath) as? T
        else {
            fatalError("Could not cellForItemAt at indexPath: \(T.reuseIdentifier)")
        }

        return cell
    }

    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard
            let cell = dequeueReusableCell(
                withReuseIdentifier: T.reuseIdentifier,
                for: indexPath
            ) as? T
        else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }

    func register<T>(
        cell: T.Type,
        forCellWithReuseIdentifier reuseIdentifier: String = T.reuseIdentifier
    ) where T: UICollectionViewCell {
        register(cell, forCellWithReuseIdentifier: reuseIdentifier)
    }
}
