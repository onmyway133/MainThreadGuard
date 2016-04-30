import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.whiteColor()

    let label = UILabel()
    view.addSubview(label)

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
      label.text = "Setting text on background thread"
    }
  }
}

