# MoreLoadTableView

[![CocoaPods](https://img.shields.io/cocoapods/v/MoreLoadTableView.svg)](https://github.com/TakayoshiMiyamoto/MoreLoadTableView)

MoreLoadTableView is more load UITableView.

## Screens

<img src="https://github.com/TakayoshiMiyamoto/MoreLoadTableView/blob/master/images/screen1.png" width="230px">
<img src="https://github.com/TakayoshiMiyamoto/MoreLoadTableView/blob/master/images/screen2.png" width="230px">

## Requirements

- iOS7.1+

## Install

MoreLoadTableView is available on cocoapods.

```ruby
pod 'MoreLoadTableView'
```

or include the MoreLoadTableView class in your project.

## Usage

### Swift

import header file.

``` objective-c
#import "MoreLoadTableView.h"
```

``` swift
@IBOutlet weak var tableView: MoreLoadTableView!

override func viewDidLoad() {
    super.viewDidLoad()

    self.tableView.moreDataSource = self
    self.tableView.moreDelegate = self
    self.tableView.showSectionCount = 1
    self.tableView.showRowCount = 7
}

// MARK: - MoreLoadTableViewDataSource

func numberOfSectionsInMoreLoadTableView(tableView: MoreLoadTableView!) -> Int {
    return 4
}

func moreLoadTableView(tableView: MoreLoadTableView!, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
        return 4
    }
    else if section == 1 {
        return 3
    }
    else if section == 2 {
        return 10
    }
    else if section == 3 {
        return 23
    }
    return 0
}

func initializeTableViewCellForRowAtIndexPath(indexPath: NSIndexPath!) -> UITableViewCell! {
    var cell = self.tableView.dequeueReusableCellWithIdentifier("Cell")
    if cell == nil {
        cell = tableView.dequeueReusableCellWithIdentifier("Cell")
    }
    return cell
}

func moreLoadTableViewCell(cell: AutoreleasingUnsafeMutablePointer<UITableViewCell?>, cellForRowAtIndexPath indexPath: NSIndexPath!) {
    cell.memory!.textLabel.text = "\(indexPath.section) : \(indexPath.row)"
}

// MARK: - MoreLoadTableViewDelegate

func moreLoadTableView(tableView: MoreLoadTableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
}
```

## License

This MoreLoadTableView is released under the MIT License.
See [LICENSE](/LICENSE) for details.
