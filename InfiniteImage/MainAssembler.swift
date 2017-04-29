//
//  MainAssembler.swift
//  InfiniteImage
//
//  Created by Mark DiFranco on 2017-04-29.
//  Copyright © 2017 MDFProjects. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

// MARK: - MainAssembler

class MainAssembler {
    var resolver: Resolver {
        return assembler.resolver
    }

    private let assembler = Assembler(container: SwinjectStoryboard.defaultContainer)

    init() {
        Container.loggingFunction = nil

        assembler.apply(assembly: IFIURLSessionAssembly())
        assembler.apply(assembly: IFIURLRequestProviderAssembly())
        assembler.apply(assembly: IFIImageFetcherAssembly())
        assembler.apply(assembly: ImageCollectionViewControllerAssembly())
    }
}
