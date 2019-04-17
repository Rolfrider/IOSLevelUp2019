import UIKit

class JokeViewController: UIViewController {

	let jokeProvider: JokeProviding
	lazy var refreshButton: UIButton = UIButton(type: .system)
	lazy var jokeLabel: UILabel = UILabel()
    let networkActivityIndicatorAdapter: NetworkActivityIndicatorAdapting

    init(jokeProvider: JokeProviding = JokeNetworkProvider(), networkActivityIndicatorAdapter: NetworkActivityIndicatorAdapting = NetworkActivityIndicatorAdapter()) {
        self.networkActivityIndicatorAdapter = networkActivityIndicatorAdapter
		self.jokeProvider = jokeProvider
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) { return nil }

	override func loadView() {
		self.view = UIView()
		view.backgroundColor = .white
		setupRefreshButton()
		setupJokeLabel()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.addSubview(refreshButton)
		view.addSubview(jokeLabel)
		setupLayout()
	}

	@objc func refreshJoke() {
		refreshButton.isUserInteractionEnabled = false
        networkActivityIndicatorAdapter.networkActivityIndicator(isVisible: true)
		jokeProvider.fetch { [weak self] result in
			self?.complete(joke: try? result.get())
		}
	}

	// MARK - Private

	private func complete(joke: Joke?) {
		self.jokeLabel.text = joke?.content ?? "Error"
        self.networkActivityIndicatorAdapter.networkActivityIndicator(isVisible: false)
		self.refreshButton.isUserInteractionEnabled = true
	}

	private func setupRefreshButton() {
		refreshButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
		refreshButton.setTitle("Fetch Joke!", for: [])
		refreshButton.addTarget(self, action: #selector(refreshJoke), for: .touchUpInside)
	}

	private func setupJokeLabel() {
		jokeLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
		jokeLabel.numberOfLines = 0
		jokeLabel.textAlignment = .center
	}

	private func setupLayout() {
		refreshButton.translatesAutoresizingMaskIntoConstraints = false
		jokeLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			refreshButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			refreshButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40),

			jokeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			jokeLabel.lastBaselineAnchor.constraint(equalTo: refreshButton.topAnchor, constant: -60),
			jokeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.leadingAnchor),
			jokeLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.trailingAnchor),
		])

	}
}
