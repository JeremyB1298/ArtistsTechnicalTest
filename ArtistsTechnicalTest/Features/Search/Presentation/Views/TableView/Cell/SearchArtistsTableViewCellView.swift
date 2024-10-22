//
//  SearchArtistsTableViewCellView.swift
//  ArtistsTechnicalTest
//
//  Created by Jeremy  Bailly  on 21/10/2024.
//

import UIKit

// MARK: - SearchArtistsTableViewCellViewDelegate

/// A protocol defining a delegate for handling selection changes in the cell view.
protocol SearchArtistsTableViewCellViewDelegate: AnyObject {
    func searchArtistsTableViewCellView(isSelected value: Bool)
}

// MARK: - SearchArtistsTableViewCellView

/// A protocol defining the requirements for a view representing a search artist cell.
protocol SearchArtistsTableViewCellView {
    var delegate: SearchArtistsTableViewCellViewDelegate? { get set }
    
    /// Sets the title for the cell.
    /// - Parameter value: The title text to display.
    func setTitle(value: String)
    
    /// Updates the selection state of the switch.
    /// - Parameter value: The new selection state.
    func setSelection(value: Bool)
    
    /// Sets the background color when the cell is selected.
    func setSelectedBackground()
    
    /// Sets the background color when the cell is not selected.
    func setNotSelectedBackground()
}

/// A final implementation of the `SearchArtistsTableViewCellView`  protocol.
final class SearchArtistsTableViewCellViewImpl: UIView, SearchArtistsTableViewCellView {
    
    // MARK: - Constants
    
    private enum Constants {
        enum TitleLabel {
            static let fontSize = 18.0
            
            enum Padding {
                static let leading = 16.0
                static let trailing = -10.0
            }
            
        }
        
        enum View {
            static let cornerRadius = 10.0
        }
        
        enum SelectSwitch {
            enum Padding {
                static let top = 10.0
                static let bottom = -10.0
                static let trailing = -16.0
            }
        }
    }
    
    // MARK: - Private properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Constants.TitleLabel.fontSize)
        label.textColor = UIColor(resource: .fontBlack)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return label
    }()
    
    private lazy var selectSwitch: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
        uiSwitch.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
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
    
    /// Sets the title for the cell.
    /// - Parameter value: The title text to display.
    func setTitle(value: String) {
        titleLabel.text = value
    }
    
    /// Updates the selection state of the switch.
    /// - Parameter value: The new selection state.
    func setSelection(value: Bool) {
        selectSwitch.isOn = value
    }
    
    /// Sets the background color when the cell is selected.
    func setSelectedBackground() {
        backgroundColor = UIColor(resource: .backgroundBlue)
    }
    
    /// Sets the background color when the cell is not selected.
    func setNotSelectedBackground() {
        backgroundColor = UIColor(resource: .backgroundGray)
    }
    
    // MARK: - Private methods
    
    /// Called when the switch value changes.
    @objc
    private func switchValueDidChange(sender: UISwitch!) {
        let value = sender.isOn
        delegate?.searchArtistsTableViewCellView(isSelected: value)
    }
    
    /// Sets up the UI properties.
    private func setupUI() {
        backgroundColor = .systemGray5
        layer.cornerRadius = Constants.View.cornerRadius
    }
    
    /// Adds subviews to the cell.
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(selectSwitch)
    }
    
    /// Configures layout constraints for subviews.
    private func makeConstraints() {
        makeTitleLabelConstraints()
        makeSelectSwitchConstraints()
    }
    
    /// Sets constraints for the title label.
    private func makeTitleLabelConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                titleLabel.topAnchor.constraint(equalTo: topAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.TitleLabel.Padding.leading),
                titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: selectSwitch.leadingAnchor, constant: Constants.TitleLabel.Padding.trailing),
                titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
            ]
        )
    }
    
    /// Sets constraints for the select switch.
    private func makeSelectSwitchConstraints() {
        selectSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                selectSwitch.topAnchor.constraint(equalTo: topAnchor, constant: Constants.SelectSwitch.Padding.top),
                selectSwitch.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.SelectSwitch.Padding.bottom),
                selectSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.SelectSwitch.Padding.trailing)
            ]
        )
    }
}
