//
//  SetupCompanyController.swift
//  capisce
//
//  Created by zxbMacPro on 2017/12/25.
//  Copyright © 2017年 capisce. All rights reserved.
//

import UIKit
import Material
import AlamofireImage
import AWSCognito
import AWSCore
import AWSS3
import ALCameraViewController
import Photos

class SetupCompanyController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    @IBOutlet weak var companyIconButton: Button!
    
    @IBOutlet weak var companyNameTextField: TextField!
    
    @IBOutlet weak var companyBusinessTextField: UITextField!
    
    @IBOutlet weak var companyDescription: TextView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var companyIcon: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
    }
    
    private func setupTextField(){
        //公司名称
        companyNameTextField.placeholder  = "公司名称"
        let userNameInputLeftView = UIImageView()
        userNameInputLeftView.image = Icon.settings
        companyNameTextField.leftView = userNameInputLeftView
        //公司业务
        companyBusinessTextField.placeholder  = "公司业务"
        let phoneTextFieldLeftView = UIImageView()
        phoneTextFieldLeftView.image = Icon.phone
        companyBusinessTextField.leftView = phoneTextFieldLeftView
        //公司简介
        companyDescription.placeholder = "公司简介"
    }
    
    @IBAction func companyIconTapped(_ sender: Any) {
        let attachmentMenu = UIAlertController(title: "选择图片来源", message: "从相册选择头像或现在拍一张吧", preferredStyle: .actionSheet)
        let openLibrary = UIAlertAction(title: "相册选择", style: .default) { (action) in
            self.openImagePickerWith(source: .photoLibrary, isAllowEditing: true)
        }
        let openCamera = UIAlertAction(title: "打开相机", style: .default) { (action) in
            self.openALCameraController()
        }
        let cancelSelect = UIAlertAction(title: "取消", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        attachmentMenu.addAction(openLibrary)
        attachmentMenu.addAction(openCamera)
        attachmentMenu.addAction(cancelSelect)
        if UIDevice.current.userInterfaceIdiom == .pad {
            attachmentMenu.popoverPresentationController?.sourceView = self.companyDescription
        }
        present(attachmentMenu, animated: true, completion: nil)
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if let currentUser = UserProfileManage.shared.getCurrentUser(){
            if let userName = currentUser.userName,let userToken = currentUser.userToken,let company = companyNameTextField.text,let business = companyBusinessTextField.text,let companyIconString = companyIcon,let description = companyDescription.text{
                CompanyManage.shared.createCompany(userName: userName, company: company, business: business, description: description, companyIcon: companyIconString, completion: { (result, msg) in
                    if result == "success"{
                        self.getNewCompanyInfo(userName: userName,userToken: userToken)
                    }else{
                        self.displayGlobalAlert(title: "错误", message: msg!, action: "Ok", completion: nil)
                    }
                })
            }
        }
    }
    
    private func getNewCompanyInfo(userName: String,userToken: String){
        CompanyManage.shared.getCompanyInfo(userName: userName, userToken: userToken) { (result) in
            if result == "success"{
                self.navigationController?.popToRootViewController(animated: true)
            }else{
                self.displayGlobalAlert(title: "错误", message: "get company information failed", action: "Ok", completion: nil)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        companyNameTextField.resignFirstResponder()
        companyBusinessTextField.resignFirstResponder()
        companyDescription.resignFirstResponder()
    }
}
extension SetupCompanyController{
    func openImagePickerWith(source: UIImagePickerControllerSourceType, isAllowEditing: Bool){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = source
        imagePicker.allowsEditing = isAllowEditing
        imagePicker.delegate = self
        imagePicker.navigationBar.isTranslucent = false
        imagePicker.navigationBar.barTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) // Background color
        imagePicker.navigationBar.tintColor = .white // Cancel button ~ any UITabBarButton items
        imagePicker.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white] // Title color
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var getImg : UIImage = #imageLiteral(resourceName: "userDefault")
        if let editedImg = info[UIImagePickerControllerEditedImage] as? UIImage {
            getImg = editedImg
        }else if let originalImg = info[UIImagePickerControllerOriginalImage] as? UIImage {
            getImg = originalImg
        }
        uploadImageToAws(getImg: getImg)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func openALCameraController(){
        let corpingParms = CroppingParameters(isEnabled: true, allowResizing: true, allowMoving: true, minimumSize: CGSize(width: 160, height: 160))
        let cameraViewController = CameraViewController(croppingParameters: corpingParms, allowsLibraryAccess: true, allowsSwapCameraOrientation: true, allowVolumeButtonCapture: true, completion: { (getImg, phAsset) in
            
            if let image = getImg {
                //                self.setupProfileImage(image)
                self.uploadImageToAws(getImg: image)
            }
            self.dismiss(animated: true, completion: nil)
        })
        self.present(cameraViewController, animated: true, completion: nil)
    }
}
/// MARK: - Image upload to AWS
extension SetupCompanyController{
    func uploadImageToAws(getImg: UIImage){
        UIApplication.shared.beginIgnoringInteractionEvents()
        let localUrl = self.saveImageToDocumentDirectory(img: getImg, idType: .companyIcon)
        let n = ImageTypeOfID.companyIcon.rawValue + ".JPG"
        AwsServerManager.shared.uploadFile(fileName: n, imgIdType: .userHeadImage, localUrl: localUrl, completion: { (err, awsUrl) in
            self.handleAwsServerImageUploadCompletion(err, awsUrl)
        })
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleAwsServerImageUploadCompletion(_ error: Error?, _ awsUrl: URL?){
        if let err = error {
            print(err)
            UIApplication.shared.endIgnoringInteractionEvents()
            let msg = "请检查您的网络设置或重新登陆，也可联系客服获取更多帮助，为此给您带来的不便我们深表歉意！出现错误：\(err)"
            self.displayGlobalAlert(title: "⛔️上传出错了", message: msg, action: "朕知道了", completion: nil)
        }
        if let publicUrl = awsUrl, publicUrl.absoluteString != "" {
            print("HomePageController++: uploadImage get publicUrl.absoluteStr = \(publicUrl.absoluteString)")
            companyIcon = publicUrl.absoluteString
            if let companyIconString = companyIcon,let imgUrl = URL(string: companyIconString){
                companyIconButton.af_setImage(for: .normal, url: imgUrl)
            }else{
                companyIconButton.setImage(#imageLiteral(resourceName: "capisce_company_default"), for: .normal)
            }
        }else{
            print("errrorrr!!! uploadAllImagesToAws(): task.result is nil, !!!! did not upload")
        }
    }
    
    func saveImageToDocumentDirectory(img : UIImage, idType: ImageTypeOfID) -> URL {
        let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "\(idType.rawValue).JPG" // UserDefaultKey.profileImageLocalName.rawValue
        let profileImgLocalUrl = documentUrl.appendingPathComponent(fileName)
        if let imgData = UIImageJPEGRepresentation(img, imageCompress) {
            try? imgData.write(to: profileImgLocalUrl, options: .atomic)
        }
        print("save image to DocumentDirectory: \(profileImgLocalUrl)")
        return profileImgLocalUrl
    }
    
    func removeImageWithUrlInLocalFileDirectory(fileName: String){
        let fileManager = FileManager.default
        let documentUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
        if let filePath = documentUrl.path {
            print("try to remove file from path: \(filePath), fileExistsAtPath==\(fileManager.fileExists(atPath: filePath))")
            do {
                try fileManager.removeItem(atPath: "\(filePath)/\(fileName)")
                print("OK remove file at path: \(filePath), fileName = \(fileName)")
            } catch let err {
                print("error : when trying to move file: \(fileName), from path = \(filePath), get err = \(err)")
            }
        }
    }
}
