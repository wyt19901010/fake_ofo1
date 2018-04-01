//
//  ViewController.swift
//  fake_ofo
//
//  Created by YUTONG WU on 2018/3/30.
//  Copyright © 2018年 Big. All rights reserved.
//

import UIKit
import SWRevealViewController


class ViewController: UIViewController,MAMapViewDelegate,AMapSearchDelegate, AMapNaviWalkManagerDelegate {
  
  var mapView : MAMapView!
  var search : AMapSearchAPI!
  var pin : MyPinAnnotaion!
  var pinView : MAAnnotationView!
  var nearBysearch = true
  var walkManager : AMapNaviWalkManager!
  
  var start,end : CLLocationCoordinate2D!
  
  @IBOutlet weak var panelView: UIView!
  @IBAction func locoalButton(_ sender: UIButton) {
    searchBikeNearby()
  }
  
  
  
  //搜索周边的车
  func searchBikeNearby(){
    mapView.userTrackingMode = .follow
    mapView.zoomLevel = 16
    searchCustomLocation(mapView.userLocation.coordinate)
  }
  
  
  
  func searchCustomLocation(_ center: CLLocationCoordinate2D){
    let request = AMapPOIAroundSearchRequest()
    request.location = AMapGeoPoint.location(withLatitude: CGFloat(center.latitude), longitude: CGFloat(center.longitude))
    request.keywords = "餐馆|医院"
    request.radius = 1000
    request.requireExtension = true
    
    //mapView.userTrackingMode = .follow
    // mapView.zoomLevel = 16
    
    search.aMapPOIAroundSearch(request)
  }
  
  
  
