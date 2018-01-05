//
//  UserInfoController.swift
//  capisce
//
//  Created by zxbMacPro on 2017/12/22.
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

class UserInfoController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    @IBOutlet weak var userHeadImgButton: Button!
    @IBOutlet weak var realNameTextField: TextField!
    @IBOutlet weak var logOutButton: Button!
    @IBOutlet weak var companySelected: UICollectionView!
    @IBOutlet weak var saveButton: Button!
    
    var companyIndex:Int = 0
    var companyDict: Company?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.isHidden = true
        realNameTextField.placeholder = "用户昵称"
        addDoneButtonOnKeyboard()
        addObservers()
    }
    
    private func addObservers() {
        
        NotificationCenter.default.addObserver(forName: .UserDidUpdate, object: nil, queue: nil) { [weak self] _ in
            self?.setupInformation()
        }
        
        NotificationCenter.default.addObserver(forName: .UserLoggedOut, object: nil, queue: nil) { [weak self] _ in
            self?.companyIndex = 0
        }
    }
    
    
    
    private func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame:CGRect(x:0,y:0,width:320,height:50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneButtonAction))
        doneToolbar.items = [flexSpace,done]
        doneToolbar.sizeToFit()
        self.realNameTextField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        realNameTextField.resignFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupInformation()
        setupCompanyDict()
        userHeadImgButton.layer.masksToBounds = true
        userHeadImgButton.layer.cornerRadius = CGFloat(Int(userHeadImgButton.frame.width)/2)
    }
    
    private func setupCompanyDict(){
        if let current = UserProfileManage.shared.getCurrentUser(),let userName = current.userName,let userToken = current.userToken{
            getCompanyInfo(userName: userName,userToken: userToken)
            if let dictionary = CompanyManage.shared.getCurrentCompany(){
                companyDict = dictionary
                self.companySelected.reloadData()
                if let childVC = self.childViewControllers.first as? UserOperationController{
                    childVC.userOperationTable.reloadData()
                }
            }
        }
    }
    
    private func getCompanyInfo(userName: String,userToken: String){
        CompanyManage.shared.getCompanyInfo(userName: userName, userToken: userToken, completion: { (msg) in
            if msg == "success"{
                print("get user information successed")
            }else{
                print("get Company information failed")
            }
        })
    }
    
    private func setupInformation(){
        if let userInfo = UserProfileManage.shared.getCurrentUser(){
            if let realName = userInfo.realName{
                realNameTextField.text = realName
                if let imageString = userInfo.headImageUrl,let imgUrl = URL(string: imageString){
                userHeadImgButton.af_setImage(for: .normal, url: imgUrl)
                }else{
                    userHeadImgButton.setImage(#imageLiteral(resourceName: "userDefault"), for: .normal)
                }
            }
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if let current = UserProfileManage.shared.getCurrentUser(),let userName = current.userName,let realName = realNameTextField.text{
            UserProfileManage.shared.postEditRealName(userName: userName, realName: realName, completion: { (result, msg) in
                if let message = msg{
                    if result == "success"{
                        self.displayGlobalAlert(title: "成功", message: message, action: "OK", completion: nil)
                    }else{
                         self.displayGlobalAlert(title: "失败", message: message, action: "OK", completion: nil)
                    }
                }
            })
        }
    }
    @IBAction func logOutTapped(_ sender: Any) {
        if let userName = UserDefaults.getUsername(){
            UserProfileManage.shared.getLogOutUser(userName: userName, completion: { (result, msg) in
                if result == "success"{
                    UserDefaults.removeUsername()
                    UserDefaults.removeUserToken()
                    AppDelegate.shared().mainTabViewController?.showLogin()
                }
            })
        }
    }
    
    
    @IBAction func userProfileButtonTapped(_ sender: Any) {
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
            attachmentMenu.popoverPresentationController?.sourceView = self.logOutButton
        }
        present(attachmentMenu, animated: true, completion: nil)
    }
    
}
extension UserInfoController: UICollectionViewDataSource,UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let number = companyDict?.company.count{
            return number
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = companySelected.dequeueReusableCell(withReuseIdentifier: "companyButtonCellId", for: indexPath) as! CompanyButtonCell
        cell.buttonLabel.text = companyDict?.company[indexPath.row].company
        cell.companyIcon.layer.masksToBounds = true
        cell.companyIcon.layer.cornerRadius = CGFloat(Int(cell.companyIcon.frame.width)/2)
        if let companyIconString = companyDict?.company[indexPath.row].companyIcon,let imgUrl = URL(string: companyIconString){
            cell.companyIcon.af_setImage(withURL: imgUrl)
        }else{
            cell.companyIcon.image = #imageLiteral(resourceName: "capisce_company_default")
        }
        return cell
            
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        companyIndex = indexPath.item
        if let childVC = self.childViewControllers.first as? UserOperationController{
            childVC.userOperationTable.reloadData()
        }
    }
}
extension UserInfoController{
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
extension UserInfoController{
    func uploadImageToAws(getImg: UIImage){
        UIApplication.shared.beginIgnoringInteractionEvents()
        let localUrl = self.saveImageToDocumentDirectory(img: getImg, idType: .userHeadImage)
        let n = ImageTypeOfID.userHeadImage.rawValue + ".JPG"
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
            if let current = UserProfileManage.shared.getCurrentUser(),let userName = current.userName{
                UserProfileManage.shared.getUserHeadImage(userName: userName, headImgUrl: publicUrl.absoluteString, completion: { (result, msg) in
                    if result == "success"{
                        if let imgUrl = URL(string: publicUrl.absoluteString){
                            let urlRequst = URLRequest.init(url: imgUrl)
                            _ = UIImageView.af_sharedImageDownloader.imageCache?.removeImage(for: urlRequst, withIdentifier: nil)
                        }
                    }else{
                        if let message = msg{
                            self.displayGlobalAlert(title: "成功", message: message, action: "ok", completion: nil)
                        }
                    }
                })
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
