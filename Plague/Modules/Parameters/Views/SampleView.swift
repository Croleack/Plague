//
//  SampleView.swift
//  Plague
//
//  Created by Enzhe Gaysina on 26.03.2024.
//

import UIKit

final class SampleView: UIView {
    private(set) var sample: Sample
    
    init(sample: Sample) {
	   self.sample = sample
	   super.init(frame: .zero)
	   
	   setupView()
    }
    
    required init?(coder: NSCoder) {
	   fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
	   layer.cornerRadius = 8
	   backgroundColor = sample.healthStatus == .healthy ? .systemBlue : .systemRed
    }
    
    func update(with sample: Sample) {
	   self.sample = sample
	   backgroundColor = sample.healthStatus == .healthy ? .systemBlue : .systemRed
    }
}
