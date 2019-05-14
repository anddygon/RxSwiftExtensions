//
//  Observable.swift
//  RxSwiftExtensions
//
//  Created by anddy on 2019/5/14.
//

import RxSwift
import Photos
import UIKit

public extension Observable {
    func mapVoid() -> Observable<Void> {
        return self.map({ _ in })
    }
    
    static func justVoid() -> Observable<Void> {
        return .just(())
    }
    
    func hotDelaySubscription(_ dueTime: RxTimeInterval, scheduler: SchedulerType) -> Observable<Element> {
        return self
            .flatMap({ (e) -> Observable<Element> in
                return Observable.just(e).delaySubscription(dueTime, scheduler: scheduler)
            })
    }
}

private var __rootViewController: UIViewController {
    return UIApplication.shared.keyWindow?.subviews.first?.next as! UIViewController
}

public extension Observable {
    func showAlert(title: String? = nil, message: String? = nil, yesTitle: String?, noTitle: String?) -> Observable<Element> {
        return self
            .flatMapLatest{ (e) -> Observable<Element> in
                Observable<Element>.showAlert(title: title, message: message, yesTitle: yesTitle, noTitle: noTitle)
                    .map({ e })
            }
    }
    
    static func showAlert(title: String?, message: String? = nil, yesTitle: String? = nil, noTitle: String? = nil) -> Observable<Void> {
        return Observable<Void>.create { (observer) -> Disposable in
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            if let yesTitle = yesTitle {
                let yesAction = UIAlertAction(title: yesTitle, style: .default, handler: { (_) in
                    observer.onNext(())
                    observer.onCompleted()
                })
                alertVC.addAction(yesAction)
            }
            if let noTitle = noTitle {
                let noAction = UIAlertAction(title: noTitle, style: .cancel, handler: { (_) in
                    observer.onCompleted()
                })
                alertVC.addAction(noAction)
            }
            __rootViewController.present(alertVC, animated: true, completion: nil)
            return Disposables.create()
        }
    }
    
    static func showAlertWithSingleField(title: String?, message: String? = nil, yesTitle: String? = nil, noTitle: String? = nil, configuration: ((UITextField) -> Void)? = nil) -> Observable<String> {
        return Observable<String>.create { (observer) -> Disposable in
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            var textField: UITextField?
            alertVC.addTextField(configurationHandler: { (field) in
                textField = field
                configuration?(field)
            })
            
            if let yesTitle = yesTitle {
                let yesAction = UIAlertAction(title: yesTitle, style: .default, handler: { (_) in
                    observer.onNext(textField?.text ?? "")
                    observer.onCompleted()
                })
                alertVC.addAction(yesAction)
            }
            if let noTitle = noTitle {
                let noAction = UIAlertAction(title: noTitle, style: .cancel, handler: { (_) in
                    observer.onCompleted()
                })
                alertVC.addAction(noAction)
            }
            __rootViewController.present(alertVC, animated: true, completion: nil)
            return Disposables.create()
        }
    }
    
    /// 快速展示一个actionSheet
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 消息
    ///   - optionTitles: 选项标题数组 从上至下
    ///   - cancelTitle: 取消按钮标题
    /// - Returns: 如果点击了选项会发送next为选项索引
    func showActionSheet(title: String?, message: String? = nil, optionTitles: [String], cancelTitle: String) -> Observable<Int> {
        return self
            .flatMapLatest{ (e) -> Observable<Int> in
                return Observable<Any>.showActionSheet(title: title, message: message, optionTitles: optionTitles, cancelTitle: cancelTitle)
            }
    }
    
    static func showActionSheet(title: String?, message: String? = nil, optionTitles: [String] = [], cancelTitle: String) -> Observable<Int> {
        return Observable<Int>.create{ (observer) -> Disposable in
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            let optionActions = optionTitles.enumerated().map({ (index, title) -> UIAlertAction in
                return UIAlertAction(title: title, style: .default, handler: { (_) in
                    observer.onNext(index)
                    observer.onCompleted()
                })
            })
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: { (_) in
                observer.onCompleted()
            })
            (optionActions + [cancelAction]).forEach(alertVC.addAction(_:))
            __rootViewController.present(alertVC, animated: true, completion: nil)
            return Disposables.create()
        }
    }
    
    func showImagePicker(sourceType: UIImagePickerController.SourceType, from viewController: UIViewController? = nil, autoRequestAuthorization: Bool = true, config: ((UIImagePickerController) -> Void)? = nil, completion: (() -> Void)? = nil) -> Observable<[UIImagePickerController.InfoKey: Any]> {
        let authObservable: Observable<Void>
        let accessDenied = NSError(domain: "com.rxextensions.showImagePicker", code: -1000, userInfo: [NSLocalizedDescriptionKey: "access denied"])
        let unknownError = NSError(domain: "com.rxextensions.showImagePicker", code: -2000, userInfo: [NSLocalizedDescriptionKey: "not support sourceType"])
        
        switch sourceType {
        case .camera:
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .notDetermined:
                if autoRequestAuthorization {
                    authObservable = Observable<Void>.create { (observer) -> Disposable in
                        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (isAuth) in
                            if isAuth {
                                observer.onNext(())
                                observer.onCompleted()
                            } else {
                                observer.onError(accessDenied)
                            }
                        })
                        return Disposables.create()
                    }
                } else {
                    authObservable = .error(accessDenied)
                }
            case .authorized:
                authObservable = .justVoid()
            default:
                authObservable = .error(accessDenied)
            }
        case .photoLibrary, .savedPhotosAlbum:
            switch PHPhotoLibrary.authorizationStatus() {
            case .notDetermined:
                if autoRequestAuthorization {
                    authObservable = Observable<Void>.create { (observer) -> Disposable in
                        PHPhotoLibrary.requestAuthorization({ (status) in
                            if status == .authorized {
                                observer.onNext(())
                                observer.onCompleted()
                            } else {
                                observer.onError(accessDenied)
                            }
                        })
                        return Disposables.create()
                    }
                } else {
                    authObservable = .error(accessDenied)
                }
            case .authorized:
                authObservable = .justVoid()
            default:
                authObservable = .error(accessDenied)
            }
        @unknown default:
            authObservable = .error(unknownError)
        }
        
        return authObservable
            .observeOn(MainScheduler.instance)
            .flatMapLatest { (_) -> Observable<[UIImagePickerController.InfoKey: Any]> in
                let vc = UIImagePickerController.init()
                vc.sourceType = sourceType
                config?(vc)
                let presentingVC = viewController ?? __rootViewController
                presentingVC.present(vc, animated: true, completion: completion)
                return vc.rx.info
                    .do(onNext: { (_) in
                        vc.dismiss(animated: true, completion: nil)
                    })
            }
    }
}
