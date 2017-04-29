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

        imageFetcher.fetchImages(atPage: 0) { [weak self] (images, error) in
            if let error = error {
                self?.showAlert(for: error)
            }
            self?.images = images
        }
    }
}

// MARK: Private Methods

private extension ImageCollectionViewController {

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

// MARK: - ImageCollectionViewControllerAssembly

class ImageCollectionViewControllerAssembly: Assembly {

    func assemble(container: Container) {
        container.storyboardInitCompleted(ImageCollectionViewController.self) { (r, c) in
            c.imageFetcher = r.resolve(IFIImageFetcher.self)!
            c.dataLoader = r.resolve(IFIAsyncDataLoader.self)!
        }
    }
}
