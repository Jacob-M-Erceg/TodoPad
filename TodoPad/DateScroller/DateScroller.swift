//
//  DateScroller.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-02.
//

import UIKit

protocol DateScrollerDelegate: AnyObject {
    func didChangeDate(with date: Date)
}

class DateScroller: UIView, UIGestureRecognizerDelegate {
    
    // MARK: - Variables
    let viewModel: DateScrollerViewModel
    
    weak var delegate: DateScrollerDelegate?
    
    // MARK: - UI Components
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .dynamicColorOne
        collectionView.register(DateScrollerCell.self, forCellWithReuseIdentifier: DateScrollerCell.identifier)
        collectionView.alwaysBounceVertical = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - Lifecycle
    init(_ viewModel: DateScrollerViewModel = DateScrollerViewModel()) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.setupUI()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(didLeftSwipe))
        leftSwipeGesture.direction = .left
        leftSwipeGesture.delegate = self
        
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(didRightSwipe))
        rightSwipeGesture.direction = .right
        rightSwipeGesture.delegate = self
        
        self.addGestureRecognizer(leftSwipeGesture)
        self.addGestureRecognizer(rightSwipeGesture)
        
        self.backgroundColor = .red
        
        self.viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.backgroundColor = .dynamicColorOne
        
        for day in Constants.weekdaysArray {
            let label = UILabel.createDateScrollerSubLabel(day)
            stackView.addArrangedSubview(label)
        }
        
        addSubview(stackView)
        addSubview(collectionView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 33),
            
            collectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    // MARK: - Selectors
    @objc func didLeftSwipe() {
        self.viewModel.updateSunday(direction: .left)
    }
    
    @objc func didRightSwipe() {
        self.viewModel.updateSunday(direction: .right)
    }
    
    // iPad Gesture Recognizer is not called properly on iPad without this.
    // It won't swipe over CollectionView without this.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


// MARK: - CollectionView
extension DateScroller: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateScrollerCell.identifier, for: indexPath) as? DateScrollerCell else {
            fatalError("Failed to dequeue DateScrollerCell cell.")
        }
        
        let date = DateHelper.addDays(self.viewModel.currentSunday, offset: indexPath.row)
        cell.configure(with: date)
        cell.setSelection(with: self.viewModel.selectedDate)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.size.width/7, height: 33)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = self.collectionView.dataSource?.collectionView(self.collectionView, cellForItemAt: indexPath) as? DateScrollerCell  else { return }

        self.delegate?.didChangeDate(with: cell.date)
        self.viewModel.setSelectedDate(with: cell.date)

        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}
