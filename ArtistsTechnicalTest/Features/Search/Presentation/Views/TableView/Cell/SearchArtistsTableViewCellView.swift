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
    
    /// Notifies the delegate of a selection change in the cell.
    /// - Parameter value: A Boolean indicating whether the cell is selected.
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
    
    /// A collection of constants used for layout and appearance.
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
    
    // The label displaying the title of the artist.
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        // Set font size
        label.font = .boldSystemFont(ofSize: Constants.TitleLabel.fontSize)
        
        // Set text color
        label.textColor = UIColor(resource: .fontBlack)
        
        // Set compression resistance
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return label
    }()
    
    /// The switch used to select or deselect the artist.
    private lazy var selectSwitch: UISwitch = {
        let uiSwitch = UISwitch()
        
        // Add target for value changes
        uiSwitch.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
        
        // Set compression resistance
        uiSwitch.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        return uiSwitch
    }()
    
    // MARK: - Public property
    
    /// A weak reference to the delegate that handles cell selection events.
    weak var delegate: SearchArtistsTableViewCellViewDelegate?
    
    // MARK: - Initializers
    
    /// Initializes a new instance of `SearchArtistsTableViewCellViewImpl`.
    /// This initializer sets up the view and its subviews.
    init() {
        super.init(frame: .zero)
        
        // Set up UI properties
        setupUI()
        
        // Add subviews
        setupViews()
        
        // Configure layout constraints
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    /// Sets the title for the cell.
    /// - Parameter value: The title text to display.
    func setTitle(value: String) {
        
        // Update the title label with the provided text
        titleLabel.text = value
    }
    
    /// Updates the selection state of the switch.
    /// - Parameter value: The new selection state.
    func setSelection(value: Bool) {
        
        // Set the switch state based on the selection value
        selectSwitch.isOn = value
    }
    
    /// Sets the background color when the cell is selected.
    func setSelectedBackground() {
        
        // Set the background color for selection
        backgroundColor = UIColor(resource: .backgroundBlue)
    }
    
    /// Sets the background color when the cell is not selected.
    func setNotSelectedBackground() {
        
        // Set the background color for unselection
        backgroundColor = UIColor(resource: .backgroundGray)
    }
    
    // MARK: - Private methods
    
    /// Called when the switch value changes.
    @objc
    private func switchValueDidChange(sender: UISwitch!) {
        
        // Get the new state of the switch
        let value = sender.isOn
        
        // Notify the delegate of the change
        delegate?.searchArtistsTableViewCellView(isSelected: value)
    }
    
    /// Sets up the UI properties.
    private func setupUI() {
        
        // Set the initial background color
        backgroundColor = .systemGray5
        
        // Set the corner radius
        layer.cornerRadius = Constants.View.cornerRadius
    }
    
    /// Adds subviews to the cell.
    private func setupViews() {
        
        // Add the title label as a subview
        addSubview(titleLabel)
        
        // Add the switch as a subview
        addSubview(selectSwitch)
    }
    
    /// Configures layout constraints for subviews.
    private func makeConstraints() {
        
        // Set constraints for the title label
        makeTitleLabelConstraints()
        
        // Set constraints for the switch
        makeSelectSwitchConstraints()
    }
    
    /// Sets constraints for the title label.
    private func makeTitleLabelConstraints() {
        
        // Disable autoresizing mask
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Activate constraints
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
        
        // Disable autoresizing mask
        selectSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        // Activate constraints
        NSLayoutConstraint.activate(
            [
                selectSwitch.topAnchor.constraint(equalTo: topAnchor, constant: Constants.SelectSwitch.Padding.top),
                selectSwitch.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.SelectSwitch.Padding.bottom),
                selectSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constants.SelectSwitch.Padding.trailing)
            ]
        )
    }
}
