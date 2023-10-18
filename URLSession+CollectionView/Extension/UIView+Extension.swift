//
//  UIView+Extension.swift
//  URLSession+CollectionView
//
//  Created by 양호준 on 2023/10/18.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach {
            self.addSubview($0)
        }
    }
}
