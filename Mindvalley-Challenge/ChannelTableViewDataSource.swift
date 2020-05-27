//
//  ChannelTableViewDataSource.swift
//  Mindvalley-Challenge
//
//  Created by Muzahidul Islam on 24/5/20.
//  Copyright © 2020 Muzahid. All rights reserved.
//

import UIKit

final class ChannelTableViewDataSource: NSObject {
    private weak var tableView: UITableView?
    private(set) var sections: [SectionProtocol] = []
    
    // MARK: - Init
    convenience init(sections: [SectionProtocol] = []) {
        self.init()
        self.sections = sections
    }
    
    override init() { }
    
    // MARK: - Public Methods

    /// Add new section
    public func addSection(_ section: SectionProtocol) {
        sections.append(section)
        
        if let table = tableView {
            section
                .setup(for: table)
                .delegate = self
        }
        reloadTable()
    }
    
    /// DataSource connect with tableView
    public func connect(to table: UITableView?) {
        if table != tableView {
            tableView = table
            table?.dataSource = self
            table?.delegate = self
        }
        sections.forEach { [weak self] in
            $0.setup(for: table)
                .delegate = self
        }
        
        reloadTable()
    }
    
    /// Refresh all sections
    public func refreshSection() {
        sections.forEach {
            $0.refresh()
        }
    }
    
    private func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView?.reloadData()
        }
    }
    
}

// MARK: - UITableViewDataSource
extension ChannelTableViewDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        sections[indexPath.section].cellForRow(at: indexPath)
    }
}

// MARK: - UITableViewDelegate
extension ChannelTableViewDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[indexPath.section].heightForRow(at: indexPath)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sections[section].heightForHeaderInSection()
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sections[section].viewForHeaderInSection()
    }
}

// MARK: - SectionUpdatingProtocol
extension ChannelTableViewDataSource: SectionUpdatingProtocol {
    func sectionDidUpdated(_ section: SectionProtocol) {
        reloadTable()
    }
}
