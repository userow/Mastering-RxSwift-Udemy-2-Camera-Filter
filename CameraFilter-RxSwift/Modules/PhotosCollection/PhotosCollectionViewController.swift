//
//  PhotosCollectionViewController.swift
//  CameraFilter-RxSwift
//
//  Created by Pavlo Vasylenko on 08.06.2023.
//

import Foundation
import UIKit
import Photos
import RxSwift

class PhotosCollectionViewController: UICollectionViewController {

	private var images = [PHAsset]()

	private let selectedPhotoSubject = PublishSubject<UIImage>()

	var selectedObject: Observable<UIImage> {
		return selectedPhotoSubject.asObservable()
	}

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
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier, for: indexPath) as? PhotoCollectionViewCell else {
			fatalError("PhotoCollectionViewCell not found")
		}

		let asset = self.images[indexPath.row]
		let manager = PHImageManager.default()

		manager.requestImage(for: asset,
							 targetSize: CGSize(width: 100, height: 100),
							 contentMode: PHImageContentMode.aspectFit,
							 options: nil) { image, info in
			DispatchQueue.main.async {
				cell.photoImageView.image = image
			}
		}

		return cell
	}

	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let selectedAsset = self.images[indexPath.row]

		PHImageManager.default().requestImage(for: selectedAsset,
											  targetSize: CGSize(width: 300, height: 300),
											  contentMode: PHImageContentMode.aspectFit,
											  options: nil) { [weak self] image, info in
			guard let info,
				  let isDegradedImage = info["PHImageResultIsDegradedKey"] as? Bool,
				  !isDegradedImage,
				  let image
			else { return }

//			DispatchQueue.main.async {

			self?.selectedPhotoSubject.onNext(image)
			self?.dismiss(animated: true)

		}
	}


	//MARK: - private methods

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
				DispatchQueue.main.async {
					self?.collectionView.reloadData()
				}
			} else {

			}
		}
	}
}
