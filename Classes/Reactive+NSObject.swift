//
//  Reactive+NSObject.swift
//  Pods-RxSwiftExtensions_Example
//
//  Created by anddy on 2019/5/14.
//

import RxSwift
import RxCocoa

public extension Reactive where Base: NSObject {
    /**
     If the object is reporting a different class then what it's real class, that means that there is probably
     already some interception mechanism in place or something weird is happening.
     
     Most common case when this would happen is when using KVO (`observe`) and `sentMessage`.
     This error is easily resolved by just using `sentMessage` observing before `observe`.
     
     The reason why other way around could create issues is because KVO will unregister it's interceptor
     class and restore original class. Unfortunately that will happen no matter was there another interceptor
     subclass registered in hierarchy or not.
     
     Failure scenario:
     * KVO sets class to be `__KVO__OriginalClass` (subclass of `OriginalClass`)
     * `sentMessage` sets object class to be `_RX_namespace___KVO__OriginalClass` (subclass of `__KVO__OriginalClass`)
     * then unobserving with KVO will restore class to be `OriginalClass` -> failure point
     The reason why changing order of observing works is because any interception method should return
     object's original real class (if that doesn't happen then it's really easy to argue that's a bug
     in that other library).
     
     This library won't remove registered interceptor even if there aren't any observers left because
     it's highly unlikely it would have any benefit in real world use cases, and it's even more
     dangerous.
     */
    func observe<Value>(keyPath: KeyPath<Base, Value>, options: KeyValueObservingOptions = [.initial, .new], retainSelf: Bool = true) -> Observable<Value?> {
        guard let keyPathString = keyPath._kvcKeyPathString else {
            let error = RxCocoaError.invalidObjectOnKeyPath(object: base, sourceObject: keyPath, propertyName: base.description)
            return Observable<Value?>.error(error)
        }
        return base.rx.observe(Value.self, keyPathString, options: options, retainSelf: retainSelf)
    }
    
    func observeWeakly<Value>(keyPath: KeyPath<Base, Value>, options: KeyValueObservingOptions = [.initial, .new], retainSelf: Bool = true) -> Observable<Value?> {
        guard let keyPathString = keyPath._kvcKeyPathString else {
            let error = RxCocoaError.invalidObjectOnKeyPath(object: base, sourceObject: keyPath, propertyName: base.description)
            return Observable<Value?>.error(error)
        }
        return base.rx.observeWeakly(Value.self, keyPathString, options: options)
    }
}
