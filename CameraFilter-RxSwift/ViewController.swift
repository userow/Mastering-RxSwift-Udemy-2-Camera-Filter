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
	@IBOutlet weak var imageView: UIImageView!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

		navigationItem.largeTitleDisplayMode = .always
		navigationController?.navigationBar.prefersLargeTitles = true
	}


}

