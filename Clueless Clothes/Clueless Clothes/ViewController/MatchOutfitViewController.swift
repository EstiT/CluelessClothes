//
//  SecondViewController.swift
//  Clueless Clothes
//
//  Created by Esti Tweg on 2018-10-15.
//  Copyright © 2018 Esti Tweg. All rights reserved.
//

import UIKit

class MatchOutfitViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ShowCollectionsDelegate, UIAdaptivePresentationControllerDelegate {
    
    enum clothesItemCombination {
        case JacketDressShoes
        case JacketDress
        case Dress
        case DressShoes
        case JacketTopBottomShoes
        case JacketTopBottom
        case TopBottom
        case TopBottomShoes
    }
    

    @IBOutlet weak var topsCollection: UICollectionView!
    @IBOutlet weak var dressesCollection: UICollectionView!
    @IBOutlet weak var jacketsCollection:UICollectionView! //TODO
    @IBOutlet weak var bottomsCollection: UICollectionView!
    @IBOutlet weak var shoesCollection: UICollectionView!
    
    @IBOutlet weak var noTopsLabel: UILabel!
    @IBOutlet weak var noDressesLabel: UILabel!
    @IBOutlet weak var noJacketsLabel: UILabel!
    @IBOutlet weak var noBottomsLabel: UILabel!
    @IBOutlet weak var noShoesLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var collectionsHolder: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var matchButton: UIButton!
    
    var showTops: Bool!
    var showDresses: Bool!
    var showJackets: Bool!
    var showBottoms: Bool!
    var showShoes: Bool!
    var deleteView: Bool = false
    
    var selectedCombo: clothesItemCombination!
    ///to try: https://adoptioncurve.net/2013/07/02/building-a-circular-gallery-with-a-uicollectionview/
    
    var longPress = UILongPressGestureRecognizer() //TODO implement show X and delete
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if showTops == nil {
            showTops = true
        }
        if showDresses == nil {
            showDresses = false
        }
        if showJackets == nil {
            showJackets = false
        }
        if showBottoms == nil {
            showBottoms = true
        }
        if showShoes == nil {
            showShoes = false
        }
        
        viewDidAppear(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setComboEnum()
        showHideCollectionElements()
        setUpCollectionViews()
        checkColorTheme()
        enableDisableMatchButton()
    }
    
    func checkColorTheme(){
        if #available(iOS 12.0, *) {
//          https://stackoverflow.com/questions/56457395/how-to-check-for-ios-dark-mode
            var statusbarColor = UIColor()
            if self.traitCollection.userInterfaceStyle == .dark {
                topView.backgroundColor = .darkGray
                mainView.backgroundColor = Utility.deepMagenta
                statusbarColor = .darkGray
            }
            else {
                topView.backgroundColor = Utility.softYellow
                mainView.backgroundColor = Utility.brightYellow
                statusbarColor = Utility.softYellow
            }
//          https://freakycoder.com/ios-notes-13-how-to-change-status-bar-color-1431c185e845
            if #available(iOS 13.0, *) {
                let app = UIApplication.shared
                let statusBarHeight: CGFloat = app.statusBarFrame.size.height
                
                let statusbarView = UIView()
                statusbarView.backgroundColor = statusbarColor
                view.addSubview(statusbarView)
              
                statusbarView.translatesAutoresizingMaskIntoConstraints = false
                statusbarView.heightAnchor
                    .constraint(equalToConstant: statusBarHeight).isActive = true
                statusbarView.widthAnchor
                    .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
                statusbarView.topAnchor
                    .constraint(equalTo: view.topAnchor).isActive = true
                statusbarView.centerXAnchor
                    .constraint(equalTo: view.centerXAnchor).isActive = true
            }
            else {
                let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
                statusBar?.backgroundColor = statusbarColor
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        checkColorTheme()
    }
    
