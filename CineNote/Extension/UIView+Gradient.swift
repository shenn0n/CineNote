//
//  UIView+Gradient.swift
//  CineNote
//
//  Created by Александр Манжосов on 30.06.2025.
//

import Foundation
import UIKit

extension UIView {
    /// Добавляет вертикальный градиентный слой от topColor к bottomColor
    func addVerticalGradientLayer(topColor: UIColor, bottomColor: UIColor) {
        // Проверяем, есть ли уже градиентный слой — если нужно, избегаем дублирования
        if let gradient = layer.sublayers?.compactMap({ $0 as? CAGradientLayer }).first {
            gradient.colors = [topColor.cgColor, bottomColor.cgColor]
            gradient.frame = bounds
        } else {
            let gradient = CAGradientLayer()
            gradient.frame = bounds
            gradient.colors = [topColor.cgColor, bottomColor.cgColor]
            gradient.locations = [0.0, 1.0]
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 0, y: 1)
            layer.insertSublayer(gradient, at: 0)
        }
    }
    
    /// Обновляет размер градиентного слоя при изменении bounds (вызывать из layoutSubviews)
    func updateGradientFrame() {
        if let gradient = layer.sublayers?.compactMap({ $0 as? CAGradientLayer }).first {
            gradient.frame = bounds
        }
    }
}
