//
//  ImageCell.swift
//  URLSession+CollectionView
//
//  Created by 양호준 on 2023/10/18.
//

import UIKit

import SnapKit

final class ImageCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let createdLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private let likeCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .systemGray3
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        render()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(item: Image) {
        setImageFromStringrURL(stringUrl: item.urls.regular)
        
        createdLabel.text = item.createdAt
        likeCountLabel.text = "좋아요 눌린 갯수: \(item.likes) 개"
    }
    
    private func setImageFromStringrURL(stringUrl: String) {
        if let url = URL(string: stringUrl) {
            URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                guard let self else { return }
                guard let imageData = data else { return }
                
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: imageData)
                }
            }.resume()
        }
    }
    
    private func render() {
        contentView.addSubviews([
            imageView, createdLabel, likeCountLabel
        ])
        
        imageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(60)
        }
        
        createdLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(20)
            $0.top.equalTo(imageView.snp.top)
        }
        
        likeCountLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(20)
            $0.bottom.equalTo(imageView.snp.bottom)
        }
    }
}
