//
//  Extension+UIImage.swift
//  NetflixClone
//
//  Created by Berkay Tuncel on 7.09.2023.
//

import UIKit

extension UIImage {
    func resizeTo(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { _ in self.draw(in: CGRect.init(origin: CGPoint.zero, size: size)) }
        
        return image.withRenderingMode(self.renderingMode)
    }
}
