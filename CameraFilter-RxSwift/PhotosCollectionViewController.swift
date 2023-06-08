//
//  PhotosCollectionViewController.swift
//  CameraFilter-RxSwift
//
//  Created by Pavlo Vasylenko on 08.06.2023.
//

import Foundation
import UIKit
import Photos

class PhotosCollectionViewController: UICollectionViewController {

	private var images = [PHAsset]()

	override func viewDidLoad() {
		super.viewDidLoad()

		populatePhotos()
	}

	//MARK: - CollectionView methods

	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return images.count
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		return UICollectionViewCell()
	}

	private func populatePhotos() {
		PHPhotoLibrary.requestAuthorization {  [weak self] status in
			dump(status)

			if status == .authorized {
				// access photos

				let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
				assets.enumerateObjects { (object, count, stop) in
					self?.images.append(object)
				}

				self?.images.reverse()

//				print(self?.images)
//				self?.collectionView.reloadData()
			} else {

			}
		}
	}
}