  override func viewDidLoad() {
    panelView.backgroundColor = UIColor.clear
    super.viewDidLoad()
    search = AMapSearchAPI()
    search.delegate = self
    
    mapView = MAMapView(frame: view.frame)
    view.addSubview(mapView)
    view.bringSubview(toFront: panelView)
    
    mapView.delegate = self
    mapView.showsUserLocation = true
    
    mapView.userTrackingMode = .follow
    mapView.zoomLevel = 16
    mapView.showsCompass = true
    mapView.compassOrigin = CGPoint(x:10,y:100)
    
    walkManager = AMapNaviWalkManager()
    walkManager.delegate = self
    
    //    let blue_point = MAUserLocationRepresentation()
    //    blue_point.showsHeadingIndicator = true
    //    mapView.update(blue_point)
    //
    self.navigationItem.leftBarButtonItem?.title = "aaa"
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem?.image = #imageLiteral(resourceName: "window_bike_Normal").withRenderingMode(.alwaysOriginal)
    self.navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "window_success_Normal").withRenderingMode(.alwaysOriginal)
    self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "wifi_Normal"))
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    
    if let revealVC = revealViewController(){
      revealVC.rearViewRevealWidth = 380
      navigationItem.leftBarButtonItem?.target = revealVC
      navigationItem.leftBarButtonItem?.action = #selector(SWRevealViewController.revealToggle(_:))
      view.addGestureRecognizer(revealVC.panGestureRecognizer())
    }
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //MARK: -MapView Delegate
  
  //画线
  func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
    //如果overlay是MAPolyline类型
    if overlay is MAPolyline{
      
     // pin.isLockedToScreen = false
      
  //    mapView.visibleMapRect = overlay.boundingMapRect
      
      let renderer = MAPolylineRenderer(overlay: overlay)
      renderer?.lineWidth = 6.0
      renderer?.strokeColor = UIColor.yellow
      
      return renderer
    }
    return nil
  }
  
  
  /// 用户移动地图的交互
  ///
  /// - Parameters:
  ///   - mapView: mapView
  ///   - wasUserAction: 用户是否移动
  
  //MARK: --点击图钉后的特效
  /// 点击图标之后的动画
  ///
  /// - Parameters:
  ///   - mapView: mapView
  ///   - view: click
  func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
    print("click")
    
    start = pin.coordinate
    end = view.annotation.coordinate
    
    let startPoint = AMapNaviPoint.location(withLatitude: CGFloat(start.latitude), longitude: CGFloat(start.longitude))!
    let endPoint = AMapNaviPoint.location(withLatitude: CGFloat(end.latitude), longitude: CGFloat(end.longitude))!
    
    walkManager.calculateWalkRoute(withStart: [startPoint], end: [endPoint])
    
  }
  
  //  func mapView(_ mapView: MAMapView!, mapWillMoveByUser wasUserAction: Bool) {
  //    mapView.clearDisk()
  //  }
  //
  func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
    if wasUserAction {
      //mapView.removeAnnotations(mapView.annotations)
 
      pin.isLockedToScreen = true
      pinAnimation()
      searchCustomLocation(mapView.centerCoordinate)
    }
  }
  //MARK: - 图钉动画
  func pinAnimation(){
    //坠落效果，y轴加位移
    let endFrame = pinView.frame
    pinView.frame = endFrame.offsetBy(dx: 0, dy: 40)
    
    UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: [], animations: {
      self.pinView.frame = endFrame
    }, completion: nil)
    
    
  }
  
  /// 地图初始化之后
  ///
  /// - Parameter mapView: mapView
  func mapInitComplete(_ mapView: MAMapView!) {
    pin = MyPinAnnotaion()
    pin.coordinate = mapView.centerCoordinate
    pin.lockedScreenPoint = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
    pin.isLockedToScreen = true
    
    mapView.addAnnotation(pin)
    
    //显示所有图标导致地图缩放
    mapView.showAnnotations([pin], animated: true)
    
  }
  
  /// 自定义图钉视图
  ///
  /// - Parameters:
  ///   - mapView: mapView
  ///   - annotation: 标注
  /// - Returns: 图钉视图
  func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
    //用户自己的位置，不需要自定义
    //mapView.removeAnnotations(mapView.annotations)
    if annotation is MAUserLocation{
      return nil
    }
    
    // let a = AMapSearchObject.
    
    if annotation is MyPinAnnotaion{
      let reuseid = "anchor"
      var av = mapView.dequeueReusableAnnotationView(withIdentifier: reuseid) as? MAPinAnnotationView
      if av == nil{
        av = MAPinAnnotationView(annotation: annotation, reuseIdentifier: reuseid)
      }
      
      av?.image = #imageLiteral(resourceName: "坐标 copy_Normal")
      av?.canShowCallout = false
      av?.animatesDrop = true
      
      pinView = av
      return av
    }
    
    let reuserid = "myid"
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuserid )  as? MAPinAnnotationView //后半句 有可能是新建
    
    if annotationView == nil{
      annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: reuserid)
    }
    if annotation.subtitle == "" {
      annotationView?.image = #imageLiteral(resourceName: "停车点_Normal")
    } else {
      annotationView?.image = #imageLiteral(resourceName: "推荐停车点_Normal")
    }
    
    annotationView?.canShowCallout = true
    annotationView?.animatesDrop = true
    
    
    return annotationView
  }
  
  
  //MARK: - Map search Delegate
  
  //MARK: - Add annotation
  func mapView(_ mapView: MAMapView!, didAddAnnotationViews views: [Any]!) {
    //把参数的views强制转换成 MAAnnotationView
    let aViews = views as![MAAnnotationView]
    
    for aView in aViews{
      //保证图标不是用户中央图钉图标
      guard aView.annotation is MAPointAnnotation else{
        continue
      }
      
      //把原图变成宽长都是0的图
      aView.transform = CGAffineTransform(scaleX: 0, y: 0)
      //在0.5秒之内恢复成原状
      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: [], animations: {
        aView.transform = .identity
      }, completion: nil)
    }
  }
  
  
  
  //搜索周边完成后的处理
  func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
    guard response.count > 0 else{
      print( "zero")
      return
    }
    
    var annotations : [MAPointAnnotation] = []
    
    annotations = response.pois.map{
      let extractedExpr: MAPointAnnotation = MAPointAnnotation()
      let annotation = extractedExpr
      
      annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees($0.location.latitude), longitude: CLLocationDegrees($0.location.longitude))
      
      if $0.distance < 100{
        print($0.name)
        annotation.title = "aaa"
        annotation.subtitle = ""
      } else {
        annotation.title = "bbb"
        annotation.subtitle = "ccc"
      }
      
      return annotation
    }
   // let a = pin

   // mapView.removeAnnotations(mapView.annotations)

    
    mapView.addAnnotations(annotations)
    if nearBysearch{
      //    mapView.showAnnotations(annotations, animated: true)
    }
  }
  
  //MARK: - AMapNaviWalkManagerDelegate 导航代理
  func walkManager(onCalculateRouteSuccess walkManager: AMapNaviWalkManager) {
    NSLog("CalculateRouteSuccess")
    ///把高德德地图坐标转换成系统的地图坐标
    
    mapView.removeOverlays(mapView.overlays)
    
    var coordinates = walkManager.naviRoute!.routeCoordinates!.map {
      return CLLocationCoordinate2D(latitude: CLLocationDegrees($0.latitude), longitude: CLLocationDegrees($0.longitude))
    }
    
    let polyline = MAPolyline(coordinates: &coordinates, count: UInt(coordinates.count))
    mapView.add(polyline)
  }
  func walkManager(_ walkManager: AMapNaviWalkManager, onCalculateRouteFailure error: Error) {
    print("fail",error)
  }
  
}

