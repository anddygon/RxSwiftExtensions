//
//  Reactive+ImagePicker.swift
//  TranslationDemo
//
//  Created by xiaoP on 2017/11/25.
//  Copyright © 2017年 Chicv. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: UIImagePickerController {
    private var _delegate: DelegateProxy<UIImagePickerController, UIImagePickerControllerDelegate & UINavigationControllerDelegate> {
        return RxImagePickerDelegateProxy.proxy(for: base)
    }
    
    private var _selected: Observable<[UIImagePickerController.InfoKey : Any]> {
        let selector = #selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:))
        return _delegate.methodInvoked(selector)
            .map({ $0[1] as! [UIImagePickerController.InfoKey : Any] })
    }
    
    var cancel: Observable<Void> {
        return _delegate.methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:)))
            .map({ _ in })
    }
    
    var selectedEditedImage: Observable<UIImage> {
        return _selected
            .map({ $0[.editedImage] as! UIImage })
    }
    
    var selectedOriginalImage: Observable<UIImage> {
        return _selected
            .map({ $0[.originalImage] as! UIImage })
    }
}
