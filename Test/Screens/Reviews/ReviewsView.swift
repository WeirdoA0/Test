import UIKit

final class ReviewsView: UIView {

    let tableView = UITableView()
    
    var activityIndicator: UIActivityIndicatorView? = UIActivityIndicatorView(style: .large)

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds.inset(by: safeAreaInsets)
        activityIndicator?.startAnimating()
        activityIndicator?.frame = frame
    }
}

// MARK: - Private

private extension ReviewsView {

    func setupView() {
        backgroundColor = .systemBackground
        setupTableView()
        if activityIndicator != nil {
            addSubview(activityIndicator!)
        }
    }

    func setupTableView() {
        addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(ReviewCell.self, forCellReuseIdentifier: ReviewCellConfig.reuseId)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

}
