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
}

open class RSPaginatingTableView:UITableView{
    
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
