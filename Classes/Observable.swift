//
//  Observable.swift
//  RxSwiftExtensions
//
//  Created by anddy on 2019/5/14.
//

import RxSwift

public extension Observable {
    func mapVoid() -> Observable<Void> {
        return self.map({ _ in })
    }
}
