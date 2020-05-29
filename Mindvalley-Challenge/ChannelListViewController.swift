//
//  ChannelListViewController.swift
//  Mindvalley-Challenge
//
//  Created by Muzahidul Islam on 23/5/20.
//  Copyright © 2020 Muzahid. All rights reserved.
//

import UIKit

final class ChannelListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private var viewModel: ChannelListViewModel?
    private var dataSource: ChannelTableViewDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewModel = ChannelListViewModel()
        self.viewModel = viewModel
        tableView.estimatedRowHeight = 450.0
        let allSections = viewModel.getSection()
        dataSource = ChannelTableViewDataSource(sections: allSections)
        dataSource?.connect(to: tableView)
    }
}
