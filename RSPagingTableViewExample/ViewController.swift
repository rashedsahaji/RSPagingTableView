//
//  ViewController.swift
//  RSPagingTableViewExample
//
//  Created by Rashed Sahajee on 21/11/22.
//

import UIKit
import RSPagingTableView

class ViewController: UIViewController, RSPaginatingTableViwDelegate {

    @IBOutlet weak var cutsomTable: RSPaginatingTableView!
    var dataSoure: UITableViewDiffableDataSource<Section, Photo>?
    var result: Photos = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cutsomTable.pagingDelegate = self
        configDataSource()
    }

    func callAPI(page: Int, limit: Int) {
        PhotosRESTManager.shared.getPhotos(page: page, limit: limit) { result in
            switch result {
            case .success(let success):
                self.updateDataSource(with: success)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    enum Section {
        case main
    }
    func configDataSource() {
        cutsomTable.register(PhotosCells.nib(), forCellReuseIdentifier: PhotosCells.identifier)
        dataSoure = UITableViewDiffableDataSource<Section, Photo>(tableView: cutsomTable, cellProvider: { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotosCells.identifier, for: indexPath) as? PhotosCells else {return UITableViewCell()}
            cell.id.text = (itemIdentifier.id ?? "") + " : " + (itemIdentifier.author ?? "")
            cell.previewImage.imageFromServerURL(urlString: itemIdentifier.downloadURL ?? "", PlaceHolderImage: UIImage.checkmark)
            return cell
        })
        cutsomTable.dataSource = dataSoure
    }
    
    func updateDataSource(with: Photos) {
        self.result.append(contentsOf: with)
        var snapshot = NSDiffableDataSourceSnapshot<Section, Photo>()
        snapshot.appendSections([.main])
        snapshot.appendItems(result, toSection: .main)
        dataSoure?.apply(snapshot, animatingDifferences: true)
    }
    
    func paginate(to page: Int, for tableView: UITableView) {
        self.callAPI(page: page, limit: 30)
    }
}

extension UIImageView {
 public func imageFromServerURL(urlString: String, PlaceHolderImage:UIImage) {
        if self.image == nil{
              self.image = PlaceHolderImage
        }
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in

            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })

        }).resume()
    }}
