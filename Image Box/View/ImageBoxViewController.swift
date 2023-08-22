//
//  ImageBoxViewController.swift
//  Image Box
//
//  Created by Krunal on 21/11/2022.
//

import UIKit
import Combine

protocol ImageBoxViewControllerProvider: AnyObject {
    func loadPhotoPicked(_ photo: PhotoMetadata?, _ originalPhoto: Bool, _ error: String)
}

class ImageBoxViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var txtXpoint: UITextField!
    @IBOutlet weak var txtYpoint: UITextField!
    @IBOutlet weak var txtWidth: UITextField!
    @IBOutlet weak var txtHeight: UITextField!

    @IBOutlet weak var imgViewPhoto: UIImageView!
    @IBOutlet weak var imgViewPhotoContainer: UIView!

    @IBOutlet weak var lblWidthHeight: UILabel!
    @IBOutlet weak var lblImage: UILabel!

    
    // MARK: - Properties
    private var cancellables: Set<AnyCancellable> = []
    private var originalImage: UIImage!
    private var imageBoxVM: ImageBoxViewModel!

    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Apply Shadow
        //imgViewPhoto.cardView(.appstore)
        imgViewPhotoContainer.cardView(.appstore)
    }


}
// MARK: - Image Box View Controller Provider
extension ImageBoxViewController: ImageBoxViewControllerProvider{
    func loadPhotoPicked(_ photo: PhotoMetadata?, _ originalPhoto: Bool, _ error: String = " ") {
        DispatchQueue.main.async {[weak self] in
            self?.updateUI(with: photo, originalPhoto, error)
        }
    }
    private func updateUI(with photo: PhotoMetadata?, _ originalPhoto: Bool, _ error: String = " "){
        guard let photo else {
            lblImage.text = error
            return
        }
        if originalPhoto {
            originalImage = photo.image
        }
        lblImage.text = " "
        imgViewPhoto.image = photo.image
    }
}

// MARK: - Image Box ViewModel
extension ImageBoxViewController{
    func loadViewModel(_ vm: ImageBoxViewModel) {
        self.imageBoxVM = vm
        
//        txtFieldEditingComplete(txtXpoint)
//        txtFieldEditingComplete(txtYpoint)
//        txtFieldEditingComplete(txtWidth)
//        txtFieldEditingComplete(txtHeight)
        
        self.imageBoxVM.$validationLblPhoto
            .receive(on: RunLoop.main)
            .sink { [weak self] errMessage in
                if errMessage == Messages.enterCoordinates {
                    self?.lblWidthHeight.text = errMessage
                }else {
                    self?.lblImage.text = errMessage
                }
            }
            .store(in: &cancellables)
        
        self.imageBoxVM.$validationImageBoxSize
            .receive(on: RunLoop.main)
            .sink { [weak self] size in
                self?.lblWidthHeight.text = "\(size?.maxWidth ?? "0")\t\t\t\(size?.maxHeight ?? "0")"
            }
            .store(in: &cancellables)
    }
}
// MARK: - IBActions
extension ImageBoxViewController{
    @IBAction func btnPhotoPickerSelected(_ sender: UIButton?) {
        self.imageBoxVM.actionPhotoPicker(self)
    }
    @IBAction func btnGenerateImageBoxSelected(_ sender: UIButton) {
        self.view.endEditing(true)
        self.imageBoxVM.actionGenerateImage(originalImage)
    }
    @IBAction func txtFieldEditingComplete(_ sender: UITextField) {
        switch sender.tag {
        case InputTag.x.rawValue:
            self.imageBoxVM.actionValidateImageSizeWithInput(InputType.x(xPoint: sender.text ?? "0"))
        case InputTag.y.rawValue:
            self.imageBoxVM.actionValidateImageSizeWithInput(InputType.y(yPoint: sender.text ?? "0"))
        case InputTag.width.rawValue:
            self.imageBoxVM.actionValidateImageSizeWithInput(InputType.width(width: sender.text ?? "0"))
        case InputTag.height.rawValue:
            self.imageBoxVM.actionValidateImageSizeWithInput(InputType.height(height: sender.text ?? "0"))
        default: break;
        }
    }
}
