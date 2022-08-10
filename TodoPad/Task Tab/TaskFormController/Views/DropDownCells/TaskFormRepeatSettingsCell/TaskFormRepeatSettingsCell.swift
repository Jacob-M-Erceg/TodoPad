//
//  TaskFormRepeatSettingsCell.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-09.
//

import UIKit

protocol TaskFormRepeatSettingsCellDelegate: AnyObject {
    func didChangeRepeatSettings(_ repeatSettings: RepeatSettings)
}

class TaskFormRepeatSettingsCell: BaseTaskFormDropDownCell {

    static let identifier = "TaskFormRepeatSettingsCell"
    
    weak var delegate: TaskFormRepeatSettingsCellDelegate?
    
    let viewModel = TaskFormRepeatSettingsCellViewModel()
    
    
    // MARK: - UI Components
    let pickerView: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .dynamicColorTwo
        collectionView.register(RepeatingDayCell.self, forCellWithReuseIdentifier: RepeatingDayCell.identifier)
        return collectionView
    }()
    
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with taskFormCellModel: TaskFormCellModel, and repeatSettings: RepeatSettings) {
        super.configure(with: taskFormCellModel)
        self.viewModel.setRepeatSettings(repeatSettings)
        guard taskFormCellModel.isEnabled, taskFormCellModel.isExpanded else { return }
        
        self.setupUI()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        
        pickerView.selectRow(repeatSettings.number, inComponent: 0, animated: false)
        
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.selectionStyle = .none
        self.backgroundColor = .dynamicColorTwo
        
        self.addSubview(pickerView)
        self.addSubview(collectionView)
        
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pickerView.topAnchor.constraint(equalTo: self.iconImageView.bottomAnchor),
            pickerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pickerView.heightAnchor.constraint(equalToConstant: 112),
            
            collectionView.topAnchor.constraint(equalTo: pickerView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}


// MARK: - PickerView Functions
extension TaskFormRepeatSettingsCell: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.repeatSettingsTitles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constants.repeatSettingsTitles[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let repeatSetting = RepeatSettings(number: row)
        self.viewModel.setRepeatSettings(repeatSetting)
        
        self.delegate?.didChangeRepeatSettings(self.viewModel.repeatSettings)
        
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadSections(IndexSet(integer: 0))
        }
    }
}


// MARK: - CollectionView Functions
extension TaskFormRepeatSettingsCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.numberOfItemsInSection(for: section)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RepeatingDayCell.identifier, for: indexPath) as? RepeatingDayCell else {
            fatalError("Failed to dequeue TaskFormReaptingDayCell in TaskFormRepeatingCell")
        }
        
        switch self.viewModel.repeatSettings {
        case .daily, .monthly, .yearly:
            break
            
        case .weekly(let weeklyArray):
            let isDaySelected = self.viewModel.isDaySelected(for: indexPath, weeklyArray)
            cell.configure(with: Constants.weekdayLettersArray[indexPath.row], and: isDaySelected)
        }
        
        return cell
    }
    
    
    // TODO - tests
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        self.viewModel.sizeForItemAt(viewWidth: self.width)
    }
    
    
    // TODO - tests
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        self.viewModel.insetForSectionAt(
            viewWidth: self.width,
            collectionViewWidth: self.collectionView.width,
            collectionViewHeight: self.collectionView.height
        )
    }
    
    
    // TODO - tests
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.viewModel.minimumInteritemSpacingForSectionAt(viewWidth: self.width)
    }
    
    
    // TODO - tests
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        self.viewModel.didSelectItemAt(indexPath)
        self.delegate?.didChangeRepeatSettings(self.viewModel.repeatSettings)

        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadItems(at: [indexPath])
        }
    }
}