    func setUpCollectionViews(){
        var topsCollectionHeight = 0.0
        var bottomsCollectionHeight = 0.0
        var dressCollectionHeight = 0.0
        //var jacketCollectionHeight = 0.0 TODO
        var shoesCollectionHeight = 0.0
        var shoesY:CGFloat = 0.0
        
        switch selectedCombo {
        case .JacketDressShoes?: //TODO
            dressCollectionHeight = 0.76
            shoesCollectionHeight = 0.12
            shoesY = CGFloat((collectionsHolder.frame.height * CGFloat(dressCollectionHeight)))
        case .JacketDress?: //TODO
            dressCollectionHeight = 1.0
        case .Dress?:
            dressCollectionHeight = 1.0
        case .DressShoes?:
            dressCollectionHeight = 0.76
            shoesCollectionHeight = 0.21
            shoesY = CGFloat((collectionsHolder.frame.height * CGFloat(dressCollectionHeight))+(collectionsHolder.frame.height * CGFloat(0.0275)))
        //(collectionsHolder.frame.height * CGFloat(6))
        case .JacketTopBottomShoes?: //TODO
            topsCollectionHeight = 0.32
            bottomsCollectionHeight = 0.47
            shoesCollectionHeight = 0.15
            shoesY = collectionsHolder.frame.height * CGFloat(topsCollectionHeight)+(collectionsHolder.frame.height * CGFloat(0.0275)) + collectionsHolder.frame.height * CGFloat(bottomsCollectionHeight)+(collectionsHolder.frame.height * CGFloat(0.0275))
        case .JacketTopBottom?:  //TODO
            topsCollectionHeight = 0.35
            bottomsCollectionHeight = 0.55
        case .TopBottom?:
            topsCollectionHeight = 0.39
            bottomsCollectionHeight = 0.58
        case .TopBottomShoes?:
            topsCollectionHeight = 0.32
            bottomsCollectionHeight = 0.47
            shoesCollectionHeight = 0.15
            shoesY = collectionsHolder.frame.height * CGFloat(topsCollectionHeight)+(collectionsHolder.frame.height * CGFloat(0.0275)) + collectionsHolder.frame.height * CGFloat(bottomsCollectionHeight)+(collectionsHolder.frame.height * CGFloat(0.0275))
        default:
            print("uh oh")
        }
        
        setUpCollectionView(cv: topsCollection, frame: CGRect(x: 0, y: 0, width: collectionsHolder.frame.width, height: collectionsHolder.frame.height * CGFloat(topsCollectionHeight)))
        setUpCollectionView(cv: bottomsCollection, frame: CGRect(x: 0, y: collectionsHolder.frame.height * CGFloat(topsCollectionHeight)+12, width: collectionsHolder.frame.width, height: collectionsHolder.frame.height * CGFloat(bottomsCollectionHeight)))
        setUpCollectionView(cv: dressesCollection, frame: CGRect(x: 0, y: 0, width: collectionsHolder.frame.width, height: collectionsHolder.frame.height * CGFloat(dressCollectionHeight)))
        setUpCollectionView(cv: shoesCollection, frame: CGRect(x: 0, y: shoesY, width: collectionsHolder.frame.width, height: collectionsHolder.frame.height * CGFloat(shoesCollectionHeight)))
        //        setUpCollectionView(bottomsCollection) TODO Jacket
        
        setNoClothesLabelY()
    }
    
    func setNoClothesLabelY(){
        noTopsLabel.center.y = topsCollection.frame.midY
        noBottomsLabel.center.y = bottomsCollection.frame.midY
        noDressesLabel.center.y = dressesCollection.frame.midY
        //        noJacketsLabel.center.y = jacketsCollection.frame.midY TODO
        noShoesLabel.center.y = shoesCollection.frame.midY
    }
    
    func setComboEnum(){
        if showJackets && showDresses && showShoes && !showTops && !showBottoms{
            selectedCombo = clothesItemCombination.JacketDressShoes
        }
        else if showJackets && showDresses && !showShoes && !showTops && !showBottoms{
            selectedCombo = clothesItemCombination.JacketDress
        }
        else if !showJackets && showDresses && !showShoes && !showTops && !showBottoms{
            selectedCombo = clothesItemCombination.Dress
        }
        else if !showJackets && showDresses && showShoes && !showTops && !showBottoms{
            selectedCombo = clothesItemCombination.DressShoes
        }
        else if showJackets && !showDresses && showShoes && showTops && showBottoms{
            selectedCombo = clothesItemCombination.JacketTopBottomShoes
        }
        else if showJackets && !showDresses && !showShoes && showTops && showBottoms{
            selectedCombo = clothesItemCombination.JacketTopBottom
        }
        else if !showJackets && !showDresses && !showShoes && showTops && showBottoms{
            selectedCombo = clothesItemCombination.TopBottom
        }
        else if !showJackets && !showDresses && showShoes && showTops && showBottoms{
            selectedCombo = clothesItemCombination.TopBottomShoes
        }
    }
    
