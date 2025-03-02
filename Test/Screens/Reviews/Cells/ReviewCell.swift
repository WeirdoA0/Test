import UIKit

/// Конфигурация ячейки. Содержит данные для отображения в ячейке.
struct ReviewCellConfig {

    /// Идентификатор для переиспользования ячейки.
    static let reuseId = String(describing: ReviewCellConfig.self)

    /// Идентификатор конфигурации. Можно использовать для поиска конфигурации в массиве.
    let id = UUID()
    /// Имя пользователя
    let userName: NSAttributedString
    /// Текст отзыва.
    let reviewText: NSAttributedString
    /// Рейтинг отзыва
    let reviewRating: Int
    /// Максимальное отображаемое количество строк текста. По умолчанию 3.
    var maxLines = 3
    /// Время создания отзыва.
    let created: NSAttributedString
    /// Изоббражения к отзыву
    let imageURLs: [String]
    
    /// Замыкание, вызываемое при нажатии на кнопку "Показать полностью...".
    let onTapShowMore: (UUID) -> Void
    
    ///Ссылка на класс RatinRenderer
    weak var ratingRender: RatingRenderer?
    
    /// Объект, хранящий посчитанные фреймы для ячейки отзыва.
    fileprivate let layout = ReviewCellLayout()

}

// MARK: - TableCellConfig

extension ReviewCellConfig: TableCellConfig {

    /// Метод обновления ячейки.
    /// Вызывается из `cellForRowAt:` у `dataSource` таблицы.
    func update(cell: UITableViewCell) {
        guard let cell = cell as? ReviewCell else { return }
        cell.reviewTextLabel.attributedText = reviewText
        cell.reviewTextLabel.numberOfLines = maxLines
        cell.createdLabel.attributedText = created
        cell.usernameLabel.attributedText = userName
        cell.avatarImage.image = .l5W5AIHioYc
        cell.ratingImage.image = ratingRender?.ratingImage(reviewRating)
        cell.config = self
        updateImages(cell: cell)
        

    }

    /// Метод, возвращаюший высоту ячейки с данным ограничением по размеру.
    /// Вызывается из `heightForRowAt:` делегата таблицы.
    func height(with size: CGSize) -> CGFloat {
        layout.height(config: self, maxWidth: size.width)
    }
    
    
    ///Вызываевтся в `update` ,  обновляет изображения 
    private func updateImages(cell: ReviewCell){
        cell.imagesView.reset()
        guard let strongConfig = cell.config else { return }
        if strongConfig.imageURLs.isEmpty { return }
        cell.imagesView.cornerRadius = ReviewCellLayout.photoCornerRadius
        cell.imagesView.imageSize = strongConfig.layout.getSizeForStackView()
        cell.imagesView.spacing = Int(strongConfig.layout.getSpacingForStackView())
        cell.imagesView.numberOfImages = strongConfig.imageURLs.count
        cell.imagesView.layout()
        for i in 0..<strongConfig.imageURLs.count {
            cell.imagesView.imageViews[i].loadAsyncImage(stringURL: strongConfig.imageURLs[i], failedPicture: .loadingFailed)
        }
    }

}

// MARK: - Private

private extension ReviewCellConfig {

    /// Текст кнопки "Показать полностью...".
    static let showMoreText = "Показать полностью..."
        .attributed(font: .showMore, color: .showMore)

}

// MARK: - Cell

final class ReviewCell: UITableViewCell {

    fileprivate var config: Config?

    fileprivate let reviewTextLabel = UILabel()
    fileprivate let createdLabel = UILabel()
    fileprivate let showMoreButton = UIButton()
    fileprivate let avatarImage = UIImageView()
    fileprivate let usernameLabel = UILabel()
    fileprivate let ratingImage = UIImageView()
    fileprivate let imagesView = UIHorizontalImagesView()


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let layout = config?.layout else { return }
        reviewTextLabel.frame = layout.reviewTextLabelFrame
        createdLabel.frame = layout.createdLabelFrame
        showMoreButton.frame = layout.showMoreButtonFrame
        avatarImage.frame = layout.avatarImageFrame
        usernameLabel.frame = layout.useNameLabelFrame
        ratingImage.frame = layout.ratingImageFrame
        imagesView.frame = layout.imageStackViewFrame
    }

}

// MARK: - Private

private extension ReviewCell {

    func setupCell() {
        setupReviewTextLabel()
        setupCreatedLabel()
        setupShowMoreButton()
        setupUserNameLabel()
        setupUserAvatarImage()
        setupRatingImage()
        setupImagesView()

    }

    func setupReviewTextLabel() {
        contentView.addSubview(reviewTextLabel)
        reviewTextLabel.lineBreakMode = .byWordWrapping
    }

    func setupCreatedLabel() {
        contentView.addSubview(createdLabel)
    }

    func setupShowMoreButton() {
        contentView.addSubview(showMoreButton)
        showMoreButton.contentVerticalAlignment = .fill
        showMoreButton.setAttributedTitle(Config.showMoreText, for: .normal)
        showMoreButton.addAction(
            UIAction { [weak self] _ in guard let config = self?.config else { return }
            config.onTapShowMore(config.id) },
                                  for: .touchUpInside)
    }
    
    func setupUserNameLabel() {
        contentView.addSubview(usernameLabel)
    }
    
    func setupUserAvatarImage() {
        contentView.addSubview(avatarImage)
        avatarImage.layer.masksToBounds = true
        avatarImage.layer.cornerRadius = ReviewCellLayout.avatarCornerRadius
    }
    
    func setupRatingImage() {
        contentView.addSubview(ratingImage)
    }
    
    func setupImagesView() {
        contentView.addSubview(imagesView)
    }
    


}

