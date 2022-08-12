//
//  RegisterViewController.swift
//  Bookd
//
//  Created by Tanishq Sharma on 2022-08-07.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var firstNameInput: UITextField!
    @IBOutlet weak var lastNameInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // adding a gesture and adding the gesture to imageView
        let gesture = UITapGestureRecognizer(target: self, action: #selector(uploadPhoto))
        imageView.addGestureRecognizer(gesture)
        self.view.addGestureRecognizer(gesture)
    }
    
    @IBAction func registerButton(_ sender: Any) {
        
        // reference for storage
        let storageRef = Storage.storage().reference();
        
        print("Registering with Firebase")
        
        //guard statements to see if the things are empty
        guard let firstName = firstNameInput.text, let lastName = lastNameInput.text, let username = usernameInput.text, let email = emailInput.text, let password = passwordInput.text, !username.isEmpty, !password.isEmpty, !email.isEmpty, !password.isEmpty, password.count >= 6 else {
            alertUserRegisterError()
            return
        }
        
        // check if the email is valid using the isValidEmail function
        guard isValidEmail(textStr: email) else {
            alertUserRegisterError(message: "Please enter a valid email")
            return
        }
        
        // Use Firebase Storage to save the image as profiles, get back the link
        guard let image = imageView.image else {
            alertUserRegisterError(message: "Please select a profile picture")
            return
        }
        
        
        // Firebase Authentication Process
        FirebaseAuth.Auth.auth().createUser(withEmail: emailInput.text!, password: passwordInput.text!, completion: {
            [weak self] authResult, error in
            
            guard let strongSelf = self else {
                return
            }
            
            guard let result = authResult, error == nil else {
                print("Error creating user")
                return
            }
            
            let user = result.user
            
            let childImageRef = storageRef.child("profiles").child(user.uid).child("picture.jpg");
            let _ = childImageRef.putData((self?.imageView.image?.pngData())!)
            
            
            // getting the donwload URL
            var profileURL = "";
            childImageRef.downloadURL { (url, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    profileURL = url?.absoluteString ?? "";
                    print(url?.absoluteString ?? "")
                }
            }
            
            
            
            DatabaseManager.shared.insertUser(with: User(firstName: firstName, lastName: lastName, username: username, emailAddress: email, uid: user.uid, currentBalance: "0"))
            
            // create an alert and display it
            let alert = UIAlertController(title: "Success", message: "You have successfully registered", preferredStyle: .alert)
            
            print("Created User: \(user)")
            
            // add action with only OK button which dismisses the view controller
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self?.dismiss(animated: true, completion: nil)
            }))
            
            // present the alert
            strongSelf.present(alert, animated: true)
        })
        
    }
    
    // Alert the user for incomplete information
    func alertUserRegisterError(message: String = "Incomple information") {
        let alert = UIAlertController(title: "Whoops", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    // Check if the email is valid
    func isValidEmail(textStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: textStr)
    }
    
    
    @objc private func uploadPhoto(){
        presentPhotoActionSheet()
    }
}



extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture", message: "Select a method", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: {
            [weak self]  _ in self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: {
            [weak self]  _ in self?.presentPhotoPicker()
        }))
        
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        
        guard let  selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        self.imageView.image = selectedImage
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}
