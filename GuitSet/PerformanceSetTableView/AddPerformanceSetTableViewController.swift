//
//  AddPerformanceSetTableViewController.swift
//  GuitSet
//
//  Created by Graeme Zinck on 2019-09-02.
//  Copyright © 2019 Graeme Zinck. All rights reserved.
//

import UIKit

/**
 View controller that allows a user to create a new performance set. By selecting an image, name, location,
 instruments, and date and submitting, the resulting performance set can be accessed by the parent view
 controller by examining the UINavigationControllerDelegate sender.
 */
class AddPerformanceSetTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, InstrumentSelectorDelegate {
    
    /// The performance set being edited or created.
    var performanceSet: PerformanceSet?
    
    /// The index path for the image button in the GUI.
    let imageButtonIndexPath = IndexPath(row: 0, section: 0)
    /// The index path for the performance date label (non-editable).
    let performanceDateLabelIndexPath = IndexPath(row: 0, section: 3)
    /// The index path for the performance date picker.
    let performanceDatePickerIndexPath = IndexPath(row: 1, section: 3)
    /// Whether to display the performance date picker or not. It is hidden by default.
    var showPerformanceDatePicker = false
    
    /// The button for adding an image to the performance set.
    @IBOutlet var addImageButton: UIButton!
    /// The field for putting in the performance's name.
    @IBOutlet var performanceNameField: UITextField!
    /// The field for putting in the performance's location.
    @IBOutlet var performanceLocationField: UITextField!
    /// The label for the label stating when the performance date is.
    @IBOutlet var performanceDateLabel: UILabel!
    /// The picker for when the date should be.
    @IBOutlet var performanceDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize the image view
        addImageButton.imageView?.contentMode = .scaleAspectFill
        if let data = performanceSet?.image, let image = UIImage(data: data) {
            addImageButton.setImage(image, for: .normal)
        }
        
        // If we are creating a new performance set, do so now
        if performanceSet == nil {
            performanceSet = PerformanceSet()
        }
        initView()
    }
    
    /// Initializes the form elements with the data from the performance set.
    func initView() {
        guard let performanceSet = performanceSet else { return }
        performanceNameField.text = performanceSet.name
        performanceLocationField.text = performanceSet.performanceLocation
        performanceDatePicker.date = performanceSet.performanceDate ?? Date()
        refreshPerformanceDate()
        if let imageView = addImageButton.imageView, let data = performanceSet.image {
            imageView.image = UIImage(data: data)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        // If it's the date, must show/hide the datePicker
        if indexPath == performanceDateLabelIndexPath {
            showPerformanceDatePicker = !showPerformanceDatePicker
            view.endEditing(true)
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case performanceDatePickerIndexPath:
            // Make the date picker big when opened
            if showPerformanceDatePicker {
                performanceDatePicker.isHidden = false
                return 216.0
            } else {
                performanceDatePicker.isHidden = true
                return 0.0
            }
        case imageButtonIndexPath:
            return 200.0
        default:
            return 44.0
        }
    }
    
    /// Updates the model to reflect the data inputted in the form.
    func refreshModel() {
        performanceSet?.name = performanceNameField.text
        performanceSet?.performanceLocation = performanceLocationField.text
        performanceSet?.performanceDate = performanceDatePicker.date
        refreshPerformanceDate()
        if let imageView = addImageButton.imageView, let image = imageView.image {
            performanceSet?.image = image.jpegData(compressionQuality: 0.6)
        }
    }
    
    /// Updates the performance date label with the date chosen with the date picker.
    func refreshPerformanceDate() {
        // Put in the correct date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        let date = dateFormatter.string(from: performanceDatePicker.date)
        performanceDateLabel.text = date
    }
    
    /// When the date picker changes, updates the model.
    @IBAction func onDatePickerChanged(_ sender: Any) {
        refreshModel()
    }
    
    /// Dismiss the view (and throw away the performance set being created) when cancel.
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Present options for adding an image to the performance set.
    @IBAction func addImageButtonPressed(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        // Create a controller that will display the alert
        let alertController = UIAlertController(title: "Select image source", message: nil, preferredStyle: .actionSheet)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelButton)
        
        // Show the camera, if allowed
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(cameraAction)
        }
        
        // Show the photo library, if allowed
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(photoLibraryAction)
        }
        
        alertController.popoverPresentationController?.sourceView = sender
        present(alertController, animated: true, completion: nil)
    }
     
    /// When seguing to the Instrument Editor view, we pass it the set of instruments already here.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditInstruments" {
            guard let instrumentTableViewController = segue.destination as? InstrumentTableViewController else { return }
            instrumentTableViewController.selectedInstruments = performanceSet?.instruments ?? []
        }
    }
    
    func updateInstruments(_ selectedInstruments: [Instrument]) {
        performanceSet?.instruments = selectedInstruments
        tableView.reloadData()
    }
    
    /// Delegate method for picking images. If an image was picked, it is set as the image button's background
    /// and the model is updated.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[.originalImage] as? UIImage else { return }
        addImageButton.setImage(pickedImage, for: .normal)
        refreshModel()
        dismiss(animated: true, completion: nil)
    }
    
    /// Whenever a field's value changes, the model is updated.
    @IBAction func fieldValueChanged(_ sender: Any) {
        refreshModel()
    }
    
    /// When the return button is pressed, it closes the keyboard.
    @IBAction func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
}