    func updateShowCollectons(tops: Bool, dresses: Bool, jackets: Bool, bottoms: Bool, shoes: Bool) {
        showTops = tops
        showDresses = dresses
        showJackets = jackets
        showBottoms = bottoms
        showShoes = shoes
        
        setComboEnum()
        showHideCollectionElements()
    }
    
    func enableDisableMatchButton(){
        if noTopsLabel.isHidden &&
            noDressesLabel.isHidden &&
//            noJacketsLabel.isHidden &&
            noBottomsLabel.isHidden &&
            noShoesLabel.isHidden {
            matchButton.isEnabled = true
            matchButton.alpha = 1
        }
        else{
            matchButton.isEnabled = false
            matchButton.alpha = 0.6
        }
    }
    
    @IBAction func matchOutfit(_ sender: Any) {
        var topName:String!
        var bottomName:String!
        var dressName:String!
        var shoesName:String!
        var jacketName:String!  // TODO
        
        if !topsCollection.isHidden{
            let visibleRect = CGRect(origin: topsCollection.contentOffset, size: topsCollection.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            if let visibleIndexPath = topsCollection.indexPathForItem(at: visiblePoint){
                let cell = topsCollection.cellForItem(at: visibleIndexPath) as! ImageCell
                topName = cell.id
            }
        }
        if !bottomsCollection.isHidden{
            let visibleRect = CGRect(origin: bottomsCollection.contentOffset, size: bottomsCollection.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            if let visibleIndexPath = bottomsCollection.indexPathForItem(at: visiblePoint){
                let cell = bottomsCollection.cellForItem(at: visibleIndexPath) as! ImageCell
                bottomName = cell.id
            }
        }
        if !dressesCollection.isHidden{
            let visibleRect = CGRect(origin: dressesCollection.contentOffset, size: dressesCollection.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            if let visibleIndexPath = dressesCollection.indexPathForItem(at: visiblePoint){
                let cell = dressesCollection.cellForItem(at: visibleIndexPath) as! ImageCell
                dressName = cell.id
            }
        }
        /* TODO
        if !jacketsCollection.isHidden{
         
         
        }*/
        if !shoesCollection.isHidden{
            let visibleRect = CGRect(origin: shoesCollection.contentOffset, size: shoesCollection.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            if let visibleIndexPath = shoesCollection.indexPathForItem(at: visiblePoint){
                let cell = shoesCollection.cellForItem(at: visibleIndexPath) as! ImageCell
                shoesName = cell.id
            }
        }
        
        var clothes = [ClothingItem]()
        
        switch selectedCombo {
        case .JacketDressShoes?:
            clothes = [Dress(imageName: dressName),Jacket(imageName: jacketName), Shoes(imageName: shoesName)]
            
        case .JacketDress?:
            clothes = [Dress(imageName: dressName),Jacket(imageName: jacketName)]
            
        case .Dress?:
            clothes = [Dress(imageName: dressName)]
            
        case .DressShoes?:
            clothes = [Dress(imageName: dressName), Shoes(imageName: shoesName)]
            
        case .JacketTopBottomShoes?:
            clothes = [Top(imageName: topName),Jacket(imageName: jacketName), Bottom(imageName: bottomName), Shoes(imageName: shoesName)]
            
        case .JacketTopBottom?:
            clothes = [Top(imageName: topName),Jacket(imageName: jacketName), Bottom(imageName: bottomName)]
            
        case .TopBottom?:
            clothes = [Top(imageName: topName), Bottom(imageName: bottomName)]
            
        case .TopBottomShoes?:
            clothes = [Top(imageName: topName), Bottom(imageName: bottomName), Shoes(imageName: shoesName)]
            
        default:
            print("uh oh")
        }
       
        let outfit = Outfit(clothes: clothes)
        Closet.shared.addOutfit(outfit: outfit)
        
        let alert = UIAlertController(title: "Matched!", message: "Outfit has been added to closet", preferredStyle: .alert)
        self.present(alert, animated:true, completion: {
            Timer.scheduledTimer(withTimeInterval: 4, repeats:false, block:
                {_ in
                    self.dismiss(animated: true, completion: nil)
                })
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
        })
    }
    
    
    @IBAction func editButtonClicked(_ sender: Any) {
        deleteView = !deleteView
        editButton.setTitle(deleteView ? "done" : "edit", for: .normal)
        setUpCollectionViews()
    }
    
    @objc func alertControllerBackgroundTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeComponents" {
            if let ChangeOutfitComponentsVC = segue.destination as? ChangeOutfitComponentsViewController {
                ChangeOutfitComponentsVC.tops = showTops
                ChangeOutfitComponentsVC.dresses = showDresses
                ChangeOutfitComponentsVC.jackets = showJackets
                ChangeOutfitComponentsVC.bottoms = showBottoms
                ChangeOutfitComponentsVC.shoes = showShoes
                
                ChangeOutfitComponentsVC.delegate = self
                segue.destination.presentationController?.delegate = self
            }
        }
    }
    
    //https://stackoverflow.com/questions/56568967/detecting-sheet-was-dismissed-on-ios-13
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController){
        viewDidAppear(false)
    }

    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        viewDidAppear(false)
     }

    
    //MARK:- CollectionView
    
