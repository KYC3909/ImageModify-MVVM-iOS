//
//  PhotoPickerService.swift
//  Image Box
//
//  Created by Krunal on 22/11/2022.
//

import UIKit
import PhotosUI

// MARK: - Photo Picker Service Delegate
protocol PhotoPickerServiceDelegate: AnyObject {
    func didPhotoPick(image: UIImage?)
}

// MARK: - Photo Picker Service
final class PhotoPickerService {
    
    weak var delegate:  PhotoPickerServiceDelegate?
    weak var topVC:     UIViewController?
    
    init(_ delegate: PhotoPickerServiceDelegate? = nil) {
        self.delegate = delegate
    }
    
    // MARK: - Setup Photo Picker Service
    func setupPhotoPickerService(_ topVC: UIViewController) {
        self.topVC = topVC
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        configuration.preferredAssetRepresentationMode = .current
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        topVC.present(picker, animated: true)
    }
    deinit {
        print("PhotoPickerService")
    }
}

extension PhotoPickerService: PHPickerViewControllerDelegate {
    /// - Tag: ParsePickerResults
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        self.topVC?.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            
            // Load Item Provider
            let imageItems = results
                .map { $0.itemProvider }
                .filter { $0.canLoadObject(ofClass: UIImage.self) }

            // Load UIImage
            if !imageItems.isEmpty {
                imageItems.first?.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
                    if let image = image as? UIImage {
                        self?.handleImage(image)
                    }
                }
            } else {
                self.handleImage(nil)
            }
        }
    }
    
    // Handle Picked Image
    func handleImage(_ image: UIImage?) {
        guaranteeMainThread { [weak self] in
            guard let self else { return }
            self.delegate?.didPhotoPick(image: image)
        }
    }
}

