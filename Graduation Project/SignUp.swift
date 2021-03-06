//
//  SignUp.swift
//  Graduation Project
//
//  Created by Mohamed Eshawy on 2/12/18.
//  Copyright © 2018 Mohamed Eshawy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SignUp: UIViewController,UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var re_passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    var passengerOrDriver = false     // passenger = false  ,   driver = true
    let imagePicker = UIImagePickerController()

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        let font = UIFont.systemFont(ofSize: 18)
        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: font],
                                                for: .normal)
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
        self.imageView.addGestureRecognizer(gesture)

    }
    @objc func someAction(_ sender:UITapGestureRecognizer){
        // do other task
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFill
            imageView.image = pickedImage
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func register(_ sender: Any) {
        guard let email = emailTextField.text , let password = re_passwordTextField.text,let name = nameTextField.text,let phone = phoneTextField.text  else {
            print("the form not valid !")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password, completion: {
            (user,error) in
            if let error=error{
                self.errorLabel.text = error.localizedDescription
                return
            }
            guard let uid=user?.uid else {
                return
            }
            self.errorLabel.text = ""
            let ref = Database.database().reference(fromURL: "https://graduationproject-f90fc.firebaseio.com/")
            if self.passengerOrDriver{ //driver
                let driverReference = ref.child("drivers").child(uid)
                let values = ["name" : name ,"phone" : phone]
                driverReference.updateChildValues(values)
            }
            else {//passenger
                let passengerReference = ref.child("passenger").child(uid)
                let values = ["name" : name ,"phone" : phone]
                passengerReference.updateChildValues(values)
            }
            print("success!")
        })
        
    }
    @IBAction func segmentedControl(_ sender: Any) {
        nameTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
        re_passwordTextField.text = ""
        phoneTextField.text = ""
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            passengerOrDriver = false
            print("passenger")
        default:
            passengerOrDriver = true
            print("driver")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
