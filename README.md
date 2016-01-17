# CXAAutoRemovalNotification

*Notice*: observers of `NSNotificationCenter` are not required to un-register in their deallocation since iOS 9 / OS X 10.11: (https://developer.apple.com/library/prerelease/mac/releasenotes/Foundation/RN-Foundation/index.html#10_11NotificationCenter)

Less boilerplate code for `NSNotificationCenter`.

## Usage

Simply add `NSObject+CXAAutoRemovalNotification.{h|m}` to your project. 

Whereever you need `NSNotificationCenter` to observe using block by `- addObserverForName:object:queue:usingBlock:`, just replace it with `-cxa_addObserverForName:object:queue:usingBlock:`, or if don't care `object` and `queue`, use the shorter `- cxa_addObserverForName:usingBlock:` for your notification observer. `CXAAutoRemovalNotification` will take care of the observer removal in deallocation.

### Example
	__weak typeof(self) weakSelf = self;
	[self cxa_addObserverForName:UIContentSizeCategoryDidChangeNotification usingBlock:^(NSNotification *note) {
	   [weakSelf.tableView reloadData];
	}];
		
## Creator

* GitHub: <https://github.com/cxa>
* Twitter: [@_cxa](https://twitter.com/_cxa)
* Apps available in App Store: <http://lazyapps.com>

## License

Under the MIT license. See the LICENSE file for more information.
