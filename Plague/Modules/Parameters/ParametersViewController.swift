//
//  ViewController.swift
//  Plague
//
//  Created by Enzhe Gaysina on 26.03.2024.
//

import UIKit

final class ParametersViewController: UIViewController {
    
    // MARK: - UI Elements
    private lazy var groupTextField: UITextField = {
	   let textField = UITextField()
	   textField.placeholder = Constants.placeholderGroupSize
	   textField.borderStyle = .roundedRect
	   textField.keyboardType = .numberPad
	   textField.text = ""
	   return textField
    }()
    
    private lazy var groupLabel: UILabel = {
	   let label = UILabel()
	   label.text = Constants.groupLabel
	   return label
    }()
    
    private lazy var infectionLabel: UILabel = {
	   let label = UILabel()
	   label.text = Constants.infectionLabel
	   return label
    }()
    
    private lazy var infectionTextField: UITextField = {
	   let textField = UITextField()
	   textField.placeholder = Constants.placeholderInfectionRadius
	   textField.borderStyle = .roundedRect
	   textField.keyboardType = .numberPad
	   textField.text = ""
	   return textField
    }()
    
    private lazy var periodLabel: UILabel = {
	   let label = UILabel()
	   label.text = Constants.periodLabel
	   return label
    }()
    
    private lazy var periodTextField: UITextField = {
	   let textField = UITextField()
	   textField.placeholder = Constants.placeholderPeriod
	   textField.borderStyle = .roundedRect
	   textField.keyboardType = .numberPad
	   textField.text = ""
	   return textField
    }()
    
    let startButton: UIButton = {
	   let button = UIButton(type: .system)
	   button.backgroundColor = Constants.buttonBackgroundColor
	   button.setTitle(Constants.buttonTitle, for: .normal)
	   button.layer.cornerRadius = Constants.buttonCornerRadius
	   return button
    }()
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
	   super.viewDidLoad()
	   
	   setupUI()
	   setupConstraints()
    }
    
    // MARK: - Functions
    
    private func setupUI() {
	   view.backgroundColor = .systemBackground
	   title = Constants.titleView
	   
	   view.addSubview(groupLabel)
	   view.addSubview(groupTextField)
	   view.addSubview(infectionLabel)
	   view.addSubview(infectionTextField)
	   view.addSubview(periodLabel)
	   view.addSubview(periodTextField)
	   view.addSubview(startButton)
	   
	   startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
	   let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
	   view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Setup Constraints
    
    private func setupConstraints() {
	   [groupLabel, groupTextField, infectionLabel, infectionTextField, periodLabel, periodTextField, startButton].forEach {
		  $0.translatesAutoresizingMaskIntoConstraints = false
	   }
	   NSLayoutConstraint.activate([
		  groupLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.labelTopMargin),
		  groupLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.labelLeadingMargin),
		  groupTextField.topAnchor.constraint(equalTo: groupLabel.bottomAnchor, constant: Constants.textFieldTopMargin),
		  groupTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.textFieldLeadingMargin),
		  groupTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.textFieldTrailingMargin),
		  
		  infectionLabel.topAnchor.constraint(equalTo: groupTextField.bottomAnchor, constant: Constants.labelTopMargin),
		  infectionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.labelLeadingMargin),
		  infectionTextField.topAnchor.constraint(equalTo: infectionLabel.bottomAnchor, constant: Constants.textFieldTopMargin),
		  infectionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.textFieldLeadingMargin),
		  infectionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.textFieldTrailingMargin),
		  
		  periodLabel.topAnchor.constraint(equalTo: infectionTextField.bottomAnchor, constant: Constants.labelTopMargin),
		  periodLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.labelLeadingMargin),
		  periodTextField.topAnchor.constraint(equalTo: periodLabel.bottomAnchor, constant: Constants.textFieldTopMargin),
		  periodTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.textFieldLeadingMargin),
		  periodTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.textFieldTrailingMargin),
		  
		  startButton.topAnchor.constraint(equalTo: periodTextField.bottomAnchor, constant: Constants.buttonTopMargin),
		  startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.labelLeadingMargin),
		  startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.labelLeadingMargin),
		  startButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
	   ])
    }
    
    private func validateInput() -> (groupSize: Int, infectionFactor: Int, period: Double)? {
	   return InputManager.validate(groupSize: groupTextField.text,
							  infectionFactor: infectionTextField.text,
							  period: periodTextField.text)
    }
    
    @objc
    private func hideKeyboard() {
	   groupTextField.resignFirstResponder()
	   infectionTextField.resignFirstResponder()
	   periodTextField.resignFirstResponder()
    }
    
    @objc
    private func startButtonTapped() {
	   guard let input = validateInput(),
		    let navController = self.navigationController else {
		  AlertManager.showAlert(in: self,
							title: Constants.titleAlert,
							message: Constants.alertMessage)
		  return
	   }
	   let simulationViewController = SimulationViewController(
		  groupSize: input.groupSize,
		  infectionFactor: input.infectionFactor,
		  period: input.period,
		  columns: Constants.columns
	   )
	   navController.pushViewController(simulationViewController, animated: true)
    }
}

//MARK: -  extension constants

fileprivate extension ParametersViewController {
    enum Constants {
	   static let placeholderGroupSize = "Введите количество людей"
	   static let placeholderInfectionRadius = "Введите от 1 до 8"
	   static let placeholderPeriod = "Введите от 1 до 1000"
	   static let buttonTitle = "Запустить моделирование"
	   static let groupLabel = "Количество людей:"
	   static let infectionLabel = "Радиус заражения:"
	   static let periodLabel = "Период пересчета:"
	   static let titleView = "Ввод параметров"
	   static let titleAlert = "Ошибка"
	   static let alertMessage = "Введите валидные данные"
	   static let buttonBackgroundColor = UIColor.systemGray
	   static let buttonCornerRadius: CGFloat = 8
	   static let labelTopMargin: CGFloat = 20
	   static let labelLeadingMargin: CGFloat = 16
	   static let textFieldLeadingMargin: CGFloat = 16
	   static let textFieldTrailingMargin: CGFloat = 16
	   static let textFieldTopMargin: CGFloat = 10
	   static let textFieldBottomMargin: CGFloat = 20
	   static let buttonTopMargin: CGFloat = 30
	   static let buttonHeight: CGFloat = 50
	   static let columns = 10
    }
}


