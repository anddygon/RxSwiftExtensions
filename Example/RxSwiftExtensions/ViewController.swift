//
//  ViewController.swift
//  RxSwiftExtensions
//
//  Created by xiaop on 05/14/2019.
//  Copyright (c) 2019 xiaop. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Photos
import RxSwiftExtensions

class ViewController: UIViewController {
    @IBOutlet weak var alertButton: UIButton!
    @IBOutlet weak var actionSheetButton: UIButton!
    @IBOutlet weak var imagePickerButton: UIButton!
    private var hasInvoked = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Disposables.create([
                showAlert(),
                showActionSheet(),
                observeProperty(),
                observeWeaklyProperty()
            ])
            .disposed(by: bag)
    }
}

extension ViewController {
    func observeProperty() -> Disposable {
        return rx.observe(keyPath: \.view.bounds)
            .debug()
            .subscribe()
    }
    
    func observeWeaklyProperty() -> Disposable {
        return rx.observeWeakly(keyPath: \.view.bounds)
            .debug()
            .subscribe()
    }
    
    func showAlert() -> Disposable {
        return alertButton.rx.tap
            .asObservable()
            .showAlert(title: "标题", message: "消息", yesTitle: "确认", noTitle: "取消")
            .debug()
            .subscribe()
    }
    
    func showActionSheet() -> Disposable {
        let options = (1...6).map(String.init).map({ "选项" + $0 })
        return actionSheetButton.rx.tap
            .asObservable()
            .showActionSheet(title: "标题", message: "消息", optionTitles: options, cancelTitle: "取消")
            .debug()
            .subscribe()
    }
    
    func showImagePicker() -> Disposable {
        return imagePickerButton.rx.tap
            .asObservable()
            .showImagePicker(sourceType: .photoLibrary, config: configImagePicker, completion: imagePickerDidShowCompletion)
            .map({ $0[.editedImage] as! UIImage })
            .map(UIColor.init(patternImage: ))
            .bind(to: view.rx.backgroundColor)
    }
    
    private func configImagePicker(_ vc: UIImagePickerController) -> Void {
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
    }
    
    private func imagePickerDidShowCompletion() -> Void {
        print("imagepicker did show")
    }
}
