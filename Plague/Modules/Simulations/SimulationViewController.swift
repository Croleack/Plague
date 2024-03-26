//
//  SimulationViewController.swift
//  Plague
//
//  Created by Enzhe Gaysina on 26.03.2024.
//

import UIKit

final class SimulationViewController: UIViewController {
    
    private lazy var healthyLabel: UILabel = {
	   let label = UILabel()
	   label.text = "\(Constants.healthyText) \(healthyCount)"
	   label.textColor = .label
	   label.font = UIFont.systemFont(ofSize: Constants.fontLabel,
							    weight: .semibold)
	   label.backgroundColor = UIColor.systemBlue.withAlphaComponent(Constants.withAlphaLabel)
	   label.layer.cornerRadius = Constants.cornerRadiusLabel
	   label.layer.masksToBounds = true
	   label.textAlignment = .center
	   label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
	   return label
    }()
    
    private lazy var infectedLabel: UILabel = {
	   let label = UILabel()
	   label.text = "\(Constants.infectedText) \(infectedCount)"
	   label.textColor = .label
	   label.font = UIFont.systemFont(ofSize: Constants.fontLabel,
							    weight: .semibold)
	   label.backgroundColor = UIColor.systemRed.withAlphaComponent(Constants.withAlphaLabel)
	   label.layer.cornerRadius = Constants.cornerRadiusLabel
	   label.layer.masksToBounds = true
	   label.textAlignment = .center
	   label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
	   return label
    }()
    
    private let groupSize: Int
    private let infectionFactor: Int
    private let period: Double
    private let columns: Int
    private var samples: [Sample]
    private var healthyCount: Int
    private var infectedCount: Int
    private var collectionView: UICollectionView?
    private var scale: CGFloat = Constants.scale
    
    // MARK: - init
    
    init(groupSize: Int, infectionFactor: Int, period: Double, columns: Int = Constants.columns) {
	   self.groupSize = groupSize
	   self.infectionFactor = infectionFactor
	   self.period = period
	   self.columns = columns
	   
	   let initialPeople = Array(repeating: Sample(healthStatus: .healthy), count: groupSize)
	   self.samples = initialPeople
	   self.healthyCount = groupSize
	   self.infectedCount = .zero
	   
	   super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
	   fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
	   super.viewDidLoad()
	   
	   title = Constants.titleView
	   view.backgroundColor = .systemBackground
	   
	   setupCollectionView()
	   setupHealthyInfectedLabels()
	   setupTimer()
    }
    
    // MARK: - functions
    
    private func setupHealthyInfectedLabels() {
	   healthyLabel.translatesAutoresizingMaskIntoConstraints = false
	   infectedLabel.translatesAutoresizingMaskIntoConstraints = false
	   
	   view.addSubview(healthyLabel)
	   view.addSubview(infectedLabel)
	   
	   setupConstraints()
    }
    
