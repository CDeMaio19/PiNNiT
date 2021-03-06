//
//  HomeViewController.swift
//  PiNNiT
//
//  Created by Christopher DeMaio on 7/27/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
import MapKit
import CoreLocation
import BLTNBoard

private let reuseIdentifier = "DropDownCell"
private let PinTags = ["House", "Resturant", "Park", "Point of Intrest"] //Add More

class HomeViewController: UIViewController, SlideMenuViewControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate {
    
    private lazy var boardManager: BLTNItemManager = {
        let item = BLTNPageItem(title: "Turn On Location Services!")
        item.image = UIImage(named: "Nav.png")
        item.descriptionText = "We need location services to provide you with the best user experience!"
        item.requiresCloseButton = false
        item.isDismissable = false
        
        return BLTNItemManager(rootItem: item)
    } ()
    
    @IBOutlet weak var MapView: MKMapView!
    @IBOutlet weak var TopMenu: UIStackView!
    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var NavButton: UIButton!
    @IBOutlet weak var PinButton: UIButton!
    @IBOutlet weak var PinConfirmView: UIStackView!
    @IBOutlet weak var TopPinConfirmConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var BottomNav: UIStackView!
    @IBOutlet weak var MyPinsButton: UIButton!
    @IBOutlet weak var FriendsPinButton: UIButton!
    @IBOutlet weak var WorldPinsButton: UIButton!
    @IBOutlet weak var CenterPin: UIImageView!
    
    
    @IBOutlet weak var HomeView: UIView!
    @IBOutlet weak var LeadingConstraintMenu: NSLayoutConstraint!
    @IBOutlet weak var BackViewMenu: UIView!
    @IBOutlet weak var MenuView: UIView!
    @IBOutlet weak var MenuButton: UIButton!
    var CurUsr = User()
    var MPB = 1
    var FPB = 0
    var WPB = 0
    let locationManager = CLLocationManager()
    var CenterPoint = CLLocationCoordinate2D()
    @IBOutlet weak var CheckButton: UIButton!
    
    //Pin Confirm
    @IBOutlet var BlurView: UIVisualEffectView!
    @IBOutlet var PinView: UIView!
    @IBOutlet weak var PinNameET: UITextField!
    @IBOutlet weak var PinAddressET: UITextField!
    @IBOutlet weak var TagButton: UIButton!
    @IBOutlet weak var PinErrorLabel: UILabel!
    var tableView = UITableView()
    @IBOutlet weak var PinTopView: UIStackView!
    var showMenu = false
    var PinTag = "Tag"
    var MyPins = [Pin()]
    var PinCount = 0
    @IBOutlet weak var ExitButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BlurView.bounds = self.view.bounds
        
        checkLocationAuthorization()
        checkLocationServices()
        
        MapView.delegate = self
        
        BottomMenuState()
        
        BackViewMenu.isHidden = true
        TopMenu.layer.cornerRadius = 30
        BottomNav.layer.cornerRadius = 25
        PinConfirmView.layer.cornerRadius = 10
        PinConfirmView.isHidden = true
        
        let db = Firestore.firestore()
        let UID = Help.getUID()
        
