//
//  StatsController.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-02.
//

import UIKit

class StatsController: UIViewController {
    
    // MARK: - Variables
    private(set) var header: StatsTableViewHeader?
    let viewModel: StatsControllerViewModel
    
    
    // MARK: - UI Components
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(StatsCell.self, forCellReuseIdentifier: StatsCell.identifier)
        tableView.backgroundColor = .dynamicColorOne
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 66, right: 0)
        tableView.separatorStyle = .none
        return tableView
    }()
    

    // MARK: - Lifecycle
    init(_ viewModel: StatsControllerViewModel = StatsControllerViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .dynamicColorOne
        self.setupUI()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.fetchData()
        
        let tasksCompletedCount = self.viewModel.fetchTotalTasksCompletedCount()
        let level = Level(tasksCompleted: tasksCompletedCount)
        self.header?.configure(level: level)
    }

    
    // MARK: - UI Setup
    private func setupUI() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"), style: .plain, target: self, action: #selector(didTapSortButton))
        
        self.view.backgroundColor = .dynamicColorOne
        
        self.header = StatsTableViewHeader(frame: CGRect(x: 0, y: 0, width: view.width, height: 393))
        self.tableView.tableHeaderView = self.header
        
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
    
    
    // MARK: - Selectors
    @objc private func didTapSortButton() {
        let alert = UIAlertController(title: "Sort by...", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Name", style: .default) { [weak self] _ in
            self?.viewModel.setSortingOptions(with: .name)
        })
        
        alert.addAction(UIAlertAction(title: "Time of Day", style: .default) { [weak self] _ in
            self?.viewModel.setSortingOptions(with: .timeOfDay)
        })
        
        alert.addAction(UIAlertAction(title: "Ratio", style: .default) { [weak self] _ in
            self?.viewModel.setSortingOptions(with: .ratio)
        })
        
        alert.addAction(UIAlertAction(title: "Days Completed", style: .default) { [weak self] _ in
            self?.viewModel.setSortingOptions(with: .daysCompleted)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}


// MARK: - Tableview Functions - Main
extension StatsController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.repeatingTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StatsCell.identifier, for: indexPath) as? StatsCell else {
            return UITableViewCell()
        }
        let repeatingTaskStats = self.viewModel.repeatingTasks[indexPath.row]
        cell.configure(repeatingTaskStats: repeatingTaskStats)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 119
    }
}



























/*
 //        if #available(iOS 14.0, *) {
 //            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil, image: UIImage(systemName: "arrow.up.arrow.down"), primaryAction: nil, menu: demoMenu)
 //        } else {
             // Fallback on earlier versions
 //          self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"), style: .plain, target: self, action: #selector(didTapSortButton))
 //        }
 
 var demoMenu: UIMenu {
     return UIMenu(title: "My menu", image: nil, identifier: nil, options: [], children: menuItems)
 }
 
 var menuItems: [UIAction] {
     return [
         UIAction(title: "Standard item", image: UIImage(systemName: "sun.max"), handler: { (_) in
         }),
         UIAction(title: "Disabled item", image: UIImage(systemName: "moon"), attributes: .disabled, handler: { (_) in
         }),
         UIAction(title: "Delete..", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { (_) in
         })
     ]
 }
 
 @objc private func didTapSortButton() {
     let alert = UIAlertController(title: "Sort by...", message: nil, preferredStyle: .actionSheet)
     
     alert.addAction(UIAlertAction(title: "Name", style: .default) { [weak self] _ in
         self?.viewModel.setSortingOptions(with: .name)
     })
     
     alert.addAction(UIAlertAction(title: "Time of Day", style: .default) { [weak self] _ in
         self?.viewModel.setSortingOptions(with: .timeOfDay)
     })
     
     alert.addAction(UIAlertAction(title: "Ratio", style: .default) { [weak self] _ in
         self?.viewModel.setSortingOptions(with: .ratio)
     })
     
     alert.addAction(UIAlertAction(title: "Days Completed", style: .default) { [weak self] _ in
         self?.viewModel.setSortingOptions(with: .daysCompleted)
     })
     
     alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
     
     self.present(alert, animated: true, completion: nil)
 }
 
 */

/*
 @objc private func didTapSortButton() {
     let alert = UIAlertController(title: "Sort", message: nil, preferredStyle: .actionSheet)
     
     let aToZ = UIAlertAction(title: "Sort Alphabetically (A-Z)", style: .default)
     aToZ.setValue(UIImage(named: "sort-a-z")!, forKey: "image")
     alert.addAction(aToZ)
     
     let zToA = UIAlertAction(title: "Sort Alphabetically (Z-A)", style: .default)
     zToA.setValue(UIImage(named: "sort-z-a")!, forKey: "image")
     alert.addAction(zToA)
     
     let asc = UIAlertAction(title: "Sort Ascending (Ratio)", style: .default)
     asc.setValue(UIImage(named: "sort-asc")!, forKey: "image")
     alert.addAction(asc)
     
     let desc = UIAlertAction(title: "Sort Descending (Ratio)", style: .default)
     desc.setValue(UIImage(named: "sort-desc")!, forKey: "image")
     alert.addAction(desc)
     
     let ascDays = UIAlertAction(title: "Sort Ascending (Days Completed)", style: .default)
     ascDays.setValue(UIImage(named: "sort-asc")!, forKey: "image")
     alert.addAction(ascDays)
     
     let descDays = UIAlertAction(title: "Sort Descending (Days Completed)", style: .default)
     descDays.setValue(UIImage(named: "sort-desc")!, forKey: "image")
     alert.addAction(descDays)
     
     alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
     
     self.present(alert, animated: true, completion: nil)
 }
 */
