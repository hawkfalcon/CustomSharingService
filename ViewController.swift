import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var shareButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.sendAction(on: .leftMouseDown)
    }
    
    @IBAction func shareSheet(_ sender: NSButton) {
        let text = textField.stringValue
        let sharingPicker = NSSharingServicePicker(items: [text])
        
        sharingPicker.delegate = self
        sharingPicker.show(relativeTo: NSZeroRect, of: sender, preferredEdge: .minY)
    }
    
    func setClipboard(text: String) {
        let clipboard = NSPasteboard.general
        clipboard.clearContents()
        clipboard.setString(text, forType: .string)
    }
}

extension ViewController: NSSharingServicePickerDelegate {
    func sharingServicePicker(_ sharingServicePicker: NSSharingServicePicker, sharingServicesForItems items: [Any], proposedSharingServices proposedServices: [NSSharingService]) -> [NSSharingService] {
        guard let image = NSImage(named: NSImage.Name("copy")) else {
            return proposedServices
        }
        
        var share = proposedServices
        let customService = NSSharingService(title: "Copy Text", image: image, alternateImage: image, handler: {
            if let text = items.first as? String {
                self.setClipboard(text: text)
            }
        })
        share.insert(customService, at: 0)
        
        return share
    }
}