    private func setupConstraints() {
	   guard let collectionView = collectionView else {
		  fatalError("collectionView is nil.")
	   }
	   
	   collectionView.translatesAutoresizingMaskIntoConstraints = false
	   NSLayoutConstraint.activate([
		  healthyLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
									 constant: Constants.constraintTop),
		  healthyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
										constant: Constants.constraintHorizontal),
		  healthyLabel.widthAnchor.constraint(equalToConstant: Constants.constraintWidth),
		  
		  infectedLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
									  constant: Constants.constraintTop),
		  infectedLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
										  constant: -Constants.constraintHorizontal),
		  infectedLabel.widthAnchor.constraint(equalToConstant: Constants.constraintWidth),
		  
		  collectionView.topAnchor.constraint(equalTo: infectedLabel.bottomAnchor,
									   constant: Constants.constraintTop),
		  collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
										  constant: Constants.constraintHorizontal),
		  collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
										   constant: -Constants.constraintHorizontal),
		  collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
	   ])
    }
    
    private func setupCollectionView() {
	   let layout = UICollectionViewFlowLayout()
	   layout.minimumInteritemSpacing = Constants.minimumInteritemSpacing
	   layout.minimumLineSpacing = Constants.minimumInteritemSpacing
	   
	   let topPadding: CGFloat = Constants.topPadding
	   collectionView = UICollectionView(
		  frame: CGRect(
			 x: view.bounds.origin.x,
			 y: view.bounds.origin.y + topPadding,
			 width: view.bounds.width,
			 height: view.bounds.height - topPadding),
		  collectionViewLayout: layout)
	   collectionView?.delegate = self
	   collectionView?.dataSource = self
	   collectionView?.backgroundColor = .systemBackground
	   collectionView?.register(SampleCell.self,
						   forCellWithReuseIdentifier: SampleCell.reuseIdentifier
	   )
	   
	   if let collectionView = collectionView {
		  view.addSubview(collectionView)
	   } else {
		  fatalError("collectionView is nil.")
	   }
	   
    }
    
    private func setupTimer() {
	   Timer.scheduledTimer(withTimeInterval: period, repeats: true) { [weak self] _ in
		  self?.spreadInfection()
	   }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
	   infectSample(at: indexPath.item)
	   collectionView.performBatchUpdates({
		  collectionView.reloadItems(at: [indexPath])
	   }, completion: nil)
    }
    
    private func infectSample(at index: Int) {
	   guard samples[index].healthStatus == .healthy else { return }
	   samples[index].healthStatus = .infected
	   infectedCount += 1
	   healthyCount -= 1
	   updateHealthyInfectedLabels()
    }
    
    private func updateHealthyInfectedLabels() {
	   healthyLabel.text = "\(Constants.healthyText) \(healthyCount)"
	   infectedLabel.text = "\(Constants.infectedText) \(infectedCount)"
    }
    
    private func spreadInfection() {
	   DispatchQueue.global(qos: .background).async {
		  var newInfected = Set<Int>()
		  for (index, sample) in self.samples.enumerated() {
			 if sample.healthStatus == .infected {
				let neighbors = self.getNeighbors(of: index)
				let healthyNeighbors = neighbors.filter { self.samples[$0].healthStatus == .healthy }
				if healthyNeighbors.isEmpty { continue }
				
				let numberOfInfections = min(self.infectionFactor, healthyNeighbors.count)
				let infectedNeighbors = healthyNeighbors.shuffled().prefix(numberOfInfections)
				
				newInfected.formUnion(infectedNeighbors)
			 }
		  }
		  
		  DispatchQueue.main.async {
			 newInfected.forEach { index in
				self.infectSample(at: index)
			 }
			 self.collectionView?.reloadItems(at: newInfected.map { IndexPath(item: $0, section: .zero) })
		  }
	   }
    }
    
    private func getNeighbors(of index: Int) -> [Int] {
	   let coordinates = [(0, 1), (1, 0), (0, -1), (-1, 0)]
	   let row = index / columns
	   let column = index % columns
	   var neighbors = [Int]()
	   
	   for coordinate in coordinates {
		  let newRow = row + coordinate.0
		  let newColumn = column + coordinate.1
		  
		  if newRow >= 0 && newRow < groupSize / columns && newColumn >= 0 && newColumn < columns {
			 let neighborIndex = newRow * columns + newColumn
			 
			 if (row == newRow && abs(column - newColumn) == 1) || (column == newColumn && abs(row - newRow) == 1) {
				neighbors.append(neighborIndex)
			 }
		  }
	   }
	   
	   return neighbors
    }
}
// MARK: - UICollectionViewDataSource
extension SimulationViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
	   return groupSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
	   guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SampleCell.reuseIdentifier,
												for: indexPath) as? SampleCell else {
		  fatalError("Failed to dequeue SampleCell.")
	   }
	   cell.configure(with: samples[indexPath.item])
	   return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SimulationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
				    layout collectionViewLayout: UICollectionViewLayout,
				    sizeForItemAt indexPath: IndexPath) -> CGSize {
	   let screenWidth = UIScreen.main.bounds.width
	   let totalSpacing = CGFloat(columns - 1) * 10
	   let baseWidth = (screenWidth - totalSpacing) / CGFloat(columns)
	   let width = baseWidth * scale
	   let height = width
	   return CGSize(width: width, height: height)
    }
}

//MARK: -  extension constants

fileprivate extension SimulationViewController {
    enum Constants {
	   static let fontLabel = 16.0
	   static let withAlphaLabel = 0.3
	   static let cornerRadiusLabel = 8.0
	   static let scale = 1.0
	   static let columns = 10
	   static let healthyText = "Здоровые"
	   static let infectedText = "Зараженные"
	   static let titleView = "Моделирование"
	   static let constraintTop = 10.0
	   static let constraintHorizontal = 16.0
	   static let constraintWidth = 140.0
	   static let topPadding = 50.0
	   static let minimumInteritemSpacing = 10.0
    }
}
