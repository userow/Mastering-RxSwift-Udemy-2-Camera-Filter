//
//  FilterService.swift
//  CameraFilter-RxSwift
//
//  Created by Pavlo Vasylenko on 11.06.2023.
//

import Foundation
import UIKit
import CoreImage
import RxSwift

class FilterService {
	private var context: CIContext

	init() {
		self.context = CIContext()
	}
	func applyFilter(to inputImage: UIImage) -> Observable<UIImage> {
		return Observable<UIImage>.create { observer in
			self.applyFilter(to: inputImage) { filteredImage in
				observer.onNext(filteredImage)
			}

			return Disposables.create()
		}
	}

	private   func applyFilter(to inputImage: UIImage, completion: @escaping ((UIImage) -> ())) {
		guard let filter = CIFilter(name: "CICMYKHalftone") else { return }
		filter.setValue(5.0, forKey: kCIInputWidthKey)

		guard let sourceImage = CIImage(image: inputImage) else { return }

		filter.setValue(sourceImage, forKey: kCIInputImageKey)

		guard let cgRect = filter.outputImage?.extent,
			  let ciImage = filter.outputImage,
			  let cgImage = self.context.createCGImage(ciImage,
													   from: cgRect) else { return }

		let processedImage = UIImage(cgImage: cgImage,
									 scale: inputImage.scale,
									 orientation: inputImage.imageOrientation)

		completion(processedImage)
	}
}
