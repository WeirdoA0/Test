//
//  HorizontalImagesView.swift
//  Test
//
//  Created by Руслан Усманов on 02.03.2025.
//

import UIKit

// Пришлось реализовать что-то похожее на StackView, так как StackView в TableView делал что-то странное и я не нашел способа исправить это
/// Аналог StackView
final class UIHorizontalImagesView: UIView {
    
    var spacing: Int = 0
    var numberOfImages: Int = 0
    var imageSize: CGSize = .zero
    var cornerRadius: CGFloat = 0
    
    var imageViews: [UIImageView] = []
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Подготавливает View для отображения
    func layout() {
        var x = 0
        for _ in 0..<numberOfImages {
            imageViews.append(UIImageView(frame: CGRect(
                origin: CGPoint(x: x, y: 0),
                size: imageSize)))
            x += Int(imageSize.width) + spacing
        }
        imageViews.forEach({
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = cornerRadius
            addSubview($0)
        })
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = cornerRadius
    }
    
    /// Удаляет все ранее UIImageView если такие были
    func reset() {
        subviews.forEach({ $0.removeFromSuperview() })
        imageViews.removeAll()
    }

    
}