    func showHideCollectionElements(){
        dressesCollection.isHidden = !showDresses
        bottomsCollection.isHidden = !showBottoms
        shoesCollection.isHidden = !showShoes
        topsCollection.isHidden = !showTops
        if showTops{
            if Closet.shared.tops.count > 0 {
                noTopsLabel.isHidden = true
                let midIndexPath = IndexPath(row: Closet.shared.tops.count / 2, section: 0)
                //topsCollection.scrollToItem(at: midIndexPath, at: .centeredHorizontally, animated: false)
            }
            else {
                topsCollection.isHidden = true
                noTopsLabel.isHidden = false
            }
        }
        else {
            noTopsLabel.isHidden = true
        }
        
        if showDresses{
            if Closet.shared.dresses.count > 0 {
                noDressesLabel.isHidden = true
                let midIndexPath = IndexPath(row: Closet.shared.dresses.count / 2, section: 0)
                //dressesCollection.scrollToItem(at: midIndexPath, at: .centeredHorizontally, animated: false)
            }
            else {
                dressesCollection.isHidden = true
                noDressesLabel.isHidden = false
            }
        }
        else {
            noDressesLabel.isHidden = true
        }
        
        if showBottoms{
            if Closet.shared.bottoms.count > 0 {
                noBottomsLabel.isHidden = true
                let midIndexPath = IndexPath(row: Closet.shared.bottoms.count / 2, section: 0)
                //bottomsCollection.scrollToItem(at: midIndexPath, at: .centeredHorizontally, animated: false)
            }
            else{
                bottomsCollection.isHidden = true
                noBottomsLabel.isHidden = false
            }
        }
        else {
            noBottomsLabel.isHidden = true
        }
        
        if showShoes{
            if Closet.shared.shoes.count > 0 {
                noShoesLabel.isHidden = true
                let midIndexPath = IndexPath(row: Closet.shared.bottoms.count / 2, section: 0)
                //shoesCollection.scrollToItem(at: midIndexPath, at: .centeredHorizontally, animated: false)
            }
            else{
                shoesCollection.isHidden = true
                noShoesLabel.isHidden = false
            }
        }
        else {
            noShoesLabel.isHidden = true
        }
    }
    
