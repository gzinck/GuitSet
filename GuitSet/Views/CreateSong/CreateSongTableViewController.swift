//
//  CreateSongTableViewController.swift
//  GuitSet
//
//  Created by Graeme Zinck on 2019-12-01.
//  Copyright © 2019 Graeme Zinck. All rights reserved.
//

import UIKit

/**
 View controller for creating (or editing) a song. It allows editing the song name, artist, capo, and chords.
 */
class CreateSongTableViewController: UITableViewController, UITextViewDelegate {
    
    /// UITextView with the user-inputted lyrics and chords for the song being created.
    @IBOutlet var songChords: UITextView!
    /// The field for the song's title.
    @IBOutlet var songTitleTextField: TextField!
    /// The field for the artist's name.
    @IBOutlet var songArtistTextField: TextField!
    /// The label stating the capo selected.
    @IBOutlet var capoLabel: UILabel!
    /// The stepper that increases/decreases the capo.
    @IBOutlet var capoStepper: UIStepper!
    /// The button that allows the user to close the keyboard or create the song.
    @IBOutlet var doneButton: UIBarButtonItem!
    /// The height of the keyboard. If the keyboard is not visible, it is the height of the navigation bar at the bottom.
    var keyboardHeight = CGFloat()
    /// Boolean representing whether the done button should create the song on the next press.
    var shouldCreateSong = true
    /// Boolean representing whether the chords section is being selected/worked on.
    var chordsSelected = false
    /// The song being created
    var song: Song?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Calculate the height of the keyboard at any given time
        // When the keyboard is not visible, just let it be equal to the tabbar
        keyboardHeight = self.tabbarHeight
        
        // The button should read "Create", except when we want it to dismiss the keyboard
        doneButton.title = "Create"
        
        // Get when the keyboard is about to show/hide
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Make sure scrolling is disabled for the main TableView, but enabled for
        // the chords section
        tableView.isScrollEnabled = false
        songChords.isScrollEnabled = true
        
        // Get notified when the chords text area changes
        songChords.delegate = self
        
        // Create the song
        song = SongController.createSong()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // Remove the song if it's actually just blank...
        guard let song = song else { return }
        if(song.isEmpty) {
            SongController.removeSong(song)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // If we're currently working with the song chords editor, make everything else disappear
        let guide = tableView.safeAreaLayoutGuide
        if(chordsSelected) {
            if(indexPath.section == 1) {
                let height = guide.layoutFrame.size.height
                return height - 28.0 - keyboardHeight // Leave 28px for header
            }
            return 0.0
        } else {
            if(indexPath.section == 1) {
                let height = guide.layoutFrame.size.height
                return height - 54.0 * 3 - 28.0 * 2 - keyboardHeight
            }
            return 54.0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // Don't show headers if we're working on the chords
        if(chordsSelected) {
            if(section == 1) {
                return 28.0 // Just show the chords header
            }
            return 0
        } else {
            return 28.0
        }
    }
    
    /// Adjusts the views by changing heights of items in the table view. Also makes the done button close the keyboard.
    @objc func keyboardWillShow(_ notification: NSNotification) {
        // Get the rectangle for the keyboard so we can extract the height
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        keyboardHeight = keyboardRect.height
        
        if(songChords.isFirstResponder) {
            chordsSelected = true
        }
        
        // Make the done button say "Done" to close the keyboard
        doneButton.title = "Done"
        shouldCreateSong = false
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    /// Resets the views by saying that there is more height available for visual elements.
    @objc func keyboardWillHide(_ notification: NSNotification) {
        keyboardHeight = self.tabbarHeight
        chordsSelected = false
        
        // Make the done button say "Create" (since no longer need a button for closing keyboard)
        doneButton.title = "Create"
        shouldCreateSong = true
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    /// Refreshes the table every time text is changed. This ensures that the sizes of each row changes dynamically.
    func textViewDidChange(_ textView: UITextView) {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        textView.scrollRangeToVisible(textView.selectedRange)
        song?.chords = songChords.text
    }
    
    /// Refreshes the song with the current information {
    func refreshSong() {
        if let title = songTitleTextField.text {
            song?.title = title
        }
        if let artist = songArtistTextField.text {
            song?.artist = artist
        }
        if let capoText = capoLabel.text, let capo = Int(capoText) {
            song?.capo = capo
        }
        song?.chords = songChords.text
    }
    
    /// Refreshes the view when a text field changes
    @IBAction func valueChanged(_ sender: Any) {
        refreshSong()
    }
    
    /// Creates the song if the keyboard is not engaged. Otherwise, it just closes the keyboard.
    @IBAction func doneButtonPressed(_ sender: Any) {
        if(shouldCreateSong) {
            song?.draft = false
            SongController.songsUpdated()
            dismiss(animated: true, completion: nil)
        } else {
            songChords.resignFirstResponder()
            songTitleTextField.resignFirstResponder()
            songArtistTextField.resignFirstResponder()
            
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
}
