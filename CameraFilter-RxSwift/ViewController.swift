//
//  ViewController.swift
//  CameraFilter-RxSwift
//
//  Created by Pavlo Vasylenko on 08.06.2023.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

	@IBOutlet weak var applyFilterButton: UIButton!
	@IBOutlet weak var photoImageView: UIImageView!

	let disposeBag = DisposeBag()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

		navigationItem.largeTitleDisplayMode = .always
		navigationController?.navigationBar.prefersLargeTitles = true
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let navC = segue.destination as? UINavigationController,
		let photosCVC = navC.viewControllers.first as? PhotosCollectionViewController else {
			fatalError("Segue destination is not found")
		}

		photosCVC.selectedObject.subscribe(onNext: { [weak self] photo in
			DispatchQueue.main.async {
				self?.updateUI(image: photo)
			}
		}).disposed(by: disposeBag)
	}

	private func updateUI(image: UIImage) {
		photoImageView.image = image
		applyFilterButton.isHidden = false
	}

	@IBAction func applyFilterButtonPressed() {
		guard let sourceImage = photoImageView.image else { return }

		FilterService().applyFilter(to: sourceImage).subscribe(onNext: { [weak self] filteredImage in
			DispatchQueue.main.async {
				self?.photoImageView.image = filteredImage
			}
		}).disposed(by: disposeBag)
	}
}

