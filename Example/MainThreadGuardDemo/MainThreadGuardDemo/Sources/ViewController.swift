import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white

    let label = UILabel()
    view.addSubview(label)

    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
      label.text = "Setting text on background thread"
    }
  }
}
