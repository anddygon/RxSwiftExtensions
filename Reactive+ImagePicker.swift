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

extension Reactive where Base: UIImagePickerController {
    private var _delegate: DelegateProxy<UIImagePickerController, UIImagePickerControllerDelegate & UINavigationControllerDelegate> {
        return RxImagePickerDelegateProxy.proxy(for: base)
    }
    
    private var _selected: Observable<[String: Any]> {
        let selector = #selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:))
        return _delegate.methodInvoked(selector)
            .map({ (params) -> [String: Any] in
                return params[1] as! [String: Any]
            })
    }
    
    var cancel: Observable<Void> {
        return _delegate.methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:)))
            .map({ _ in })
    }
    
    var selectedEditedImage: Observable<UIImage> {
        return _selected
            .map({ $0[UIImagePickerControllerEditedImage] as! UIImage })
    }
    
    var selectedOriginalImage: Observable<UIImage> {
        return _selected
            .map({ $0[UIImagePickerControllerOriginalImage] as! UIImage })
    }
}