// MARK: - Layout

/// Класс, в котором происходит расчёт фреймов для сабвью ячейки отзыва.
/// После расчётов возвращается актуальная высота ячейки.
private final class ReviewCellLayout {

    // MARK: - Размеры

    fileprivate static let avatarSize = CGSize(width: 36.0, height: 36.0)
    fileprivate static let avatarCornerRadius = 18.0
    fileprivate static let photoCornerRadius = 8.0

    private static let photoSize = CGSize(width: 55.0, height: 66.0)
    private static let showMoreButtonSize = Config.showMoreText.size()

    // MARK: - Фреймы

    private(set) var reviewTextLabelFrame = CGRect.zero
    private(set) var showMoreButtonFrame = CGRect.zero
    private(set) var createdLabelFrame = CGRect.zero
    private(set) var avatarImageFrame = CGRect.zero
    private(set) var useNameLabelFrame = CGRect.zero
    private(set) var ratingImageFrame = CGRect.zero
    private(set) var imageStackViewFrame = CGRect.zero

    // MARK: - Отступы

    /// Отступы от краёв ячейки до её содержимого.
    private let insets = UIEdgeInsets(top: 9.0, left: 12.0, bottom: 9.0, right: 12.0)

    /// Горизонтальный отступ от аватара до имени пользователя.
    private let avatarToUsernameSpacing = 10.0
    /// Вертикальный отступ от имени пользователя до вью рейтинга.
    private let usernameToRatingSpacing = 6.0
    /// Вертикальный отступ от вью рейтинга до текста (если нет фото).
    private let ratingToTextSpacing = 6.0
    /// Вертикальный отступ от вью рейтинга до фото.
    private let ratingToPhotosSpacing = 10.0
    /// Горизонтальные отступы между фото.
    private let photosSpacing = 8.0
    /// Вертикальный отступ от фото (если они есть) до текста отзыва.
    private let photosToTextSpacing = 10.0
    /// Вертикальный отступ от текста отзыва до времени создания отзыва или кнопки "Показать полностью..." (если она есть).
    private let reviewTextToCreatedSpacing = 6.0
    /// Вертикальный отступ от кнопки "Показать полностью..." до времени создания отзыва.
    private let showMoreToCreatedSpacing = 6.0

    // MARK: - Расчёт фреймов и высоты ячейки

    /// Возвращает высоту ячейку с данной конфигурацией `config` и ограничением по ширине `maxWidth`.
    func height(config: Config, maxWidth: CGFloat) -> CGFloat {
        let width = maxWidth - insets.left - insets.right

        var maxY = insets.top
        var showShowMoreButton = false
        
        avatarImageFrame = CGRect(
            origin: CGPoint(x: insets.left , y: maxY),
            size: ReviewCellLayout.avatarSize
        )
        
        useNameLabelFrame = CGRect(
            origin: CGPoint(x: avatarImageFrame.maxX + avatarToUsernameSpacing, y: maxY),
            size: config.userName.boundingRect(width: width).size
        )
        
        maxY = useNameLabelFrame.maxY + usernameToRatingSpacing
        
        ratingImageFrame = CGRect(
            origin: CGPoint(x: useNameLabelFrame.minX, y: maxY),
            size: config.ratingRender?.imageSize() ?? .zero
        )
        
        if !config.imageURLs.isEmpty {
            
            let stackWidth = CGFloat(config.imageURLs.count) * (ReviewCellLayout.photoSize.width + photosSpacing)

            
            imageStackViewFrame = CGRect(
                origin: CGPoint(x: useNameLabelFrame.minX, y: ratingImageFrame.maxY + ratingToPhotosSpacing),
                size: CGSize(width: stackWidth, height: ReviewCellLayout.photoSize.height)
            )
            maxY = imageStackViewFrame.maxY + photosToTextSpacing
        } else {
            maxY = ratingImageFrame.maxY + ratingToTextSpacing
        }

        if !config.reviewText.isEmpty() {
            
            // Высота текста с текущим ограничением по количеству строк.
            let currentTextHeight = (config.reviewText.font()?.lineHeight ?? .zero) * CGFloat(config.maxLines)
            // Максимально возможная высота текста, если бы ограничения не было.
            let actualTextHeight = config.reviewText.boundingRect(width: width).size.height
            // Показываем кнопку "Показать полностью...", если максимально возможная высота текста больше текущей.
            showShowMoreButton = config.maxLines != .zero && actualTextHeight > currentTextHeight
            
            reviewTextLabelFrame = CGRect(
                origin: CGPoint(x: insets.left, y: maxY),
                size: config.reviewText.boundingRect(width: width, height: currentTextHeight).size
            )
            maxY = reviewTextLabelFrame.maxY + reviewTextToCreatedSpacing
        }

        if showShowMoreButton {
            showMoreButtonFrame = CGRect(
                origin: CGPoint(x: insets.left, y: maxY),
                size: Self.showMoreButtonSize
            )
            maxY = showMoreButtonFrame.maxY + showMoreToCreatedSpacing
        } else {
            showMoreButtonFrame = .zero
        }
        
        createdLabelFrame = CGRect(
            origin: CGPoint(x: insets.left, y: maxY),
            size: config.created.boundingRect(width: width).size
        )

        return createdLabelFrame.maxY + insets.bottom
    }
    
    //MARK: Методы для передачи отступов и размеров

    func getSpacingForStackView() -> Double {
        return photosSpacing
    }
    
    func getSizeForStackView() -> CGSize {
        return ReviewCellLayout.photoSize
    }

}

// MARK: - Typealias

fileprivate typealias Config = ReviewCellConfig
fileprivate typealias Layout = ReviewCellLayout