    func setUpCollectionView(cv: UICollectionView, frame: CGRect){
        cv.allowsSelection = true
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = .clear
        cv.frame = frame
        let itemWidth = view.frame.width - 30 * 4 // w0 == ws TODO
        let itemSize = CGSize(width: itemWidth, height: frame.height)
        let minimumLineSpacing:CGFloat = 20
        let inset:CGFloat = (view.frame.width - itemWidth)/2
        cv.contentInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        if let collectionViewFlowLayout = cv.collectionViewLayout as? WLCollectionViewLayout {
            collectionViewFlowLayout.itemSize = itemSize
            collectionViewFlowLayout.minimumLineSpacing = minimumLineSpacing
            collectionViewFlowLayout.scrollDirection = .horizontal
        }

        cv.isPagingEnabled = false
        cv.reloadData()
    
        longPress = UILongPressGestureRecognizer(target: self, action: #selector(deleteImage(_:)))
        
        cv.addGestureRecognizer(longPress)
        cv.isUserInteractionEnabled = true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if collectionView == self.topsCollection{
            return Closet.shared.tops.count
        }
        else if collectionView == self.dressesCollection{
            return Closet.shared.dresses.count
        }
        else if collectionView == self.bottomsCollection{
            return Closet.shared.bottoms.count
        }
        else if collectionView == self.shoesCollection{
            return Closet.shared.shoes.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.image.addGestureRecognizer(longPress)
        cell.image.isUserInteractionEnabled = true
        
        //set image for colection view
        var name = ""
        if collectionView == self.topsCollection {
            name = Closet.shared.tops[indexPath.row].imageName
        }
        else if collectionView == self.dressesCollection {
            name = Closet.shared.dresses[indexPath.row].imageName
        }
        else if collectionView == self.bottomsCollection {
            name = Closet.shared.bottoms[indexPath.row].imageName
        }
        else if collectionView == self.shoesCollection {
            name = Closet.shared.shoes[indexPath.row].imageName
        }
        
        //TESTING
        let regex = try! NSRegularExpression(pattern: "[0-9]$")
        let range = NSRange(location: 0, length: name.utf16.count)
        if regex.firstMatch(in: name, options: [], range: range) != nil {
            cell.image.image = Utility.getImage(imageName: name)
        }
        else{
            cell.image.image = UIImage(named: name)
        }
        cell.image.contentMode = .scaleAspectFill //.scaleAspectFit //.scaleToFill
        cell.id = name
        cell.deleteOverlay.imageView?.contentMode = .scaleAspectFit
        if deleteView {
             cell.deleteOverlay.isHidden = false
        }
        else {
            cell.deleteOverlay.isHidden = true
        }
  
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath){
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
    }

    @IBAction func deleteButtonClicked(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? ImageCell else {
            print("couldnt get imageCell")
            return
        }
        Utility.removeImage(imageName: cell.id) // may not want??
        Closet.shared.removeClothingItem(name: cell.id)
        setUpCollectionViews()
    }
    
    @objc func deleteImage(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            if let indexPath = self.topsCollection?.indexPathForItem(at: sender.location(in: self.topsCollection)) {
                let cell = self.topsCollection?.cellForItem(at: indexPath) as! ImageCell
                cell.image.shake()
                print("top - you can do something with the cell or index path here")
            } else if let indexPath = self.bottomsCollection?.indexPathForItem(at: sender.location(in: self.bottomsCollection)) {
                let cell = self.bottomsCollection?.cellForItem(at: indexPath) as! ImageCell
                cell.image.shake()
                print("bottom - you can do something with the cell or index path here")
            } else if let indexPath = self.shoesCollection?.indexPathForItem(at: sender.location(in: self.shoesCollection)) {
                let cell = self.shoesCollection?.cellForItem(at: indexPath) as! ImageCell
                cell.image.shake()
                print("shoes - you can do something with the cell or index path here")
            }
                //TODO dresses & jacket 
            else {
                self.becomeFirstResponder()
                sender.view?.shake()
                print("long press")
            }
        }
    }
}

//https://stackoverflow.com/questions/3703922/how-do-you-create-a-wiggle-animation-similar-to-iphone-deletion-animation
extension UIView {
    func shake() {
        let transformAnim  = CAKeyframeAnimation(keyPath:"transform")
        transformAnim.values  = [NSValue(caTransform3D: CATransform3DMakeRotation(0.04, 0.0, 0.0, 1.0)),NSValue(caTransform3D: CATransform3DMakeRotation(-0.04 , 0, 0, 1))]
        transformAnim.autoreverses = true
        transformAnim.duration  = 0.12
        transformAnim.repeatCount = Float.infinity
        self.layer.add(transformAnim, forKey: "shake")
    }
}



extension String
{
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat
    {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height);
        
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.width;
    }
}
