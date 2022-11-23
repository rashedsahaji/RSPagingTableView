//
//  RSPagingTable.swift
//  RSPagingTableView
//
//  Created by Rashed Sahajee on 21/11/22.
//

import UIKit
import Foundation

public protocol RSPaginatingTableViwDelegate: AnyObject {
    func paginate(to page: Int, for tableView: UITableView)
    func didCallRefreshTableView(for tableView: UITableView)
}

open class RSPaginatingTableView:UITableView{
    
    private var loadingView: UIView!
    private var indicator: UIActivityIndicatorView!
    internal var page: Int = 0
    internal var previousItemCount: Int = 0
    
    weak public var pagingDelegate: RSPaginatingTableViwDelegate? {
        didSet {
            pagingDelegate?.paginate(to: page, for: self)
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.separatorStyle = .none
    }
    private func refreshControlSetUp() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(callRefresh), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    @objc private func callRefresh() {
        self.refreshControl?.endRefreshing()
        self.pagingDelegate?.didCallRefreshTableView(for: self)
    }
    open var isLoading: Bool = false {
        willSet {
            if newValue {
                self.refreshControl = nil
            } else {
                self.refreshControlSetUp()
            }
        }
        didSet {
            isLoading ? showLoading() : hideLoading()
        }
    }
    
    private func showLoading() {
        if loadingView == nil {
            createLoadingView()
        }
        tableFooterView = loadingView
    }

    private func hideLoading() {
        reloadData()
        tableFooterView = nil
    }
    
    private func createLoadingView() {
        loadingView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 50))
        indicator = UIActivityIndicatorView()
        indicator.color = UIColor.lightGray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        loadingView.addSubview(indicator)
        centerIndicator()
        tableFooterView = loadingView
    }
    
    private func centerIndicator() {
        let xCenterConstraint = NSLayoutConstraint(
            item: loadingView as Any, attribute: .centerX, relatedBy: .equal,
            toItem: indicator, attribute: .centerX, multiplier: 1, constant: 0
        )
        loadingView.addConstraint(xCenterConstraint)

        let yCenterConstraint = NSLayoutConstraint(
            item: loadingView as Any, attribute: .centerY, relatedBy: .equal,
            toItem: indicator, attribute: .centerY, multiplier: 1, constant: 0
        )
        loadingView.addConstraint(yCenterConstraint)
    }
    
    private func paginate(_ tableView: RSPaginatingTableView, forIndexAt indexPath: IndexPath) {
        let itemCount = tableView.dataSource?.tableView(tableView, numberOfRowsInSection: indexPath.section) ?? 0
        guard indexPath.row == itemCount - 1 else { return }
        guard previousItemCount != itemCount else { return }
        page += 1
        previousItemCount = itemCount
        pagingDelegate?.paginate(to: page, for: self)
    }
    
    public override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
        self.paginate(self, forIndexAt: indexPath)
        return super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    }
}
