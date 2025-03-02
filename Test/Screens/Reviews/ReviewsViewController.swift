import UIKit

final class ReviewsViewController: UIViewController {

    private lazy var reviewsView = makeReviewsView()
    private let viewModel: ReviewsViewModel

    init(viewModel: ReviewsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = reviewsView
        title = "Отзывы"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        viewModel.getReviews()
        setupRefreshController()
    }

}

// MARK: - Private

private extension ReviewsViewController {

    func makeReviewsView() -> ReviewsView {
        let reviewsView = ReviewsView()
        reviewsView.tableView.delegate = viewModel
        reviewsView.tableView.dataSource = viewModel
        return reviewsView
    }

    func setupViewModel() {
        viewModel.onStateChange = { [weak reviewsView] _ in
            DispatchQueue.main.async(execute: {
            reviewsView?.tableView.reloadData()
                reviewsView?.activityIndicator?.removeFromSuperview()
                reviewsView?.activityIndicator = nil
            })
        }
    }
    /// Pull - To - Refresh
    func setupRefreshController() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(doRefresh), for: .valueChanged)
        reviewsView.tableView.refreshControl = refreshControl
    }
    
    @objc func doRefresh(refreshControl: UIRefreshControl) {
        viewModel.reset()
        viewModel.getReviews()
        refreshControl.endRefreshing()
    }

}
