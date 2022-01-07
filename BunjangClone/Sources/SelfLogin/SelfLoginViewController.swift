//
//  SelfLoginViewController.swift
//  BunjangClone
//
//  Created by 류창휘 on 2021/12/10.

import Foundation
import UIKit
import TweeTextField

class SelfLoginViewController: BaseViewController {
    //MARK: - Properties
    @IBOutlet weak var selfLoginIDTextField: TweeAttributedTextField!
    @IBOutlet weak var selfLoginOKBtn: UIButton!
    @IBOutlet weak var selfLoginPasswordTextField: TweeAttributedTextField!
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        selfLoginOKBtn.layer.cornerRadius = 5
        selfLoginIDTextField.delegate = self
        selfLoginPasswordTextField.delegate = self
        

    }
    
    //화면 아무 곳이나 누르면 키보드 닫기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    //MARK: - Actions
    @IBAction func selfLogInBtn(_ sender: Any) {
        if selfLoginIDTextField.text == "" || selfLoginPasswordTextField.text == "" {
            presentAlert(title: "모든 사항을 입력해주세요")
        } else {
            //API
            SelfLoginUserInfo.loginEmail = self.selfLoginIDTextField.text!
            SelfLoginUserInfo.loginPassword = self.selfLoginPasswordTextField.text!
            SelfLoginDataManager().LoginPostData()
            
            self.showIndicator()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                self.dismissIndicator()
                if LoginResponse.ResponseState == true {
                    UserDefaults.standard.set(true, forKey: "login_save")
                    self.presentBottomAlert(message: "로그인에 성공하였습니다.")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                        let mainstoryboard = UIStoryboard.init(name: "Main", bundle: nil)
                        guard let homeNavigationVC = mainstoryboard.instantiateViewController(identifier: "HomeNavigationViewController") as? HomeNavigationViewController else { return }
                        homeNavigationVC.modalPresentationStyle = .fullScreen
                        self.present(homeNavigationVC, animated: true, completion: nil)
                    })
                } else if LoginResponse.ResponseState == false {
                    self.presentAlert(title: "로그인에 실패하였습니다.")
                }
            })

        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func IDWhileEditing(_ sender: TweeAttributedTextField) {
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
    
    
    
}

//MARK: - textfieldDelegate
extension SelfLoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("SelfLoginViewController - textfieldShouldReturn ")
        if textField == selfLoginIDTextField {
            print("이메일 입력 텍스트 필드 입니다.")
            
        }
        if textField == selfLoginPasswordTextField {
            print("비밀번호 입력 텍스트 필드입니다.")
            
        }
        //포커스 해제
        textField.resignFirstResponder()
        return true
    }
}
