//
//  GameViewController.swift
//  HuLuWaGo
//
//  Created by book on 2019/12/12
//  Copyright © 2019 book rights reserved.
//


import UIKit
import SpriteKit
import GameplayKit
var 宽:CGFloat = 640  // 这个默认值其实没啥用，知识用来初始化而已， 这个 屏幕的宽和1高都在下面的函数中设定！
var 高:CGFloat = 320 // 这个默认值其实没啥用，知识用来初始化而已， 这个 屏幕的宽和1高都在下面的函数中设定！
class GameViewController:UIViewController{
    
    

    override func viewDidLoad() {
            super.viewDidLoad()
            
            if let view = self.view as! SKView? {
                /**
                                 下面这句话是通过sks文件才创建场景的，需要删除掉 SKScene内容。
                 */
                // Load the SKScene from 'GameScene.sks'
    //            if let scene = SKScene(fileNamed: "GameScene")
                
                //这里通过GameScene创建我们自己的场景类。
                /* debug 测试我们的屏幕属性*/
                print(view.bounds.size)
                print(view.bounds.size.width)
                print(view.bounds.size.height)
                //获取屏幕的长和宽
                宽 = view.bounds.size.width
                高 = view.bounds.size.height
                let scene = GameScene(size: view.bounds.size)
                
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view.presentScene(scene)
                
                
                view.ignoresSiblingOrder = true
                
                view.showsFPS = true
                view.showsNodeCount = true
            }
        }

        override var shouldAutorotate: Bool {
            return true
        }

        override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
            if UIDevice.current.userInterfaceIdiom == .phone {
                return .allButUpsideDown
            } else {
                return .all
            }
        }

        override var prefersStatusBarHidden: Bool {
            return true
        }
    }


