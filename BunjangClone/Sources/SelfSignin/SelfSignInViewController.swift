//
//  SelfLoginViewController.swift
//  BunjangClone
//
//  Created by 류창휘 on 2021/12/05.
//



import Foundation
import UIKit
import TweeTextField
class SelfSignInViewController: BaseViewController {
    //MARK: - Properties
    
    @IBOutlet var nameTextField: TweeAttributedTextField!
    @IBOutlet var emailTextField: TweeAttributedTextField!
    @IBOutlet var passwordTextField: TweeAttributedTextField!
    @IBOutlet var storeNameTextField: TweeAttributedTextField!
    @IBOutlet weak var correctBtn: UIButton!
    
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.storeNameTextField.delegate = self
        correctBtn.layer.cornerRadius = 5
        //Dismiss Keyboard When Tapped Arround

    }
    //화면 아무 곳이나 누르면 키보드 닫기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    //MARK: - Actions
    @IBAction func backBtn(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func EmailWhileEditing(_ sender: TweeAttributedTextField) {

        
        
        if let userInput = sender.text {
            if userInput.count == 0 {
                return
            }
            
            if userInput.isValidEmail == true {
                sender.infoTextColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
                sender.showInfo("이메일 형식입니다.", animated: true)
            } else {
                sender.infoTextColor = .red
                sender.showInfo("이메일 형식이 아닙니다.", animated: true)
            }
        }
    }
    
    
    
    @IBAction func nextBtn(_ sender: Any) {
        if nameTextField.text == "" || emailTextField.text == "" || passwordTextField.text == "nil" || storeNameTextField.text == "" {
            let failAlert = UIAlertController(title: "회원가입 실패", message: "모든 사항을 입력해주세요", preferredStyle: .alert)
            let okayBtn = UIAlertAction(title: "확인", style: .default, handler: nil)
            failAlert.addAction(okayBtn)
            present(failAlert, animated: true, completion: nil)
        } else {
                SelfSignInUserInto.email = emailTextField.text!
                SelfSignInUserInto.password = passwordTextField.text!
                SelfSignInUserInto.storeName = storeNameTextField.text!
                SelfSignInDataManager().signInPostData()
            

            
            self.showIndicator() //로딩나타남
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.dismissIndicator() //로딩해제
                if SignResponse.ResponseState == false {
                    self.presentAlert(title: "회원가입에 실패하였습니다.")
                } else if SignResponse.ResponseState == true {
//                    self.presentAlert(title: "회원가입에 성공하였습니다.")
                    self.presentBottomAlert(message: "회원가입에 성공하였습니다.")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                        self.dismiss(animated: true, completion: nil)
                    })
                }
        }
    }
        
    }
    
}

extension SelfSignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            print("이름 텍스트필드")
        }
        if textField == emailTextField {
            print("이메일 텍스트필드")
        }
        if textField ==  passwordTextField {
            print("패스워드 텍스트필드")
        }
        if textField == storeNameTextField {
            print("상점 텍스트필드")
        }
        textField.resignFirstResponder()
        return true
    }
}
