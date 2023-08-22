//
//  ImageBoxViewModel.swift
//  Image Box
//
//  Created by Krunal on 22/11/2022.
//

import Foundation
import UIKit

final class ImageBoxViewModel {
    private var photoPickerService: PhotoPickerService?
    var photoMetadata: PhotoMetadata?
//    {
//        didSet {
//            guard let photoMetadata = self.photoMetadata else { return }
//            self.photoConfiguration = PhotoConfiguration(
//                point: CGPoint(x: 0, y: 0),
//                size: CGSize(
//                    width: photoMetadata.size.width,
//                    height: photoMetadata.size.height)
//            )
//            actionValidateImageSizeWithInput(.width(width: "0"))
//            actionValidateImageSizeWithInput(.height(height: "0"))
//        }
//    }
    var photoConfiguration: PhotoConfiguration
    @Published var validationImageBoxSize: (maxWidth: String, maxHeight: String)?
    @Published var validationLblPhoto: String! = Messages.selectPhotoHint

    private weak var view: ImageBoxViewControllerProvider!

    init(_ view: ImageBoxViewControllerProvider!) {
        self.view = view
        self.photoConfiguration = PhotoConfiguration(point: CGPoint(x: 0, y: 0),
                           size: CGSize(width: 0, height: 0))
        
        validationImageBoxSize = (
            maxWidth(for: 0),
            maxHeight(for: 0)
            )
    }
}

extension ImageBoxViewModel {

    func actionValidateImageSizeWithInput(_ input: InputType) {
        switch input {
        case .x(let xPoint):
            photoConfiguration.point = CGPoint(x: Double(xPoint) ?? 0,
                                               y: photoConfiguration.point.y)
        case .y(let yPoint):
            photoConfiguration.point = CGPoint(x: photoConfiguration.point.x,
                                               y: Double(yPoint) ?? 0)
        case .width(let width):
            photoConfiguration.size = CGSize(width: Double(width) ?? 0,
                                             height: photoConfiguration.size.height)
        case .height(let height):
            photoConfiguration.size = CGSize(width: photoConfiguration.size.width ,
                                             height: Double(height) ?? 0)
        }
        guard let photoMetadata else { return }
        
        validationImageBoxSize = (
            maxWidth(for: photoMetadata.size.width - photoConfiguration.point.x),
            maxHeight(for: photoMetadata.size.height - photoConfiguration.point.y)
        )
    }
    func actionPhotoPicker(_ topVC: UIViewController) {
        photoPickerService = PhotoPickerService(self)
        photoPickerService?.setupPhotoPickerService(topVC)
    }
    func actionGenerateImage(_ originalImage: UIImage?) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.performPhotoMetadataOperations(originalImage)
        }
    }
    private func performPhotoMetadataOperations(_ originalImage: UIImage?){
        guard let _ = photoMetadata,
              let originalImage else {
            validationLblPhoto = Messages.selectPhotoError
            return
        }
        
        guard (photoConfiguration.size.width != 0 ||
               photoConfiguration.size.height != 0 ) else {
            validationLblPhoto = Messages.enterCoordinates
            return
        }
        
        validationLblPhoto = " "
        
        guard let newImage = originalImage.drawRectangleOnImageWith(photoConfiguration) else { return }
        guaranteeMainThread { [weak self] in
            guard let self else { return }
            self.photoMetadata = PhotoMetadata(image: newImage, size: newImage.size)
            self.view.loadPhotoPicked(self.photoMetadata, false, "")
        }
    }
}

extension ImageBoxViewModel: PhotoPickerServiceDelegate {
    func didPhotoPick(image: UIImage?) {
        self.photoMetadata = nil
        self.photoPickerService = nil
        guard let image else {
            self.view.loadPhotoPicked(nil, false, Messages.photoLoadingError)
            return
        }
        photoMetadata = PhotoMetadata(image: image, size: image.size)
        self.view.loadPhotoPicked(photoMetadata, true, "")
    }
}

