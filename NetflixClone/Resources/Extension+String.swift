//
//  Extension+String.swift
//  NetflixClone
//
//  Created by Berkay Tuncel on 8.09.2023.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased(with: .autoupdatingCurrent).dropFirst()
    }
}
