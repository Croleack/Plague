//
//  SampleCell.swift
//  Plague
//
//  Created by Enzhe Gaysina on 26.03.2024.
//

import UIKit

final class SampleCell: UICollectionViewCell {
    static let reuseIdentifier = "SampleCell"
    
    private lazy var label: UILabel = {
	   let label = UILabel()
	   label.translatesAutoresizingMaskIntoConstraints = false
	   label.textAlignment = .center
	   label.font = UIFont.systemFont(ofSize: 25)
	   label.layer.cornerRadius = 10
	   label.clipsToBounds = true
	   label.text = "Период пересчета:"
	   return label
    }()
    
    override init(frame: CGRect) {
	   super.init(frame: frame)
	   setupLabel()
    }
    
    required init?(coder: NSCoder) {
	   fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with sample: Sample) {
	   switch sample.healthStatus {
	   case .healthy:
		  label.text = String(HealthStatus.healthy.rawValue)
		  label.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.3)
	   case .infected:
		  label.text = String(HealthStatus.infected.rawValue)
		  label.backgroundColor = UIColor.systemRed.withAlphaComponent(0.3)
	   }
    }
    
    private func setupLabel() {
	   
	   contentView.addSubview(label)
	   
	   NSLayoutConstraint.activate([
		  label.topAnchor.constraint(equalTo: contentView.topAnchor),
		  label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
		  label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
		  label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
	   ])
    }
}
