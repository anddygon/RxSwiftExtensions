//
//  RxImagePickerDelegateProxy.swift
//  TranslationDemo
//
//  Created by xiaoP on 2017/11/25.
//  Copyright © 2017年 Chicv. All rights reserved.
//

import RxSwift
import RxCocoa

class RxImagePickerDelegateProxy: DelegateProxy<UIImagePickerController, UIImagePickerControllerDelegate & UINavigationControllerDelegate>, DelegateProxyType, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    weak private(set) var imagePicker: UIImagePickerController?
    
    init(imagePicker: UIImagePickerController) {
        self.imagePicker = imagePicker
        super.init(parentObject: imagePicker, delegateProxy: RxImagePickerDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register(make: { RxImagePickerDelegateProxy(imagePicker: $0) })
    }
    
    static func currentDelegate(for object: UIImagePickerController) -> (UIImagePickerControllerDelegate & UINavigationControllerDelegate)? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?, to object: UIImagePickerController) {
        object.delegate = delegate
    }
}
