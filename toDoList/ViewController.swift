//
//  ViewController.swift
//  toDoList
//
//  Created by 廖昱晴 on 2021/2/20.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var label: UILabel!
    
    var task: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.dataSource = self
        tableView.delegate = self
        textField.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        label.isHidden = true
        tableView.separatorColor = .lightGray
        loadData()
        // Do any additional setup after loading the view.
    }

    @IBAction func addTask(_ sender: Any) {
        if textField.text == "" {
            let alertController = UIAlertController(title: "注意！", message: "代辦事項不得空白", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "了解", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
        } else {
            task.append(textField.text!)
            textField.text = ""
            saveData()
            tableView.reloadData()
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: true)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if task.count == 0 {
            label.isHidden = false
            tableView.separatorColor = .clear
        } else {
            label.isHidden = true
            tableView.separatorColor = .lightGray
        }
        return task.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = task[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            task.remove(at: indexPath.row)
            tableView.reloadData()
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func saveData() {
        UserDefaults.standard.set(task, forKey: "task")
    }
    
    func loadData() {
        task = UserDefaults.standard.stringArray(forKey: "task") ?? []
    }
}

