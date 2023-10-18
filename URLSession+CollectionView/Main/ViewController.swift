//
//  ViewController.swift
//  URLSession+CollectionView
//
//  Created by 양호준 on 2023/10/15.
//

import UIKit

import RxSwift

final class ViewController: UIViewController {
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager().fetchData(api: ImageListAPI(page: 1), decodingType: [Image].self).subscribe(onNext: { image in
            dump(image)
        })
        .disposed(by: disposeBag)
    }
}

