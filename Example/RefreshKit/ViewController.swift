//
//  ViewController.swift
//  RefreshKit
//
//  Created by 81556205@qq.com on 09/27/2017.
//  Copyright (c) 2017 81556205@qq.com. All rights reserved.
//

import UIKit
import RefreshKit

class ViewController: UIViewController {

    let tableView = UITableView()
    
    var db: Int = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.automaticallyAdjustsScrollViewInsets = false
        // 普通
        tableView.refresh
            .header
            .configure { h in
                h.tintColorForDefaultRefreshView = .black
            }
            .addAction { [unowned self] in
                self.db = 20
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2, execute: {
                    self.tableView.reloadData()
                    self.tableView.refresh.header.endRefreshing()
                })
        }
        // 自定义
//        tableView.refresh
//            .setHeadher(CustomView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60)))
//            .addAction {
//                print("refreshing")
//        }
//            
        
        
        tableView.refresh
            .footer
            .addAction { [unowned self] in
                self.db += 10
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2, execute: {
                    self.tableView.reloadData()
                    self.tableView.refresh.footer.endRefreshing()
                })
                
        }

    }

    @IBAction func beginRefreshing(_ sender: Any) {
        tableView.refresh.header.beginRefreshing()
    }
   
    @IBAction func endRefreshing(_ sender: Any) {
        // 普通结束
//        tableView.refresh.header.endRefreshing()
        // 带信息结束
//        tableView.refresh
//            .header
//            .endRefreshingWithMessage(msg: "刷新失败", delay: 2)
        tableView.refresh.footer.endRefreshing()
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return db
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // I'm lazy :)
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = "row " + String(indexPath.row + 1)
        return cell
    }
}

