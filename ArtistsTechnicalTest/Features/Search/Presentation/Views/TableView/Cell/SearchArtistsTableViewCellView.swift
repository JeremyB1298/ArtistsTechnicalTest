//
//  SearchArtistsTableViewCellView.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 21/10/2024.
//

import UIKit

// MARK: - SearchArtistsTableViewCellViewDelegate

protocol SearchArtistsTableViewCellViewDelegate: AnyObject {
    func searchArtistsTableViewCellView(isSelected value: Bool)
}

// MARK: - SearchArtistsTableViewCellView

protocol SearchArtistsTableViewCellView {
    var delegate: SearchArtistsTableViewCellViewDelegate? { get set }
    func setTitle(value: String)
    func setSelection(value: Bool)
    func setSelectedBackground()
    func setNotSelectedBackground()
}

final class SearchArtistsTableViewCellViewImpl: UIView, SearchArtistsTableViewCellView {
    
    // MARK: - Constants
    
    private enum Constants {
        enum TitleLabel {
            static let fontSize = 18.0
            
            enum Padding {
                static let leading = 16.0
            }
            
        }
        
        enum View {
            static let cornerRadius = 10.0
        }
        
        enum SelectSwitch {
            enum Padding {
                static let top = 10.0
                static let bottom = -10.0
                static let leading = 10.0
                static let trailing = -16.0
            }
        }
    }
    
    // MARK: - Private properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Constants.TitleLabel.fontSize)
        label .textColor = UIColor(resource: .fontBlack)
        
        return label
    }()
    
    private lazy var selectSwitch: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
        
        return uiSwitch
    }()
    
    // MARK: - Public property
    
    weak var delegate: SearchArtistsTableViewCellViewDelegate?
    
    // MARK: - Initializers
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
        setupViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    func setTitle(value: String) {
        titleLabel.text = value
    }
    
    func setSelection(value: Bool) {
        selectSwitch.isOn = value
    }
    
    func setSelectedBackground() {
        backgroundColor = UIColor(resource: .backgroundBlue)
    }
    
    func setNotSelectedBackground() {
        backgroundColor = UIColor(resource: .backgroundGray)
    }
    
    // MARK: - Private methods
    
    @objc
    private func switchValueDidChange(sender: UISwitch!) {
        let value = sender.isOn
        delegate?.searchArtistsTableViewCellView(isSelected: value)
    }
    
    private func setupUI() {
        backgroundColor = .systemGray5
        layer.cornerRadius = Constants.View.cornerRadius
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(selectSwitch)
    }
    
    private func makeConstraints() {
        makeTitleLabelConstraints()
        makeSelectSwitchConstraints()
    }
    
    private func makeTitleLabelConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                titleLabel.topAnchor.constraint(equalTo: topAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.TitleLabel.Padding.leading),
                titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
            ]
        )
    }
    
    private func makeSelectSwitchConstraints() {
        selectSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                selectSwitch.topAnchor.constraint(equalTo: topAnchor, constant: Constants.SelectSwitch.Padding.top),
                selectSwitch.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.SelectSwitch.Padding.bottom),
                selectSwitch.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: Constants.SelectSwitch.Padding.leading),
                selectSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.SelectSwitch.Padding.trailing)
            ]
        )
    }
}