# InfiniteImage

## To Run
1. Open the `InfiniteImage.xcodeproj` file.
1. Run the `Carthage Bootstrap` scheme. You may need to run this several times because of a bug in `Swinject`.
1. Run the `InfiniteImage` scheme.

## Warnings

There are two warnings in the project, caused by the `SwinjectStoryboard` dependency. I have a PR up to fix these warnings, but it is not merged yet. You can find the PR here: https://github.com/Swinject/SwinjectStoryboard/pull/46

## Areas of Focus

I decided to focus on making the app easily testable. To do this, I used dependency injection to abstract away external dependencies (`URLSession`, for example), which made testing easy and fast. I used `Swinject` as a dependency injection container to help resolve my object graph.

I left out a few tests from the `IFIImageFetcherTests` file in the interest of time, but you should be able to get the idea with the tests I did write.

Since I spent most of my time on the core logic, I did not get to spend as much time on the UI. There are a few optimizations I could have made if I had more time:

- Add tests for the `IFIAsyncDataLoader`. Because it does not use `UIKit`, this is easy to do.
- Use the prefetching API of `UICollectionView` to prefetch images before the cell is displayed. This would make scrolling more seamless.
- Update the layout to dynamically size the cells based on the screen size.
- Add the photo detail view.
- Add long press to copy the image.

## Style

I used protocols to define the public interface for my classes. These protocols are then used by other classes, so no classes are talking directly to each other. This is necessary in order to make testing possible. There are some trade-offs of doing this; the biggest one being that protocols cannot conform to other protocols, so you lose out on things like `Equatable`, which is a pain when using certain `Array` methods.

I organized my classes to only contain properties and initializers; putting all other code in extensions. A separate extension is used for every protocol the class conforms to. I find this a very nice way of keeping the file organized and easy to read.

Another pattern I like to use is acheiving namespacing using structs with private initializers. You can see examples of this in `IFIURLRequestProvider.swift`. Example:

    private struct Key {

        struct Header {
            static let subscription = "Ocp-Apim-Subscription-Key"

            private init() { }
        }

        private init() { }
    }

Because I used dependdency injection, you'll notice the view controller is only concerned with view logic. All logic that can be abstracted away from the UI has been. This makes view controllers much easier to work with.

## Dependencies

I generally only add dependencies when there's an explicit reason to. By minimizing the number of dependencies I use, the project can more quickly adapt to new versions of the iOS SDK / Swift. It also allows you to tailor your code to your exact needs.

One thing to note, in the `Cartfile` is I'm using my fork of `SwinjectStoryboard` instead of the official one. This is because I've fixed a bug in how the project set up dependencies, and the PR is not merged yet. You can find the PR here: https://github.com/Swinject/SwinjectStoryboard/pull/44
