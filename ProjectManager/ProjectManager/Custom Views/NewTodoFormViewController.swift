//
//  NewTodoFormViewController.swift
//  ProjectManager
//
//  Created by 김민성 on 2021/07/05.
//

import UIKit

final class NewTodoFormViewController: UIViewController {
    
    let newTodoFormStackView = NewTodoFormStackView()
    let newTodoFormTextField = NewTodoFormTextField()
    let datePicker = UIDatePicker()
    let newTodoFormTextView = NewTodoFormTextView()

    var delegate: NewTodoFormViewControllerDelegate?
    
    var isEditMode: Bool = false
    var sentIndexPath = Int()
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "TODO"
        
        configiureNewTodoFormStackView()
        configureNewTodoFormTextField()
        configureDatePicker()
        configureNewTodoFormTextView()
        createDismissKeyboardTapGestrue()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeMode()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        disableEdit()
        clearNewTodoForm()
    }
    
    @objc private func dismissViewController() {
        dismiss(animated: true)
    }
    
    @objc private func doneViewController() {
        
        if let title = newTodoFormTextField.text, let description = newTodoFormTextView.text {
            delegate?.passModalViewData(title: title, date: datePicker.date.timeIntervalSince1970, description: description)
        }

        presentingViewController().todoTitleView.countLabel.text = String(presentingViewController().todoTableViewData.count)
        presentingViewController().todoTableView.reloadData()
        dismiss(animated: true)
    }
    
    @objc private func doneEdit() {

        if let title = newTodoFormTextField.text, let description = newTodoFormTextView.text {
            presentingViewController().updateData(tableView: self.tableView, title: title, date: datePicker.date.timeIntervalSince1970, indexPath: sentIndexPath, description: description)
        }

        presentingViewController().reloadSelectedTableView(tableView: tableView)
        dismiss(animated: true)
    }
    
    @objc func enableEdit() {
        newTodoFormTextField.isUserInteractionEnabled = true
        newTodoFormTextView.isUserInteractionEnabled = true
        datePicker.isUserInteractionEnabled = true
        
        newTodoFormTextField.becomeFirstResponder()
    }
    
    private func presentingViewController() -> ProjectManagerViewController {
        guard let presentingViewController = presentingViewController as? UINavigationController,
              let projectManagerViewController = presentingViewController.viewControllers[0] as? ProjectManagerViewController else {
            return ProjectManagerViewController()
        }
        
        return projectManagerViewController
    }
    
    func disableEdit() {
        newTodoFormTextField.isUserInteractionEnabled = false
        newTodoFormTextView.isUserInteractionEnabled = false
        datePicker.isUserInteractionEnabled = false
    }
    
    private func clearNewTodoForm() {
        newTodoFormTextField.text = ""
        newTodoFormTextView.text = ""
        datePicker.date = Date()
    }
    
    private func changeMode() {
        if isEditMode {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(enableEdit))
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneEdit))
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissViewController))
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneViewController))
        }
    }
    
    private func createDismissKeyboardTapGestrue() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    private func configureNewTodoFormTextField() {
        newTodoFormStackView.addArrangedSubview(newTodoFormTextField)

        NSLayoutConstraint.activate([
            newTodoFormTextField.heightAnchor.constraint(equalToConstant: view.frame.size.height / 19 )
        ])
    }
    
    private func configureDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        
        newTodoFormStackView.addArrangedSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            datePicker.heightAnchor.constraint(equalToConstant: view.frame.size.height / 4)
        ])
    }
    
    private func configureNewTodoFormTextView() {
        newTodoFormStackView.addArrangedSubview(newTodoFormTextView)
    }
    
    private func configiureNewTodoFormStackView() {
        view.addSubview(newTodoFormStackView)
        
        NSLayoutConstraint.activate([
            newTodoFormStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            newTodoFormStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            newTodoFormStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            newTodoFormStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
