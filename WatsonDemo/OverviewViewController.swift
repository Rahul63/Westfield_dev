
//
//  OverviewViewController.swift
//  WatsonDemo
//
//  Created by RAHUL on 11/13/16.
//  Copyright © 2016 RAHUL. All rights reserved.
//

import UIKit

class OverviewViewController: UIViewController {

    // MARK: - Constants
    private struct Constants {
        static let chatSelectedIndex = 1
    }

    // MARK: - Outlets
    @IBOutlet weak var overviewImageView: UIImageView!

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSimulator()
    }

    // MARK: - Actions
    @IBAction func goButtonTapped() {
        tabBarController?.selectedIndex = Constants.chatSelectedIndex
    }

    // MARK: - Private
    // This will only execute on the simulator and NOT on a real device
    private func setupSimulator() {
        #if DEBUG
            let when = DispatchTime.now() + 0.01
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.tabBarController?.selectedIndex = Constants.chatSelectedIndex
            }
        #endif
    }

}
