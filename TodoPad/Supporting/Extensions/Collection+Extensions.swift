//
//  Collection+Extensions.swift
//  TodoPad
//
//  Created by John Lee on 2022-08-08.
//

import Foundation

extension Collection {

    subscript(optional i: Index) -> Iterator.Element? {
        return self.indices.contains(i) ? self[i] : nil
    }

}
