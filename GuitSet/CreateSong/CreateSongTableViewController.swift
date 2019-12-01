//
//  CreateSongTableViewController.swift
//  GuitSet
//
//  Created by Graeme Zinck on 2019-12-01.
//  Copyright © 2019 Graeme Zinck. All rights reserved.
//

import UIKit

class CreateSongTableViewController: UITableViewController, UITextViewDelegate {
    
    @IBOutlet var songChords: UITextView!
    @IBOutlet var songTitleTextField: TextField!
    @IBOutlet var songArtistTextField: TextField!
    @IBOutlet var capoLabel: UILabel!
    @IBOutlet var capoStepper: UIStepper!
    @IBOutlet var doneButton: UIBarButtonItem!
    var keyboardHeight = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardHeight = self.tabbarHeight
        doneButton.title = "Create"
        // Get when the keyboard is about to show
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        tableView.isScrollEnabled = false
        songChords.isScrollEnabled = true
        
        tableView.rowHeight = UITableView.automaticDimension
        songChords.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // If we're currently working with the song chords editor, make everything else disappear
        if(songChords.isFirstResponder) {
            if(indexPath.section == 1) {
                let height = self.tableView.bounds.height
                return height - 28.0 - self.topbarHeight - keyboardHeight
            }
            return 0.0
        } else {
            if(indexPath.section == 1) {
                let height = self.tableView.bounds.height
                return height - 54.0 * 3 - 28.0 * 2 - self.topbarHeight - keyboardHeight
            }
            return 54.0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(songChords.isFirstResponder) {
            if(section == 1) {
                return 28.0
            }
            return 0
        } else {
            return 28.0
        }
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        keyboardHeight = keyboardRect.height
        doneButton.title = "Done"
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        keyboardHeight = self.tabbarHeight
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    /// Refreshes the table every time text is changed. This ensures that the sizes of each row changes dynamically.
    func textViewDidChange(_ textView: UITextView) {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        textView.scrollRangeToVisible(textView.selectedRange)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        // Do something!
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        songChords.resignFirstResponder()
        songTitleTextField.resignFirstResponder()
        songArtistTextField.resignFirstResponder()
        doneButton.title = "Create"
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
