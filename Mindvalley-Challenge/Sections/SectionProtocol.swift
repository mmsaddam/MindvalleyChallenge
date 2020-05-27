//
//  SectionProtocol.swift
//  Mindvalley-Challenge
//
//  Created by Muzahidul Islam on 23/5/20.
//  Copyright © 2020 Muzahid. All rights reserved.
//

import Foundation
import UIKit

protocol SectionUpdatingProtocol: class {
    func sectionDidUpdated(_ section: SectionProtocol)
}

protocol SectionProtocol: class {
    var id: String { get set }
    var delegate: SectionUpdatingProtocol? { get set }
    func setup(for tableView: UITableView?) -> Self
    func numberOfRows() -> Int
    func cellForRow(at indexPath: IndexPath) -> UITableViewCell
    func heightForRow(at indexPath: IndexPath) -> CGFloat
    func heightForHeaderInSection() -> CGFloat
    func viewForHeaderInSection() -> UIView?
    
    func refresh()
    
}

extension SectionProtocol {
    func heightForRow(at indexPath: IndexPath) -> CGFloat { return UITableView.automaticDimension }
    func heightForHeaderInSection() -> CGFloat { return 0.0 }
    func viewForHeaderInSection() -> UIView? { return UIView() }
    func refresh() {}
}
