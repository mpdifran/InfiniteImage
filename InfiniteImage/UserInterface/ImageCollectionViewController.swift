//
//  ImageCollectionViewController.swift
//  InfiniteImage
//
//  Created by Mark DiFranco on 2017-04-29.
//  Copyright © 2017 MDFProjects. All rights reserved.
//

import UIKit
import Swinject
import SwinjectStoryboard

// MARK: - ReuseIdentifier

private struct ReuseIdentifier {
    static let imageCell = "ImageCellIdentifier"

    private init() { }
}

// MARK: - ImageCollectionViewController

class ImageCollectionViewController: UICollectionViewController {
    var imageFetcher: IFIImageFetcher!
    var dataLoader: IFIAsyncDataLoader!

    var numberOfLoadedPages: UInt = 0

    var images = [IFIImage]() {
        didSet {
            collectionView?.reloadData()
        }
    }
}

// MARK: View Lifecycle

extension ImageCollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        loadAnotherPage()
    }
}

// MARK: Private Methods

private extension ImageCollectionViewController {

    func loadAnotherPage() {
        imageFetcher.fetchImages(atPage: numberOfLoadedPages) { [weak self] (images, error) in
            if let error = error {
                self?.showAlert(for: error)
            }
            self?.images.append(contentsOf: images)
            self?.numberOfLoadedPages += 1
        }
    }

    func showAlert(for error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: UICollectionViewDataSource Methods

extension ImageCollectionViewController {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.imageCell, for: indexPath)

        if let imageCell = cell as? ImageCollectionViewCell {
            let image = images[indexPath.row]
            let identifier = imageCell.hash

            dataLoader.loadData(from: image.thumbnailURL, withIdentifier: identifier) { (data) in
                let image = UIImage(data: data)

                DispatchQueue.main.async {
                    imageCell.imageView.image = image
                }
            }
        }

        return cell
    }
}

// MARK: UIScrollViewDelegate Methods

extension ImageCollectionViewController {

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionView = collectionView else { return }

        let height = collectionView.bounds.height
        let contentHeight = collectionView.contentSize.height
        let offset = collectionView.contentOffset.y

        if offset + height >= contentHeight {
            loadAnotherPage()
        }
    }

    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint,
                                            targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let collectionView = collectionView else { return }

        let height = collectionView.bounds.height
        let contentHeight = collectionView.contentSize.height
        let offset = targetContentOffset.pointee.y

        if offset + height >= contentHeight {
            loadAnotherPage()
        }
    }
}

// MARK: - ImageCollectionViewControllerAssembly

class ImageCollectionViewControllerAssembly: Assembly {

    func assemble(container: Container) {
        container.storyboardInitCompleted(ImageCollectionViewController.self) { (r, c) in
            c.imageFetcher = r.resolve(IFIImageFetcher.self)!
            c.dataLoader = r.resolve(IFIAsyncDataLoader.self)!
        }
    }
}
