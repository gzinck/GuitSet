//
//  AddPerformanceSetTableViewController.swift
//  GuitSet
//
//  Created by Graeme Zinck on 2019-09-02.
//  Copyright © 2019 Graeme Zinck. All rights reserved.
//

import UIKit

class AddPerformanceSetTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var performanceSet: PerformanceSet?
    
    // Constants for the index paths of hidden areas
    let imageButtonIndexPath = IndexPath(row: 0, section: 0)
    let performanceDateLabelIndexPath = IndexPath(row: 0, section: 3)
    let performanceDatePickerIndexPath = IndexPath(row: 1, section: 3)
    var showPerformanceDatePicker = false
    
    @IBOutlet var addImageButton: UIButton!
    @IBOutlet var performanceNameField: UITextField!
    @IBOutlet var performanceLocationField: UITextField!
    @IBOutlet var performanceDateLabel: UILabel!
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
        
        // Refresh everything
        initViews()
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
    
    // Initializes the views to reflect the model
    func initViews() {
        performanceNameField.text = performanceSet?.name
        performanceLocationField.text = performanceSet?.performanceLocation
        performanceDatePicker.date = performanceSet?.performanceDate ?? Date()
        refreshPerformanceDate()
        if let imageView = addImageButton.imageView, let data = performanceSet?.image {
            imageView.image = UIImage(data: data)
        }
        
        //TODO: Add instruments
    }
    
    // Updates the model to reflect the data on the page
    func refreshModel() {
        performanceSet?.name = performanceNameField.text
        performanceSet?.performanceLocation = performanceLocationField.text
        performanceSet?.performanceDate = performanceDatePicker.date
        if let imageView = addImageButton.imageView, let image = imageView.image {
            performanceSet?.image = image.jpegData(compressionQuality: 0.6)
        }
        
        // TODO: Add instruments
        
        print(performanceSet?.name ?? "")
        print(performanceSet?.performanceLocation ?? "")
        print(performanceSet?.performanceDate ?? "")
        print(performanceSet?.image ?? "")
    }
    
    // Performance Date Management
    @IBAction func onDatePickerChanged(_ sender: Any) {
        refreshPerformanceDate()
        refreshModel()
    }
    
    func refreshPerformanceDate() {
        // Put in the correct date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        let date = dateFormatter.string(from: performanceDatePicker.date)
        performanceDateLabel.text = date
    }
    
    // Deal with a cancel action
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImageButtonPressed(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: "Select image source", message: nil, preferredStyle: .actionSheet)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelButton)
        
        // Show the camera
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(cameraAction)
        }
        
        // Show the photo library
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
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
    
    // ImagePicker delegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[.originalImage] as? UIImage else { return }
        addImageButton.setImage(pickedImage, for: .normal)
        refreshModel()
        dismiss(animated: true, completion: nil)
    }
    
    // Deal with forms
    @IBAction func fieldValueChanged(_ sender: Any) {
        refreshModel()
    }
    
    @IBAction func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
}