        db.collection("Users").document(UID).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                //print("Document data: \(dataDescription)")
                self.CurUsr.FirstName = document.get("First_Name") as? String ?? ""
                self.CurUsr.LastName = document.get("Last_Name") as? String ?? ""
                self.CurUsr.ID = document.get("ID") as? String ?? ""
                self.CurUsr.Email = document.get("Email") as? String ?? ""
                //self.Datafill()
            } else {
                print("Document does not exist")
            }
        }
        In(desiredView: BlurView)
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0){
            self.animateOut(desiredView: self.BlurView)
            self.GetDataFromFirebase()
            print("Pincount:" ,self.PinCount)
        }
        
        
        
        
        
        
    }
    
    var SlideMenuViewController:SlideMenuViewController?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "SlideMenuSegue")
        {
            if let controller = segue.destination as? SlideMenuViewController
            {
                self.SlideMenuViewController = controller
                self.SlideMenuViewController?.delegate = self
            }
        }
    }
    func HideMenuView() {
        self.HideMenu()
        
    }
    private func HideMenu() {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.LeadingConstraintMenu.constant = 10
            self.view.layoutIfNeeded()
        }) { (status) in
            UIView.animate(withDuration: 0.2, animations: {
                self.LeadingConstraintMenu.constant = -150
                self.view.layoutIfNeeded()
            }) {(status) in
                self.BackViewMenu.isHidden = true
            }
            self.HomeView.alpha = 1
        }
       
        
    }
    
    @IBAction func MenuButtonPushed(_ sender: Any) {
        
        self.BackViewMenu.isHidden = false
        self.HomeView.alpha = 0.5
        UIView.animate(withDuration: 0.2, animations: {
            self.LeadingConstraintMenu.constant = 10
            self.view.layoutIfNeeded()
        }) { (status) in
            UIView.animate(withDuration: 0.2, animations: {
                self.LeadingConstraintMenu.constant = 0
                self.view.layoutIfNeeded()
            }) {(status) in
                
                
            }
            
        }
       
        
    }
    @IBAction func DismissMenuByTap(_ sender: Any) {
        self.HideMenu()
    }
    
    //Bottom Menu Functions
    @IBAction func FreindsButtonViewPressed(_ sender: Any) {
        MPB = 0
        FPB = 1
        WPB = 0
        BottomMenuState()
    }
    @IBAction func MyButtonViewPressed(_ sender: Any) {
        MPB = 1
        FPB = 0
        WPB = 0
        BottomMenuState()
    }
    @IBAction func WorldButtonViewPressed(_ sender: Any) {
        MPB = 0
        FPB = 0
        WPB = 1
        BottomMenuState()
    }
    
    func BottomMenuState(){
        if (MPB == 1){
            MyPinsButton.backgroundColor = UIColor.init(red: 0/255, green: 49/255, blue: 54/255, alpha: 1)
            MyPinsButton.layer.cornerRadius = 25.0
        } else
        {
            MyPinsButton.backgroundColor = UIColor.clear
        }
        if (FPB == 1){
            FriendsPinButton.backgroundColor = UIColor.init(red: 0/255, green: 49/255, blue: 54/255, alpha: 1)
            FriendsPinButton.layer.cornerRadius = 25.0
        } else
        {
            FriendsPinButton.backgroundColor = UIColor.clear
        }
        if (WPB == 1){
            WorldPinsButton.backgroundColor = UIColor.init(red: 0/255, green: 49/255, blue: 54/255, alpha: 1)
            WorldPinsButton.layer.cornerRadius = 25.0
        } else
        {
            WorldPinsButton.backgroundColor = UIColor.clear
        }
    }
    
    //Map Functions
    func ShowConfirmButtons(){
        self.PinConfirmView.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.TopPinConfirmConstraint.constant = 71
            self.view.layoutIfNeeded()
        }) { (status) in
            UIView.animate(withDuration: 0.2, animations: {
                self.TopPinConfirmConstraint.constant = 61
                self.view.layoutIfNeeded()
            }) {(status) in
            }
        }
    }
    func HideConfirmButtons(){
        UIView.animate(withDuration: 0.2, animations: {
            self.TopPinConfirmConstraint.constant = 71
            self.view.layoutIfNeeded()
        }) { (status) in
            UIView.animate(withDuration: 0.2, animations: {
                self.TopPinConfirmConstraint.constant = 0
                self.view.layoutIfNeeded()
            }) {(status) in
                self.PinConfirmView.isHidden = true
            }
        }
    }
    @IBAction func NavButtonClicked(_ sender: Any) {
        mapIsReady()
        CenterPin.isHidden = true
        HideConfirmButtons()
    }
    @IBAction func PinButtonClicked(_ sender: Any) {
        if (CenterPin.isHidden == true)
        {
            CenterPin.isHidden = false
        } else {
            CenterPin.isHidden = true
        }
        if (PinConfirmView.isHidden == true)
        {
         ShowConfirmButtons()
        } else {
            HideConfirmButtons()
        }
    }
    func centerOnUserLocation(){
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
            MapView.setRegion(region, animated: true)
        }
    }
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapIsReady()
            if (boardManager.isShowingBulletin){
            boardManager.dismissBulletin()
            //GetDataFromFirebase()
            }
            break
        case .denied:
            boardManager.showBulletin(above: self)
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            boardManager.showBulletin(above: self)
            break
        case .authorizedAlways:
            mapIsReady()
            if (boardManager.isShowingBulletin){
            boardManager.dismissBulletin()
            //GetDataFromFirebase()
            }
            break
        default:
            boardManager.showBulletin(above: self)
        }
    }
    
    func mapIsReady(){
        MapView.showsUserLocation = true
        centerOnUserLocation()
        //locationManager.startUpdatingLocation()
    }
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Location Services Not On!!!
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        MapView.setRegion(region, animated: true)
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        var annotationView = MapView.dequeueReusableAnnotationView(withIdentifier: "CustomPin")
        
        if annotationView == nil{
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "CustomPin")
            annotationView?.canShowCallout = true
        }
        else{
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named: "Pin@3x.png")
        return annotationView
    }
    @IBAction func CheckButtonClicked(_ sender: Any) {
        CenterPoint = MapView.centerCoordinate
        HideConfirmButtons()
        CenterPin.isHidden = true
        animateIn(desiredView: BlurView)
        animateIn(desiredView: PinView)
        let centerCor = getCenterLocation(for: MapView)
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(centerCor) { [weak self] (placemarks, error) in
            guard let self = self else {return}
            
            if let _ = error {
                return
            }
            
            guard let placemark = placemarks?.first else {
                return
            }
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            let town = placemark.locality ?? ""
            
            self.PinAddressET.text = streetNumber+" "+streetName+", "+town
        }
        DeleteDataFirebase()
        
        
    }
    func AddPin(_ Cordinates:CLLocationCoordinate2D){
        let pin = MKPointAnnotation()
        pin.coordinate = Cordinates
        pin.title = PinNameET.text
        pin.subtitle = PinAddressET.text
        MapView.addAnnotation(pin)
        MyPins.append(Pin(name: PinNameET.text!, address: PinAddressET.text!, location: Cordinates, tag: PinTag, privacy: true, Id: CurUsr.ID))
        print("PinCount: ",PinCount)
        print(MyPins.count)
    }
    //Pin Screen
    @IBAction func PinCheckButtonIsClicked(_ sender: Any) {
        if (PinNameET.text != "" && PinAddressET.text != "  " && PinTag != "Tag")
        {
            AddPin(CenterPoint)
            PinCount=PinCount+1
            animateOut(desiredView: BlurView)
            animateOut(desiredView: PinView)
            PinErrorLabel.text = ""
            ExitButton.sendActions(for: .touchUpInside)
            // After loading DeleteDataFirebase()
        }
        else
        {
            PinErrorLabel.text = "Please Fill All Fields"
        }
        
    }
    @IBAction func PinExitButtonIsClicked(_ sender: Any) {
        animateOut(desiredView: BlurView)
        animateOut(desiredView: PinView)
        PinErrorLabel.text = ""
        PinNameET.text = ""
        PinTag = "Tag"
        TagButton.setTitle(PinTag, for: .normal)
        TagButton.setTitleColor(UIColor.init(red: 189/255, green: 249/255, blue: 254/255, alpha: 1), for: .normal)
        AddDataToFirebase()
    }
    func In(desiredView: UIView){
        let backroundView = self.view!
        backroundView.addSubview(desiredView)
        
        desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        desiredView.alpha = 0.9
        desiredView.center = backroundView.center
        desiredView.layer.cornerRadius = 50
        
    }
    func animateIn(desiredView: UIView){
        let backroundView = self.view!
        backroundView.addSubview(desiredView)
        
        desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        desiredView.alpha = 0
        desiredView.center = backroundView.center
        desiredView.layer.cornerRadius = 50
        
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1, y: 1)
            desiredView.alpha = 0.9
        })
        
    }
    func animateOut(desiredView: UIView){
        
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            desiredView.alpha = 0
        }, completion: {_ in
            desiredView.removeFromSuperview()
        })
        
    }
    @IBAction func TagButtonClicked(_ sender: Any) {
        SetUpTableView()
        handleDropDown()
    }
    
    //DropDown
    func SetUpTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 0
        tableView.isScrollEnabled = true
        tableView.backgroundColor = UIColor.init(red: 0/255, green: 158/255, blue: 171/255, alpha: 1)
        
        tableView.register(DropDownCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: TagButton.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: PinTopView.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: PinTopView.rightAnchor).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func handleDropDown(){
        showMenu = !showMenu
        var indexPaths = [IndexPath]()
        var i = 0
        PinTags.forEach { (Tag) in
            let indexPath = IndexPath(row: i, section: 0)
            indexPaths.append(indexPath)
            i=i+1
        }
        if showMenu {
            tableView.insertRows(at: indexPaths, with: .fade)
            animateinDropDown()
            
        } else{
            tableView.deleteRows(at: indexPaths, with: .fade)
            animateoutDropDown()
        }
    }
    
    func animateinDropDown(){
        self.tableView.isHidden = false
    }
    func animateoutDropDown(){
        self.tableView.isHidden = true
        TagButton.setTitle(PinTag, for: .normal)
        TagButton.setTitleColor(.white, for: .normal)
    }
    func getCenterLocation(for mapView: MKMapView) ->CLLocation {
        let lat = mapView.centerCoordinate.latitude
        let lon = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: lat, longitude: lon)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func AddDataToFirebase(){
        let db = Firestore.firestore()
        var Pins = 0
        var I = 0
        //DeleteDataFirebase()
        while Pins != PinCount
        {
            //Add Data
            I = Pins+1
            db.collection("Users").document(CurUsr.ID).collection("MyPins").document(I.description).setData(["Name":MyPins[I].Name, "Address":MyPins[I].Address, "Location":MyPins[I].Location, "Tag":MyPins[I].Tag, "Public":MyPins[I].Public, "Creator":CurUsr.ID] ) { error in
                
                if error != nil
                {
                    print("Error saving users Pins!!!")
                }
                
                
            }
            
            Pins=Pins+1
        }
    }
    
    //Bottom Menu
    @IBAction func OnMyPinsButton(_ sender: Any) {
        //dump(MyPins)
        //GetDataFromFirebase()
    }
    
    func DeleteDataFirebase(){
        let db = Firestore.firestore()
        let docref = db.collection("Users").document(CurUsr.ID).collection("MyPins")
            
            docref.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //print(document.documentID)
                    docref.document(document.documentID).delete()
                }
            }
        }
    }
    func GetDataFromFirebase(){
        let db = Firestore.firestore()
        let docref = db.collection("Users").document(CurUsr.ID).collection("MyPins")
            docref.getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let geopoint = document.get("Location") as! GeoPoint
                        let location = CLLocationCoordinate2D(latitude: geopoint.latitude, longitude: geopoint.longitude)
                        //print(location)
                        
                        self.MyPins.append(Pin(name: document.get("Name") as? String ?? "", address: document.get("Address") as? String ?? "", location: location, tag: document.get("Tag") as? String ?? "", privacy: document.get("Public") as? Bool ?? true, Id: document.get("Creator") as? String ?? ""))
                        self.PinCount = Int(document.documentID)!
                        
                        print("pulled data")
                        dump(self.MyPins)
                        print(self.MyPins.count)
                        print(self.PinCount)
                        let pin = MKPointAnnotation()
                        pin.coordinate = location
                        pin.title = document.get("Name") as? String ?? ""
                        pin.subtitle = document.get("Address") as? String ?? ""
                        self.MapView.addAnnotation(pin)
                    }
                }
            }
            PinCount = PinCount-1
        }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        AddDataToFirebase()
    }
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        AddDataToFirebase()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    


}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showMenu ? PinTags.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! DropDownCell
        cell.backgroundColor = UIColor.init(red: 0/255, green: 158/255, blue: 171/255, alpha: 1)
        cell.TitleLabel.text = PinTags[indexPath.row].description
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        PinTag = PinTags[indexPath.row].description
        TagButton.sendActions(for: .touchUpInside)
    }
    
    
    
}
