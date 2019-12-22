//
//  GameScene.swift
//  HuLuWaGo
//
//  Created by book on 2019/12/12
//  Copyright © 2019 book rights reserved.
//

//多边形攻击实际上就是用自己画线（调用库函数来瞄点划线，来实现对一个节点进行绘制物理体的边界）
//  多边形工具 - http://stackoverflow.com/questions/19040144

import SpriteKit
import GameplayKit
import AVFoundation

enum 图层: CGFloat {
    case 背景  //背景
    case 障碍物 //障碍物
    case 前景 //前景
    case 游戏角色 //游戏角色
    case UI // UI
}

enum 游戏状态{
    case 主菜单  //主菜单
    case 正在游戏 //正在进行游戏
    case 显示分数 //显示分数
    case 游戏结束 // 游戏结束
}

var 玩家最大HP值:Int = 200  //玩家最大HP值
var 玩家HP值:Int = 200   //玩家的HP值
      let 游戏角色类 :UInt32 = 0x1 << 0  //主角类最小，是有好处的，可以再发生碰撞的时候找出碰撞双方哪一个是我们的主角。
    let 地面类 :UInt32 = 0x1 << 1 //地面m类
   let 子弹类 :UInt32 = 0x1 << 2 //子弹类
 let 金币类 :UInt32 = 0x1 << 3 //金币类
   let 火焰类 :UInt32 = 0x1 << 4 //火焰类
  let 毒烟类 :UInt32 = 0x1 << 5 //毒烟类
 let 无: UInt32 = 0x1 << 6  //none 类
 let 妖怪类: UInt32 = 0x1 << 7  // 妖怪类
 let 地面:UInt32  = 0x1 << 8 //地面类
   
var 长方形最大宽度:CGFloat = 宽*0.4  //血条HP的长方形最大宽度
var 长方形宽度:CGFloat = 宽*0.4  //血条HP的长方形目前宽度
var 长方形:CGRect! // 血条HP的长方形
var 血条:SKShapeNode! //血条HP节点

//背景地图群
var 背景地图: [SKTexture] = [SKTexture(imageNamed: "map1_1"),SKTexture(imageNamed: "map1_2"),SKTexture(imageNamed: "map1_3"),SKTexture(imageNamed: "map1_4"),SKTexture(imageNamed: "map1_5"),SKTexture(imageNamed: "map1_6")]
//金币数组群
 let 金币数组 :[SKTexture] = [SKTexture(imageNamed: "gold_action1"),SKTexture(imageNamed: "gold_action2"),SKTexture(imageNamed: "gold_action3"),SKTexture(imageNamed: "gold_action4"),SKTexture(imageNamed: "gold_action5"),SKTexture(imageNamed: "gold_action6"),SKTexture(imageNamed: "gold_main")]
//火焰数组群
let 火焰数组 :[SKTexture] = [SKTexture(imageNamed: "fire1"),SKTexture(imageNamed: "fire2"),SKTexture(imageNamed: "fire3"),SKTexture(imageNamed: "fire4"),SKTexture(imageNamed: "fire5"),SKTexture(imageNamed: "fire6"),SKTexture(imageNamed: "fire7"),SKTexture(imageNamed: "fire8"),SKTexture(imageNamed: "fire9"),SKTexture(imageNamed: "fire10"),SKTexture(imageNamed: "fire11"),SKTexture(imageNamed: "fire12"),SKTexture(imageNamed: "fire13")]
//毒烟数组群
let 毒烟数组 :[SKTexture] = [SKTexture(imageNamed: "smoke1"),SKTexture(imageNamed: "smoke2"),SKTexture(imageNamed: "smoke3"),SKTexture(imageNamed: "smoke4"),SKTexture(imageNamed: "smoke5"),SKTexture(imageNamed: "smoke6")]

//妖怪1数组
let 妖怪一数组:[SKTexture] = [SKTexture(imageNamed: "monster1_1"),
SKTexture(imageNamed: "monster1_2"),SKTexture(imageNamed: "monster1_3"),
SKTexture(imageNamed: "monster1_4"),SKTexture(imageNamed: "monster1_5"),
SKTexture(imageNamed: "monster1_6"),SKTexture(imageNamed: "monster1_7")]
//妖怪二数组
let 妖怪二数组:[SKTexture] = [SKTexture(imageNamed: "monster2_1"),
SKTexture(imageNamed: "monster2_2"),SKTexture(imageNamed: "monster2_3"),
SKTexture(imageNamed: "monster2_4"),SKTexture(imageNamed: "monster2_5"),
SKTexture(imageNamed: "monster2_6")]

//妖怪三数组
let 妖怪三数组:[SKTexture] = [SKTexture(imageNamed: "monster3_1"),
SKTexture(imageNamed: "monster3_2"),SKTexture(imageNamed: "monster3_3"),
SKTexture(imageNamed: "monster3_4"),SKTexture(imageNamed: "monster3_5"),
SKTexture(imageNamed: "monster3_6"),SKTexture(imageNamed: "monster3_7")]

//妖怪四数组
let 妖怪四数组:[SKTexture] = [SKTexture(imageNamed: "monster4_1"),
SKTexture(imageNamed: "monster4_2"),SKTexture(imageNamed: "monster4_3"),
SKTexture(imageNamed: "monster4_4"),SKTexture(imageNamed: "monster4_5"),
SKTexture(imageNamed: "monster4_6"),SKTexture(imageNamed: "monster4_7")]



//这里添加一个枚举来表示不同的状态。 同时给GameScene添加一个z游戏状态的变量
var 毒烟移动速度:CGFloat = 1   //毒烟移动速度
var 金币移动速度:CGFloat = 2   //金币移动速度
var 火焰移动速度:CGFloat = 3   //火焰移动速度
var 妖怪一移动速度:CGFloat = 1   //妖怪一移动速度
var 妖怪二移动速度:CGFloat = 2   //妖怪二移动速度
var 妖怪三移动速度:CGFloat = 3   //妖怪三移动速度
var 妖怪四移动速度:CGFloat = 4   //妖怪四移动速度

var 添加金币间隔时间:Double = 2  //添加金币间隔时间
var 添加火焰间隔时间:Double = 3  //添加火焰间隔时间
var 添加毒烟间隔时间:Double = 9  //添加毒烟间隔时间
var 添加妖怪一间隔时间:Double = 9 //添加妖怪一间隔时间
var 添加妖怪二间隔时间:Double = 4 //添加妖怪二间隔时间
var 添加妖怪三间隔时间:Double = 5 //添加妖怪三间隔时间
var 添加妖怪四间隔时间:Double = 6  //添加妖怪四间隔时间

var 火焰伤害:Int = 20  //火焰伤害
var 毒烟伤害:Int = 5   //毒烟伤害
var 妖怪一伤害:Int = 10  //妖怪一伤害
var 妖怪二伤害:Int = 20  //妖怪二伤害
var 妖怪三伤害:Int = 30  //妖怪三伤害
var 妖怪四伤害:Int = 40   //妖怪四伤害


class GameScene: SKScene, SKPhysicsContactDelegate
{
   /**
     屏幕长 和 h高
     */
    var 主角纹理 :SKTexture!  //传递给SSKSpriteNode  主角纹理
    var 顶部纹理 :SKTexture!  //传递给SSKSpriteNode  顶部纹理
    var 中部纹理 :SKTexture!  //传递给SSKSpriteNode  中部纹理
    var 底部纹理 :SKTexture!  //传递给SSKSpriteNode  底部纹理
    var 备用纹理 :SKTexture!  //传递给SSKSpriteNode  备用纹理
    var 金币纹理 :SKTexture!  //传递给SSKSpriteNode  金币纹理
    var 毒烟纹理 :SKTexture!  //传递给SSKSpriteNode  毒烟纹理
    
    var 顶部图片 :SKSpriteNode!  //顶部图片
       var 中部图片 :SKSpriteNode!  //中部图片
       var 底部图片 :SKSpriteNode!  //底部图片
       var 备用图片 :SKSpriteNode! // 实践发现三张图片不够用啊！！ 会造成移动生成一个中间空缺！！必须用备用图片去填补！！！
       var 金币: SKSpriteNode!  //金币图片
       
       
       
       var 底部下标 : Int = 0;  // 用坐标来标定左中右的SpriteNode ，使他能够通过 下标来循环变化背景图片。
       var 中部下标 : Int = 1;  // 用坐标来标定左中右的SpriteNode ，使他能够通过 下标来循环变化背景图片。
       var 顶部下标 : Int = 2;  // 用坐标来标定左中右的SpriteNode ，使他能够通过 下标来循环变化背景图片。
       var 备用下标 : Int = 3  // 用坐标来标定左中右的SpriteNode ，使他能够通过 下标来循环变化背景图片。
    
    
    var 金币得分:Int = 0   //金币得分
    var 节点 :SKSpriteNode!  //节点
    var 开始游戏按钮:SKSpriteNode!  //开始游戏按钮
  
    

   

    

    let k字体名字 = "AmericanTypewriter-Bold"  //k字体名字
    var 得分标签:SKLabelNode!   //得分标签
    var HP标签:SKLabelNode!   //HP标签
    var HP标签1:SKLabelNode!  //HP标签1
    var HP值标签:SKLabelNode!  //HP值标签
    var 当前分数 = 0   //当前分数
    var 血条架子:SKShapeNode!  //血条架子
    lazy var sound = SoundManager()//播放音效的类的实例
    
    var 当前游戏状态: 游戏状态 = .主菜单 //一开始默认是在主菜单的
    
    
    let 世界单位 = SKNode()  //世界单位 世界上相当于 scene
    let 主角 = SKSpriteNode(imageNamed: "Bird5")  //主角节点
    var 上一次更新时间:TimeInterval = 0  //上一次更新时间
    var dt:TimeInterval = 0 //现在的时间
    
    override func didMove(to view: SKView) {  //dieMove 是系统函数，这个是在整个scene展示出来的时候被调用的一个系统函数
         
        //所以我们可以在这个函数里面调用布置主菜单的代码！
        
        //关掉重力
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        //设置碰撞代理
        physicsWorld.contactDelegate = self
        //将声音管理实例加入游戏场景中
        self.addChild(sound)
        //播放背景音乐
        sound.playBackGround()
        addChild(世界单位) // 添加 scene 场景的意思
        切换到主菜单()   //切换到主菜单接麦你
       
    }
    func 移动毒烟()  //移动毒烟节点
       {
           for 毒烟节点 in self.children where 毒烟节点.name == "毒烟" //对所有是"毒烟"名字的节点进行遍历，改变他们的坐标，实现移动
                          
                   {
                    //因为我们要用到火焰的size，但是SKNode没有size属性，所以我们要把它转成SKSpriteNode
                      if let 毒烟精灵 = 毒烟节点 as? SKSpriteNode
                      {
                       //气体移动速度不会太快
                          毒烟精灵.position = CGPoint(x: 毒烟精灵.position.x - 毒烟移动速度, y: 毒烟精灵.position.y)
                          //如果毒烟都移除了屏幕外面的话，我们就必须把它移除
                          if 毒烟精灵.position.x < -毒烟精灵.size.width
                          {
                             毒烟精灵.removeAllActions();
                              毒烟精灵.removeFromParent() //就干掉这个毒烟
                          }
                      }
                  }
       }
        func 重复添加毒烟() //重复添加毒烟节点
            {
             let 等待毒烟动作 = SKAction.wait(forDuration: 添加毒烟间隔时间, withRange: 1.0  )
              //创建一个等待的action,等待时间的平均值为3.5秒，变化范围为1秒
             //
             //        let 等待动作 = SKAction.wait(forDuration: 3.5, withRange: 1.0  )
             
             //        //创建一个产随机毒烟的action ， 这个 action 实际就是调用 一下 我们上面新添加的 那个
                     let 产生毒烟动作 = SKAction.run {
                         self.添加毒烟()
                     }
             //        //让场景开始重复循环执行"等待" -> "创建" -> "等待" -> "创建"。。。。。
             //
                            //并且给这个循环的动作设置了一个叫做"createPipe"的key来标识它
             run(SKAction.repeatForever(SKAction.sequence([等待毒烟动作,产生毒烟动作])),withKey: "添加毒烟")
             //    }
             
            }
        
        func 添加妖怪一() //添加妖怪一节点
        {
            let 妖怪一纹理 = SKTexture(imageNamed: "monster1_1") //获取纹理
            let 妖怪一 = SKSpriteNode(texture: 妖怪一纹理, size: CGSize(width: 宽 * 0.1, height: 高 * 0.2)) //产生妖怪节点
            妖怪一.name = "妖怪1" //给节点命名
            妖怪一.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -(宽 * 0.05), y: -(高 * 0.1), width: 宽 * 0.1, height: 高 * 0.2)) //设置物理题
            妖怪一.physicsBody?.categoryBitMask = 妖怪类 //对节点分类
            妖怪一.physicsBody?.collisionBitMask = 0; //碰撞之后不要发生相互弹开的效果
            妖怪一.physicsBody?.contactTestBitMask = 游戏角色类  //设置碰撞检测的类
            妖怪一.physicsBody?.isDynamic = true //是否受物理外力的影响
            妖怪一.zPosition = 图层.障碍物.rawValue  // 图层分层
            var 参数 = arc4random() % ( 9 - 1) + 1  //随机参数
           妖怪一.position = CGPoint(x: 宽 * 1.5, y: 高 * 0.1 * CGFloat(Int(arc4random() % 9) + 1) )//随机生成 坐标
           let 妖怪一自旋转 = SKAction.animate(with: 妖怪一数组, timePerFrame: 0.05) //妖怪动起来的动作
           妖怪一.run(SKAction.repeatForever(妖怪一自旋转), withKey: "妖怪一自旋转")//妖怪重复执行动作
           addChild(妖怪一)
        }
    
        func 移动妖怪一() //移动妖怪一
        {
            for 妖怪一节点 in self.children where 妖怪一节点.name == "妖怪1" //对所有妖怪节点进行遍历
            {
               if let 妖怪一精灵 = 妖怪一节点 as? SKSpriteNode
               {
                   妖怪一精灵.position = CGPoint(x: 妖怪一精灵.position.x - 妖怪一移动速度, y: 妖怪一精灵.position.y) //改变坐标从而实现移动
                   if 妖怪一精灵.position.x < -妖怪一精灵.size.width
                   {
                    妖怪一精灵.removeAllActions()
                    妖怪一精灵.removeFromParent() //就干掉这个妖怪
                   }
               }
           }
        }
        
    func 重复添加妖怪一() //重复添加妖怪一
    {
     let 等待妖怪一动作 = SKAction.wait(forDuration: 添加妖怪一间隔时间, withRange: 1.0  )
     let 产生妖怪一动作 = SKAction.run {
         self.添加妖怪一()
     }
        //执行重复添加的动作
     run(SKAction.repeatForever(SKAction.sequence([等待妖怪一动作,产生妖怪一动作])),withKey: "添加妖怪一")
    }
    
    func 添加妖怪二() //添加妖怪二
        {
            let 妖怪二纹理 = SKTexture(imageNamed: "monster1_1")
            let 妖怪二 = SKSpriteNode(texture: 妖怪二纹理, size: CGSize(width: 宽 * 0.1, height: 高 * 0.2))
            妖怪二.name = "妖怪2"
            妖怪二.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -(宽 * 0.05), y: -(高 * 0.1), width: 宽 * 0.1, height: 高 * 0.2))
            妖怪二.physicsBody?.categoryBitMask = 妖怪类
            妖怪二.physicsBody?.collisionBitMask = 0;
            妖怪二.physicsBody?.contactTestBitMask = 游戏角色类
            妖怪二.physicsBody?.isDynamic = true
            妖怪二.zPosition = 图层.障碍物.rawValue
            var 参数 = arc4random() % ( 9 - 1) + 1
           妖怪二.position = CGPoint(x: 宽 * 1.5, y: 高 * 0.1 * CGFloat(Int(arc4random() % 9) + 1) )
           let 妖怪二自旋转 = SKAction.animate(with: 妖怪二数组, timePerFrame: 0.05)
           妖怪二.run(SKAction.repeatForever(妖怪二自旋转), withKey: "妖怪二自旋转")
           addChild(妖怪二)
        }
    
        func 移动妖怪二() //移动妖怪二
        {
            for 妖怪二节点 in self.children where 妖怪二节点.name == "妖怪2"
            {
               if let 妖怪二精灵 = 妖怪二节点 as? SKSpriteNode
               {
                   妖怪二精灵.position = CGPoint(x: 妖怪二精灵.position.x - 妖怪二移动速度, y: 妖怪二精灵.position.y)
                   if 妖怪二精灵.position.x < -妖怪二精灵.size.width
                   {
                    妖怪二精灵.removeAllActions()
                    妖怪二精灵.removeFromParent() //就干掉这个妖怪
                   }
               }
           }
        }
        
    func 重复添加妖怪二() //重复添加妖怪二
    {
     let 等待妖怪二动作 = SKAction.wait(forDuration: 添加妖怪二间隔时间, withRange: 1.0  )
     let 产生妖怪二动作 = SKAction.run {
         self.添加妖怪二()
     }
     run(SKAction.repeatForever(SKAction.sequence([等待妖怪二动作,产生妖怪二动作])),withKey: "添加妖怪二")
    }
    func 添加妖怪三()  //添加妖怪三
          {
              let 妖怪三纹理 = SKTexture(imageNamed: "monster1_1")
              let 妖怪三 = SKSpriteNode(texture: 妖怪三纹理, size: CGSize(width: 宽 * 0.1, height: 高 * 0.2))
              妖怪三.name = "妖怪3"
              妖怪三.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -(宽 * 0.05), y: -(高 * 0.1), width: 宽 * 0.1, height: 高 * 0.2))
              妖怪三.physicsBody?.categoryBitMask = 妖怪类
              妖怪三.physicsBody?.collisionBitMask = 0;
              妖怪三.physicsBody?.contactTestBitMask = 游戏角色类
              妖怪三.physicsBody?.isDynamic = true
              妖怪三.zPosition = 图层.障碍物.rawValue
              var 参数 = arc4random() % ( 9 - 1) + 1
             妖怪三.position = CGPoint(x: 宽 * 1.5, y: 高 * 0.1 * CGFloat(Int(arc4random() % 9) + 1) )
             let 妖怪三自旋转 = SKAction.animate(with: 妖怪三数组, timePerFrame: 0.05)
             妖怪三.run(SKAction.repeatForever(妖怪三自旋转), withKey: "妖怪三自旋转")
             addChild(妖怪三)
          }
      
          func 移动妖怪三() //移动妖怪三
          {
              for 妖怪三节点 in self.children where 妖怪三节点.name == "妖怪3"
              {
                 if let 妖怪三精灵 = 妖怪三节点 as? SKSpriteNode
                 {
                     妖怪三精灵.position = CGPoint(x: 妖怪三精灵.position.x - 妖怪三移动速度, y: 妖怪三精灵.position.y)
                     if 妖怪三精灵.position.x < -妖怪三精灵.size.width
                     {
                      妖怪三精灵.removeAllActions()
                      妖怪三精灵.removeFromParent() //就干掉这个妖怪
                     }
                 }
             }
          }
          
      func 重复添加妖怪三() //重复添加妖怪三
      {
       let 等待妖怪三动作 = SKAction.wait(forDuration: 添加妖怪三间隔时间, withRange: 1.0  )
       let 产生妖怪三动作 = SKAction.run {
           self.添加妖怪三()
       }
       run(SKAction.repeatForever(SKAction.sequence([等待妖怪三动作,产生妖怪三动作])),withKey: "添加妖怪三")
      }
    func 添加妖怪四() //添加妖怪四
          {
              let 妖怪四纹理 = SKTexture(imageNamed: "monster1_1")
              let 妖怪四 = SKSpriteNode(texture: 妖怪四纹理, size: CGSize(width: 宽 * 0.1, height: 高 * 0.2))
              妖怪四.name = "妖怪4"
              妖怪四.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -(宽 * 0.05), y: -(高 * 0.1), width: 宽 * 0.1, height: 高 * 0.2))
              妖怪四.physicsBody?.categoryBitMask = 妖怪类
              妖怪四.physicsBody?.collisionBitMask = 0;
              妖怪四.physicsBody?.contactTestBitMask = 游戏角色类
              妖怪四.physicsBody?.isDynamic = true
              妖怪四.zPosition = 图层.障碍物.rawValue
              var 参数 = arc4random() % ( 9 - 1) + 1
             妖怪四.position = CGPoint(x: 宽 * 1.5, y: 高 * 0.1 * CGFloat(Int(arc4random() % 9) + 1) )
             let 妖怪四自旋转 = SKAction.animate(with: 妖怪四数组, timePerFrame: 0.05)
             妖怪四.run(SKAction.repeatForever(妖怪四自旋转), withKey: "妖怪四自旋转")
             addChild(妖怪四)
          }
      
          func 移动妖怪四() //移动妖怪四
          {
              for 妖怪四节点 in self.children where 妖怪四节点.name == "妖怪4"
              {
                 if let 妖怪四精灵 = 妖怪四节点 as? SKSpriteNode
                 {
                     妖怪四精灵.position = CGPoint(x: 妖怪四精灵.position.x - 妖怪四移动速度, y: 妖怪四精灵.position.y)
                     if 妖怪四精灵.position.x < -妖怪四精灵.size.width
                     {
                      妖怪四精灵.removeAllActions()
                      妖怪四精灵.removeFromParent() //就干掉这个妖怪
                     }
                 }
             }
          }
          
      func 重复添加妖怪四() //重复添加妖怪四
      {
       let 等待妖怪四动作 = SKAction.wait(forDuration: 添加妖怪四间隔时间, withRange: 1.0  )
       let 产生妖怪四动作 = SKAction.run {
           self.添加妖怪四()
       }
       run(SKAction.repeatForever(SKAction.sequence([等待妖怪四动作,产生妖怪四动作])),withKey: "添加妖怪四")
      }
    
    
        func 添加火焰() //添加火焰
        {
            let 火焰纹理 = SKTexture(imageNamed: "fire5")
            let 火焰 = SKSpriteNode(texture: 火焰纹理, size: CGSize(width: 火焰纹理.size().width, height: 火焰纹理.size().height))
            火焰.name = "火焰"
            
            火焰.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -(宽 * 0.05), y: -(高 * 0.1), width: 宽 * 0.1, height: 高 * 0.2))
            火焰.physicsBody?.categoryBitMask = 火焰类
            火焰.physicsBody?.collisionBitMask = 0;
            火焰.physicsBody?.contactTestBitMask = 游戏角色类
            火焰.physicsBody?.isDynamic = true
            火焰.zPosition = 图层.障碍物.rawValue
            
            
            var 参数 = arc4random() % ( 9 - 1) + 1
            火焰.position = CGPoint(x: 宽 * 1.5, y: 高 * 0.1 * CGFloat(Int(arc4random() % 9) + 1) )
            let 火焰自旋转 = SKAction.animate(with: 火焰数组, timePerFrame: 0.05)
            火焰.run(SKAction.repeatForever(火焰自旋转), withKey: "火焰自旋转")
            addChild(火焰)
        }
        
        func 移动火焰() //移动火焰
        {
            for 火焰节点 in self.children where 火焰节点.name == "火焰"
                           
                    {
                     //因为我们要用到火焰的size，但是SKNode没有size属性，所以我们要把它转成SKSpriteNode
                       if let 火焰精灵 = 火焰节点 as? SKSpriteNode
                       {
                           火焰精灵.position = CGPoint(x: 火焰精灵.position.x - 火焰移动速度, y: 火焰精灵.position.y)
                           //如果金币都移除了屏幕外面的话，我们就必须把它移除
                           if 火焰精灵.position.x < -火焰精灵.size.width
                           {
                            火焰精灵.removeAllActions()
                               火焰精灵.removeFromParent() //就干掉这个火焰
                           }
                       }
                   }
        }
        
        func 重复添加火焰() //重复移动火焰
          {
           let 等待火焰动作 = SKAction.wait(forDuration: 添加火焰间隔时间, withRange: 1.0  )
            //创建一个等待的action,等待时间的平均值为3.5秒，变化范围为1秒
           //
           //        let 等待动作 = SKAction.wait(forDuration: 3.5, withRange: 1.0  )
           
           //        //创建一个产随机毒烟的action ， 这个 action 实际就是调用 一下 我们上面新添加的 那个
                   let 产生火焰动作 = SKAction.run {
                       self.添加火焰()
                   }
           //        //让场景开始重复循环执行"等待" -> "创建" -> "等待" -> "创建"。。。。。
           //
                          //并且给这个循环的动作设置了一个叫做"createPipe"的key来标识它
           run(SKAction.repeatForever(SKAction.sequence([等待火焰动作,产生火焰动作])),withKey: "添加火焰")
           //    }
           
          }
        
       func 添加金币() //添加金币
        {
            
            let 金币纹理 = SKTexture(imageNamed: "gold_main")
            let 金币 = SKSpriteNode(texture: 金币纹理, size: CGSize(width: 宽 * 0.1, height: 高 * 0.2))
            金币.name = "金币"
            
//            金币.physicsBody = SKPhysicsBody(texture: 金币.texture!, size: 金币.size)
    //        金币.physicsBody?.isDynamic = false;
            金币.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -(宽 * 0.05), y: -(高 * 0.1), width: 宽 * 0.1, height: 高 * 0.2))
//            print(宽 * 0.1)
//            print(高 * 0.2)
            金币.physicsBody?.categoryBitMask = 金币类
            金币.physicsBody?.collisionBitMask = 0;
            金币.physicsBody?.contactTestBitMask = 游戏角色类
            金币.physicsBody?.isDynamic = true
            金币.zPosition = 图层.障碍物.rawValue
            // 获取某个 X ~ N 之间的随机数的公式: Y = arc4random() % (N - X) + X
    //        金币.zPosition=0;
            //不能这么创建PhysocBody， 这是错误的
    //        金币.physicsBody = SKPhysicsBody(texture: 金币纹理, size: 金币纹理.size())
            //正确的创建方式
            
    //        金币.physicsBody = SKPhysicsBody(texture: 金币纹理, size: CGSize(width: 金币纹理.size().width, height: 金币纹理.size().height))
    //          金币.physicsBody = SKPhysicsBody(texture: 金币.texture!, size: 金币.size)
    //
    //        金币.physicsBody?.categoryBitMask = 金币类
            var 参数 = arc4random() % ( 9 - 1) + 1
    //        var 高度:Float = (高 * 0.1 * (arc4random() % (9 - 1) + 1) )
    //        print(CGFloat(Int(arc4random() % 9) + 1))
            金币.position = CGPoint(x: 宽 * 1.4, y: 高 * 0.1 * CGFloat(Int(arc4random() % 9) + 1) )
            
              let 金币自旋转 = SKAction.animate(with: 金币数组, timePerFrame: 0.05)
            //        主角.run(SKAction.repeatForever(飞一下), withKey: "飞")
            金币.run(SKAction.repeatForever(金币自旋转), withKey: "金币自旋转")
            
            print("添加一个金币")
            addChild(金币)

        }
        
        func 移动金币() //移动金币
        {
             for 金币节点 in self.children where 金币节点.name == "金币"
                    
             {
              //因为我们要用到金币的size，但是SKNode没有size属性，所以我们要把它转成SKSpriteNode
                if let 金币精灵 = 金币节点 as? SKSpriteNode
                {
                    金币精灵.position = CGPoint(x: 金币精灵.position.x - 金币移动速度, y: 金币精灵.position.y)
                    //如果金币都移除了屏幕外面的话，我们就必须把它移除
                    if 金币精灵.position.x < -金币精灵.size.width
                    {
                        金币精灵.removeAllActions()
                        金币精灵.removeFromParent() //就干掉这个金币
                    }
                }
            }
           
        }
        
       
        
       func 重复添加金币() //重复添加金币
       {
        let 等待动作 = SKAction.wait(forDuration: 添加金币间隔时间, withRange: 1.0  )
         //创建一个等待的action,等待时间的平均值为3.5秒，变化范围为1秒
        //
        //        let 等待动作 = SKAction.wait(forDuration: 3.5, withRange: 1.0  )
        
        //        //创建一个产随机金币的action ， 这个 action 实际就是调用 一下 我们上面新添加的 那个
                let 产生金币动作 = SKAction.run {
                    self.添加金币()
                }
        //        //让场景开始重复循环执行"等待" -> "创建" -> "等待" -> "创建"。。。。。
        //
                       //并且给这个循环的动作设置了一个叫做"createPipe"的key来标识它
        run(SKAction.repeatForever(SKAction.sequence([等待动作,产生金币动作])),withKey: "添加金币")
        //    }
        
       }
    func 添加毒烟() //添加毒烟
       {
           let 毒烟纹理 = SKTexture(imageNamed: "smoke1")
         let 毒烟 = SKSpriteNode(texture: 毒烟纹理, size: CGSize(width: 毒烟纹理.size().width, height: 毒烟纹理.size().height))
         毒烟.name = "毒烟"
        毒烟.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: 毒烟.size.width, height: 毒烟.size.height))
        毒烟.physicsBody?.categoryBitMask = 毒烟类
        毒烟.physicsBody?.collisionBitMask = 0;
        毒烟.physicsBody?.contactTestBitMask = 游戏角色类
        毒烟.physicsBody?.isDynamic = true
        毒烟.zPosition = 图层.障碍物.rawValue
        
         var 参数 = arc4random() % ( 9 - 1) + 1
         毒烟.position = CGPoint(x: 宽 * 1.6, y: 高 * 0.1 * CGFloat(Int(arc4random() % 9) + 1) )
         let 毒烟自旋转 = SKAction.animate(with: 毒烟数组, timePerFrame: 0.05)
         毒烟.run(SKAction.repeatForever(毒烟自旋转), withKey: "毒烟自旋转")
         addChild(毒烟)
       }
    
    func 移动背景() //移动毒烟
      {
       底部图片.position = CGPoint(x: 底部图片.position.x - 1, y: 0) //背景开始不停滴向左移动
       中部图片.position = CGPoint(x: 中部图片.position.x - 1, y: 0)
       顶部图片.position = CGPoint(x: 顶部图片.position.x - 1, y: 0)
       备用图片.position = CGPoint(x: 备用图片.position.x - 1 , y: 0)
       //如果底部图片移动除了屏幕b外面：
       if 底部图片.position.x < -底部图片.size.width
       {
           底部图片.texture = 背景地图[(备用下标+1)%6] // 通过画图思考计算 ： 底部需要的是 备用的下一张图片
           底部下标 = (备用下标 + 1)%6
           底部图片.position = CGPoint(x: 宽, y: 0)
       }
       
       if 中部图片.position.x < -中部图片.size.width // 通过画图思考计算 ： 中部需要s的是 底部的下一张图片
       {
           中部图片.texture = 背景地图[(底部下标+1)%6]
           中部下标 = (底部下标 + 1) % 6
           中部图片.position = CGPoint(x: 宽, y: 0)
       }
       
       if 顶部图片.position.x < -顶部图片.size.width // 通过画图思考计算 ： 顶部需要s的是 中部的下一张图片
       {
           顶部图片.texture = 背景地图[(中部下标 + 1)%6]
           顶部下标 = (中部下标 + 1) % 6
           顶部图片.position = CGPoint(x: 宽, y: 0)
       }
       
       if 备用图片.position.x < -备用图片.size.width //通过画图思考计算 ：
       {
           备用图片.texture = 背景地图[(顶部下标 + 1)%6]
           备用下标 = (顶部下标 + 1)%6
           备用图片.position = CGPoint(x: 宽, y: 0)
       }
       
      }
    
    //MARK:设置的相关方法
    
    func 设置主菜单() //设置主菜单
    {
        
        //logo
        let logo1 = SKTexture(imageNamed: "Logo1")
        let logo = SKSpriteNode(texture: logo1, size: CGSize(width: 宽 * 0.3, height: 高 * 0.5))
//        let logo = SKSpriteNode(imageNamed: "Logo11")
        logo.position = CGPoint(x: 宽 * 0.55, y: 高 * 0.8)
        logo.name = "主菜单"
        logo.zPosition = 图层.UI.rawValue
        世界单位.addChild(logo)
        
           let logo22 = SKTexture(imageNamed: "Logo2")
        let logo2 = SKSpriteNode(texture: logo22, size: CGSize(width: 宽 * 0.3, height: 高 * 0.5))
//        let logo = SKSpriteNode(imageNamed: "Logo11")
        logo2.position = CGPoint(x: 宽 * 0.8, y: 高 * 0.5)
        logo2.name = "主菜单"
        logo2.zPosition = 图层.UI.rawValue
        世界单位.addChild(logo2)
        
        
        let logo33 = SKTexture(imageNamed: "Logo3")
        let logo3 = SKSpriteNode(texture: logo33, size: CGSize(width: 宽 * 0.3, height: 高 * 0.5))
//        let logo = SKSpriteNode(imageNamed: "Logo11")
        logo3.position = CGPoint(x: 宽 * 0.3, y: 高 * 0.5)
        logo3.name = "主菜单"
        logo3.zPosition = 图层.UI.rawValue
        世界单位.addChild(logo3)
        
        //开始游戏按钮
        
        let 开始游戏按钮纹理 = SKTexture(imageNamed: "startGame")
         开始游戏按钮 = SKSpriteNode(texture: 开始游戏按钮纹理, size: CGSize(width: 宽*0.2, height: 高*0.1))
        开始游戏按钮.position = CGPoint(x: 宽 * 0.55, y: 高 * 0.1)
        开始游戏按钮.zPosition = 1;
        开始游戏按钮.name = "主菜单"
        开始游戏按钮.zPosition = 图层.UI.rawValue
        世界单位.addChild(开始游戏按钮)
        

        
        //学习按钮的动画
        
        let 放大动画 = SKAction.scale(by: 1.1, duration: 0.75)
        放大动画.timingMode = .easeInEaseOut

        let 缩小动画 = SKAction.scale(by: 0.9, duration: 0.75)
        缩小动画.timingMode = .easeInEaseOut
//        //动画组
        logo.run(SKAction.repeatForever(SKAction.sequence([
            放大动画, 缩小动画
            ])))
        logo2.run(SKAction.repeatForever(SKAction.sequence([
        放大动画, 缩小动画
        ])))
        logo3.run(SKAction.repeatForever(SKAction.sequence([
               放大动画, 缩小动画
               ])))
        开始游戏按钮.run(SKAction.repeatForever(SKAction.sequence([
        放大动画, 缩小动画
        ])))
        
    }
    
        
    func 设置背景() //设置背景
    {
//        let 背景 = SKSpriteNode( imageNamed: "Background2")
//        背景.anchorPoint = CGPoint(x: 0.5, y: 1.0)
//        背景.position = CGPoint(x: size.width/2, y: size.height)
//        背景.zPosition = 图层.背景.rawValue
//        世界单位.addChild(背景)
            
        底部图片 = SKSpriteNode(texture:背景地图[底部下标], size: CGSize(width: 宽 * 1.0/3.0 + CGFloat(1), height: 高))//我们一块背景布由三块部分组成
        中部图片 = SKSpriteNode(texture: 背景地图[中部下标], size: CGSize(width: 宽 * 1.0/3.0 + CGFloat(1) , height: 高))
        顶部图片 = SKSpriteNode(texture: 背景地图[顶部下标], size: CGSize(width: 宽 * 1.0/3.0 + CGFloat(1), height: 高))
        
        底部图片.anchorPoint = CGPoint(x: 0, y: 0)//设置锚点
        //背景图片就不设置physicsBody了
        底部图片.position = CGPoint(x: 0, y: 0)//数学二维坐标
        中部图片.anchorPoint = CGPoint(x: 0, y: 0)//设置锚点
        中部图片.position = CGPoint(x: 底部图片.size.width, y: 0);
        顶部图片.anchorPoint = CGPoint(x: 0, y: 0)
        顶部图片.position = CGPoint(x: 底部图片.size.width + 中部图片.size.width, y: 0)//数学的二维坐标形式
        备用图片 = SKSpriteNode(texture: 背景地图[备用下标], size: CGSize(width: 宽 * 1.0/3.0, height: 高))
        备用图片.anchorPoint = CGPoint(x: 0, y: 0)
        备用图片.position = CGPoint(x: 底部图片.size.width + 中部图片.size.width + 顶部图片.size.width, y: 0 )//隐藏起来，备用!!
        
        /**
         图片精灵必须设置 zPosition，不然所有元素黏在一起，容易相互覆盖！！
            之前没有设置这个zPosition，导致图片相互重叠，背景覆盖了所有元素，导致所有金币 和主角都看不见！
         */
        底部图片.zPosition = 图层.背景.rawValue;
        中部图片.zPosition = 图层.背景.rawValue;
        顶部图片.zPosition = 图层.背景.rawValue;
        备用图片.zPosition = 图层.背景.rawValue;
        print("设置背景成功")
        /** 这个时候我们创立了三块背景地图  */
        //现在把三块图片add 到主屏幕上
        addChild(底部图片)
        addChild(中部图片)
        addChild(顶部图片)
        addChild(备用图片)
//
//        let 背景 = SKSpriteNode( imageNamed: "Background2")
//        背景.anchorPoint = CGPoint(x: 0.5, y: 1.0)
//        背景.position = CGPoint(x: size.width/2, y: size.height)
//        背景.zPosition = 图层.背景.rawValue
//        游戏区域起始点 = size.height - 背景.size.height
//        游戏区域高度 = 背景.size.height
        
//        let 左下 = CGPoint(x: 0, y: 游戏区域起始点)
//        let 右下 = CGPoint(x: size.width, y: 游戏区域起始点)
        
//        self.physicsBody = SKPhysicsBody(edgeFrom: 左下, to: 右下)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = 地面
        self.physicsBody?.contactTestBitMask = 游戏角色类
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
    }
    
    func 设置主角() //设置主角
    {
//        主角.position = CGPoint(x: size.width * 0.2, y: 游戏区域高度 * 0.4 + 游戏区域起始点)
        主角.position = CGPoint(x: 宽 * 0.1 , y: 高 * 0.5)
        主角.zPosition = 图层.游戏角色.rawValue
        
        //这个是 多边形 画物理体！！
        let offsetX = 主角.size.width * 主角.anchorPoint.x
        let offsetY = 主角.size.height * 主角.anchorPoint.y
        let path = CGMutablePath()
        
        
        path.move(to: CGPoint(x: 4 - offsetX, y: 17 - offsetY))
        path.addLine(to: CGPoint(x: 18 - offsetX, y: 26 - offsetY))
        path.addLine(to: CGPoint(x: 32 - offsetX, y: 29 - offsetY))
        path.addLine(to: CGPoint(x: 39 - offsetX, y: 25 - offsetY))
        path.addLine(to: CGPoint(x: 37 - offsetX, y: 9 - offsetY))
        path.addLine(to: CGPoint(x: 31 - offsetX, y: 4 - offsetY))
        path.addLine(to: CGPoint(x: 20 - offsetX, y: 1 - offsetY))
        path.addLine(to: CGPoint(x: 6 - offsetX, y: 1 - offsetY))
        path.addLine(to: CGPoint(x: 1 - offsetX, y: 7 - offsetY))
        
        path.closeSubpath()
        
        主角.physicsBody = SKPhysicsBody(polygonFrom: path)
        
        主角.physicsBody = SKPhysicsBody(polygonFrom: path)
        主角.physicsBody?.categoryBitMask = 游戏角色类
        主角.physicsBody?.collisionBitMask = 0
        主角.physicsBody?.contactTestBitMask = 金币类 | 火焰类 | 妖怪类 | 毒烟类
        
        世界单位.addChild(主角)
    }
    
    
  
    func 金币得分加一() //金币得分加一
    {
        金币得分 = 金币得分 + 1;
    }
    
    func 更新金币得分() //更新金币得分
    {
        得分标签.text = String(金币得分)
    }
    
    func 设置得分标签() //设置得分标签
    {
        得分标签 = SKLabelNode(fontNamed: k字体名字)
        // 设置字体颜色
        得分标签.fontColor = SKColor(red: 255.0/255.0, green: 246.0/255.0, blue: 84.0/255.0, alpha: 1.0)
        得分标签.position = CGPoint(x: 宽 * 0.12, y: 高 * 0.99 )
//        得分标签.position = CGPoint(x: size.width/2, y: size.height - k顶部留白)
        //设置为顶部对齐
        得分标签.verticalAlignmentMode = .top
        得分标签.text = String(金币得分)
        得分标签.zPosition = 图层.UI.rawValue
        世界单位.addChild(得分标签)
        
        let 金币纹理 = SKTexture(imageNamed: "gold_main")
                    let 金币 = SKSpriteNode(texture: 金币纹理, size: CGSize(width: 宽 * 0.05, height: 高 * 0.1))
                    金币.name = "金币标签"
                    金币.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: 金币.size.width, height: 金币.size.height))
                 
                    金币.zPosition = 图层.障碍物.rawValue
        金币.position = CGPoint(x: 宽 * 0.05, y: 高 * 0.95)
        let 金币自旋转 = SKAction.animate(with: 金币数组, timePerFrame: 0.05)
                    金币.run(SKAction.repeatForever(金币自旋转), withKey: "金币自旋转")
                    
//                    print("添加一个金币")
                    addChild(金币)
        
        长方形 = CGRect(x: 0, y: 0, width: 长方形宽度, height: 高 * 0.1)
        
        血条 = SKShapeNode(rect: 长方形, cornerRadius: 5)
        血条.position.x = 宽 * 0.55
        血条.position.y = 高 * 0.9
        血条.fillColor = .red
        血条.zPosition = 1;
        血条.glowWidth = 1.5
        血条.strokeColor = .blue
        血条.name = "HP"
        血条.lineWidth = 1.5
//        border.fill
        
//        血条架子 = SKShapeNode(rect: 长方形, cornerRadius: 5)
//        血条.position.x = 宽 * 0.55
//        血条.position.y = 高 * 0.9
//        血条.zPosition = 1;
//        血条.glowWidth = 1.5
//        血条.strokeColor = .blue
//        血条.name = "HP"
//        血条.lineWidth = 1.5
//        世界单位.addChild(血条架子)
        世界单位.addChild(血条)
        
//        HP标签 = SKLabelNode()
        HP标签 = SKLabelNode(fontNamed: k字体名字)
//         设置字体颜色
        HP标签.fontColor = SKColor(red: 255.0/255.0, green: 246.0/255.0, blue: 84.0/255.0, alpha: 1.0)
        HP标签.position = CGPoint(x: 宽 * 0.5, y: 高 * 0.99 )
//        得分标签.position = CGPoint(x: size.width/2, y: size.height - k顶部留白)
        //设置为顶部对齐
        HP标签.verticalAlignmentMode = .top
        HP标签.text = "HP"
        HP标签.zPosition = 图层.UI.rawValue
        世界单位.addChild(HP标签)
        
         HP标签1 = SKLabelNode(fontNamed: k字体名字)
        HP标签1.fontColor = SKColor(red: 255.0/255.0, green: 246.0/255.0, blue: 84.0/255.0, alpha: 1.0)
        HP标签1.position = CGPoint(x: 宽 * 0.3, y: 高 * 0.93 )
        HP标签1.text = "HP值："
        HP标签1.zPosition = 图层.UI.rawValue
        世界单位.addChild(HP标签1)
        
        HP值标签 = SKLabelNode(fontNamed: k字体名字)
        HP值标签.fontColor = SKColor(red: 243.0/255.0, green: 35.0/255.0, blue: 45.0/255.0, alpha: 1.0)
        HP值标签.position = CGPoint(x: 宽 * 0.4, y: 高 * 0.93 )
        HP值标签.text = String(玩家HP值)
        HP值标签.zPosition = 图层.UI.rawValue
        世界单位.addChild(HP值标签)

        
        
        
    }
    
    func 设置记分板() //设置记分板
    {
        if 金币得分 > 最高分()
        {
            设置最高分(最高分: 金币得分)
        }
        
        let 记分板 = SKSpriteNode(imageNamed: "ScoreCard")
        记分板.position = CGPoint(x: size.width/2, y: size.height/2)
        记分板.zPosition = 图层.UI.rawValue
        世界单位.addChild(记分板)
        
        let 当前分数标签 = SKLabelNode(fontNamed: k字体名字)
        当前分数标签.fontColor = SKColor(red: 255.0/255.0, green: 46.0/255.0, blue: 84.0/255.0, alpha: 1.0)
        当前分数标签.position = CGPoint(x: -记分板.size.width/4, y: -记分板.size.height/3)
        当前分数标签.text = "\(金币得分)"
        当前分数标签.zPosition = 图层.UI.rawValue
        记分板.addChild(当前分数标签)
        
        let 最高分标签 = SKLabelNode(fontNamed: k字体名字)
        最高分标签.fontColor = SKColor(red: 243.0/255.0, green: 35.0/255.0, blue: 45.0/255.0, alpha: 1.0)
        最高分标签.position = CGPoint(x: 记分板.size.width/4, y: -记分板.size.height/3)
        最高分标签.text = "\(最高分())"
        最高分标签.zPosition = 图层.UI.rawValue
        记分板.addChild(最高分标签)
        
//        let 游戏结束 = SKSpriteNode(imageNamed: "GameOver")
//        游戏结束.position = CGPoint(x: size.width/2, y: size.height/2 + 记分板.size.height/2 + k顶部留白 + 游戏结束.size.height/2)
//        游戏结束.zPosition = 图层.UI.rawValue
//        记分板.addChild(游戏结束)
        
//        let ok按钮 = SKSpriteNode(imageNamed: "Button")
//        ok按钮.position = CGPoint(x: size.width/4, y: size.height/2 - 记分板.size.height/2 - k顶部留白 - ok按钮.size.height/2)
//        ok按钮.zPosition = 图层.UI.rawValue
//        世界单位.addChild(ok按钮)
        
//        let ok = SKSpriteNode(imageNamed: "OK")
//        ok.position = CGPoint.zero//按钮居中到位置
//        ok.zPosition = 图层.UI.rawValue
//        ok按钮.addChild(ok)
//
//        let 分享按钮 = SKSpriteNode(imageNamed: "ButtonRight")
//        分享按钮.position = CGPoint(x: size.width * 0.75, y: size.height/2 - 记分板.size.height/2 - k顶部留白 - ok按钮.size.height/2)
//        分享按钮.zPosition = 图层.UI.rawValue
//        世界单位.addChild(分享按钮)
//
//        let 分享 = SKSpriteNode(imageNamed: "Share")
//        分享.position = CGPoint.zero//按钮居中到位置
//        分享.zPosition = 图层.UI.rawValue
//        分享按钮.addChild(分享)

    }
    
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    
    //MARK:游戏流程
    //下面这个函数是库函数，每当我们手指触碰了屏幕，就会触发下面这个函数， 我们可以收集这个触碰点的坐标位置
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let 点击 = touches.first else
        {
            return
        }
        
        let 点击位置 = 点击.location(in: self)
        
        switch 当前游戏状态
        {
        case .主菜单:  //因为一开始是游戏状态，所以手机点击屏幕首先触发的就是这个
            //如果点按的地方是开始游戏按钮所在的区域
            
            //下面是debug过程，目的是为了找出按钮的坐标区域！！
            print("点击的坐标: \(点击位置.x) : \(点击位置.y)")
            print("按钮坐标 \(开始游戏按钮.position.x) : \(开始游戏按钮.position.y)")
            print("\(宽*0.2) \(高*0.1)")
            print("\(宽 * 0.55) \(高 * 0.1)")
//            开始游戏按钮 = SKSpriteNode(texture: 开始游戏按钮纹理, size: CGSize(width: 宽*0.2, height: 高*0.1))
//                开始游戏按钮.position = CGPoint(x: 宽 * 0.55, y: 高 * 0.1)
            if 点击位置.x > (开始游戏按钮.position.x - 0.5 * 开始游戏按钮.size.width) && 点击位置.x < (开始游戏按钮.position.x - 0.5 * 开始游戏按钮.size.width) + 开始游戏按钮.size.width
                && 点击位置.y > (开始游戏按钮.position.y - 0.5 * 开始游戏按钮.size.height) && 点击位置.y < (开始游戏按钮.position.y - 0.5 * 开始游戏按钮.size.height) + 开始游戏按钮.size.height
            {
                切换到游戏状态()
            }
            
            break
        case .正在游戏:
            
            break
        case .显示分数:
//            停止生成一切节点()
            开始新游戏()
//            切换到新游戏()
            break
        case .游戏结束:
            break
       
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
         print("进入touchMove方法内")
                //获取当前点击的坐标
                let touchs = touches as NSSet
                let touch : AnyObject = touchs.anyObject() as AnyObject
                let locationPoint = touch.location(in: self)
                self.主角.zRotation = 旋转节点(目的地: self.主角.position, 触控点: locationPoint)
        //        self.zombieNode.zRotation = zombieRotate(nodePoint: self.zombieNode.position, touchPoint: locationPoint)
                //将移动移动到当前的点
                移动节点(节点: 主角, 目的地: locationPoint)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
    }
    
    //MARK:更新
    //下面是每一帧画面就执行一次下面的函数
    override func update(_ 当前时间: TimeInterval)
    {
        

        if 上一次更新时间 > 0{
            dt = 当前时间 - 上一次更新时间
        }
        else
        {
            dt = 0
        }
        上一次更新时间 = 当前时间
        
        switch 当前游戏状态
        {
        case .主菜单:
            break
       
        case .正在游戏: //只有正在游戏状态这些节点才能被移动
            移动背景()
            移动金币()
            移动火焰()
            移动毒烟()
            移动妖怪一()
            移动妖怪二()
            移动妖怪三()
            移动妖怪四()
            
            游戏结束检查()
            break
       
        case .显示分数: //这个游戏状态不归update管
            break
        case .游戏结束: //这个游戏状态不归update管
            break
        }
        
        
    }
    
 
    func  游戏结束检查() //是否游戏结束检查
    {
        if 玩家HP值 == 0
        {
            当前游戏状态 = .显示分数
            主角.removeAllActions()
            removeAction(forKey: "添加金币") //停止添加金币的动作
            removeAction(forKey: "添加火焰") //停止添加火焰的动作
            removeAction(forKey: "添加毒烟") //停止添加毒烟的动作
            removeAction(forKey: "添加妖怪一") //停止添加妖怪的动作
            removeAction(forKey: "添加妖怪二")//停止添加妖怪的动作
            removeAction(forKey: "添加妖怪三")//停止添加妖怪的动作
            removeAction(forKey: "添加妖怪四")//停止添加妖怪的动作
            removeAction(forKey: "金币自旋转")
            removeAction(forKey: "火焰自旋转")
            removeAction(forKey: "毒烟自旋转")
            removeAction(forKey: "妖怪一自旋转")
            removeAction(forKey: "妖怪二自旋转")
            removeAction(forKey: "妖怪三自旋转")
            removeAction(forKey: "妖怪四自旋转")
            设置记分板()
        }
    }

    

    
    //MARK:游戏状态
       
   func 切换到主菜单() //切换到主菜单
   {
       当前游戏状态 = .主菜单  //当前正在主菜单中
       设置背景()
      
       设置主菜单()
   }

 
    
   
    
  
    
    func  切换到游戏状态() //切换到游戏状态，添加正式的游戏场景
    
    {
        
        当前游戏状态 = .正在游戏
        世界单位.enumerateChildNodes(withName: "主菜单", using: { 匹配单位, _ in
        匹配单位.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.05),
                                            SKAction.removeFromParent()
            ]))}) // 删除主菜单的所有节点
       
       设置主角()
       设置得分标签()
       重复添加金币()
       重复添加火焰()
       重复添加毒烟()
       重复添加妖怪一()
       重复添加妖怪二()
       重复添加妖怪三()
       重复添加妖怪四()
    
        
    }
    
    func 开始新游戏() //开始新游戏
    {
        sound.播放砰的音效()
        当前游戏状态 = .主菜单
        玩家HP值 = 玩家最大HP值
//        let 新的游戏场景 = GameScene.init(size: CGSize(width: 宽, height: 高))
        let 新的游戏场景 = GameScene.init(size: size)
        let 切换特效 = SKTransition.fade(with: SKColor.black, duration: 0.05)
        view?.presentScene(新的游戏场景, transition: 切换特效) //new 出 新的 游戏场景
    }
//    func 切换到跌落状态(){
//
//        当前游戏状态  = .跌落
//
//        run(SKAction.sequence([
//            sound.摔倒的音效,
//            SKAction.wait(forDuration: 0.1),
//            sound.下落的音效
//            ]))
//
//        主角.removeAllActions()
////        停止重生障碍()
//
//    }
    
    
    func 移动节点(节点: SKSpriteNode , 目的地:CGPoint) //移动节点函数
       {
           let 移动事件 =  SKAction.move(to: 目的地, duration: 1)
           节点.run(移动事件)
       }
       
       func 旋转节点(目的地: CGPoint, 触控点: CGPoint ) -> CGFloat //旋转节点函数
       {
           //获取到当前点击的点的坐标之后, 计算两者之间的距离
           let dx = 触控点.x - 目的地.x
           let dy = 触控点.y - 目的地.y
           
           if (dx > 0 && dy > 0) { //第一象限
                      return atan(dy/dx)
                  }else if (dx < 0 && dy > 0){//第二象限
                      return atan(dx/(-dy)) + CGFloat.pi * 0.5
                  }else if (dx < 0 && dy < 0){//第三象限
                      return atan(dy/dx) + CGFloat.pi
                  }else {//第四象限
                      return CGFloat.pi * 2 - atan((-dy)/dx)
                  }
       }
      
    
    func 切换到显示分数状态() //切换到显示分数状态
    {
        当前游戏状态 = .显示分数
        主角.removeAllActions()
//        停止重生障碍()
        设置记分板()
    }
    
    func 切换到新游戏() //切换到新游戏
    {
        sound.播放砰的音效()
        
        let 新的游戏场景 = GameScene.init(size: size)
        let 切换特效 = SKTransition.fade(with: SKColor.black, duration: 0.05)
        view?.presentScene(新的游戏场景, transition: 切换特效)
    }
    
    
    // mark: 分数(存储到本地)
    
    func 最高分() -> Int{ //获得最高分
        return UserDefaults.standard.integer(forKey: "最高分")
    }
    
    func 设置最高分(最高分: Int)
    {
        UserDefaults.standard.set(最高分, forKey: "最高分")
        UserDefaults.standard.synchronize()
    }
    
    
    //MARK: 物理引擎
    func 更新HP值() //更新HP值显示
    {
        if 玩家HP值 < 0 {
            玩家HP值 = 0
            HP值标签.text = "0"
        }
        else
        {
        HP值标签.text = String(玩家HP值)
        调节血条()
        }
    }
    
    func 调节血条() //调节血条
    {
        var 比例 = Double(玩家HP值) / Double(玩家最大HP值)
        血条.removeFromParent()
        长方形 = CGRect(x: 0, y: 0, width: 长方形最大宽度 * CGFloat(比例), height: 高 * 0.1)
        血条 = SKShapeNode(rect: 长方形, cornerRadius: 5)
        血条.position.x = 宽 * 0.55
        血条.position.y = 高 * 0.9
        血条.fillColor = .red
        血条.zPosition = 1;
        血条.glowWidth = 1.5
        血条.strokeColor = .blue
        血条.name = "HP"
        血条.lineWidth = 1.5
        世界单位.addChild(血条)
        
        
    }
    
    //这个函数是系统碰撞的检测函数，就是说一旦发生了两个物体的碰撞就会触发下面这个函数
    func didBegin(_ 碰撞双方: SKPhysicsContact)
    {
        print("进入碰撞检测")
        //如果是l两个相同类的对象碰撞，直接return
        if(碰撞双方.bodyA.categoryBitMask == 碰撞双方.bodyB.categoryBitMask)
         {
             return
         }
          var 物体A : SKPhysicsBody
          var 物体B : SKPhysicsBody
          if 碰撞双方.bodyA.categoryBitMask < 碰撞双方.bodyB.categoryBitMask
          {
              物体A = 碰撞双方.bodyA
              物体B = 碰撞双方.bodyB
          }
          else
          {
              物体A = 碰撞双方.bodyB
              物体B = 碰撞双方.bodyA
          }
         //由于我们开头的设置，碰撞大的，绝对是金币（就目前来说）
        //因为游戏角色类最小！！
        //        物体B.node?.removeAllActions()
        if(物体B.node?.name == "金币")
              {
                  sound.播放得分的音效()
                  金币得分加一()
                  更新金币得分()
                  碰到金币后的粒子效果()
              }
        else if(物体B.node?.name == "火焰")
        {
            print("碰到火焰")
            sound.播放碰撞的音效()

            碰到火焰后的粒子效果()
            玩家HP值  =  玩家HP值 - 火焰伤害;
            更新HP值()

        }
        else if (物体B.node?.name == "毒烟")
        {
             sound.播放碰撞的音效()

            print("碰到了毒烟")
            碰到毒烟后的粒子效果()
            玩家HP值  =  玩家HP值 - 毒烟伤害;
            更新HP值()
        }
        else if(物体B.node?.name == "妖怪1")
        {
            print("碰到了妖怪1")
             sound.播放碰撞的音效()

            碰到妖怪一后的粒子效果()
            玩家HP值  =  玩家HP值 - 妖怪一伤害;
            更新HP值()


        }
        else if(物体B.node?.name == "妖怪2")
       {
      sound.播放碰撞的音效()

           print("碰到了妖怪2")
        碰到妖怪二后的粒子效果()
        玩家HP值  =  玩家HP值 - 妖怪二伤害;
        更新HP值()


       }
        else if(物体B.node?.name == "妖怪3")
       {
         sound.播放碰撞的音效()

           print("碰到了妖怪3")
        碰到妖怪三后的粒子效果()
        玩家HP值  =  玩家HP值 - 妖怪三伤害;
        更新HP值()


       }
        else if(物体B.node?.name == "妖怪4")
       {
         sound.播放碰撞的音效()

            print("碰到了妖怪4")
            碰到妖怪四后的粒子效果()
            玩家HP值  =  玩家HP值 - 妖怪四伤害;
        更新HP值()


       }
        物体B.node?.removeFromParent(); // 装上了那么金币肯定要收起来啦
      
        
        
    }
    
    // MARK:其他
    /**
     下面是一些碰撞发生的粒子散射的效果，增加动画的观赏性质
     */
    func 碰到金币后的粒子效果()
    {
        let yPos:CGFloat = -主角.size.height
        let removeChildAction = SKAction.sequence([SKAction.wait(forDuration: 2.0), SKAction.removeFromParent()])
              let effect1 = SKEmitterNode(fileNamed: "Gold1.sks")
                    effect1?.position.y = yPos
                effect1?.position.x = 宽*0.5
                    effect1?.run(removeChildAction)
                    effect1?.zPosition = 1.0
                    addChild(effect1!)

                    let effect2 = SKEmitterNode(fileNamed: "Gold1.sks")
                    effect2?.position.y = yPos
                    effect2?.position.x = 宽*0.5
                    effect2?.run(removeChildAction)
                    effect2?.zPosition = 1.0
                    effect2?.emissionAngle = 0.698132 // Double.pi/180 * 40
                    effect2?.xAcceleration = -550
                    addChild(effect2!)
                    
                    let effect3 = SKEmitterNode(fileNamed: "Gold2.sks")
                    effect3?.position.y = yPos
                    effect3?.run(removeChildAction)
                    effect3?.zPosition = 0.0
                    addChild(effect3!)
                    
                    let effect4 = SKEmitterNode(fileNamed: "Gold3.sks")
                    effect4?.position.y = yPos
                    effect4?.position.x = 宽*0.3
                    effect4?.run(removeChildAction)
                    effect4?.zPosition = 1.0
                    addChild(effect4!)
                    
                    let effect5 = SKEmitterNode(fileNamed: "Gold3.sks")
                    effect5?.position.y = yPos
                    effect5?.position.x = 宽*0.3
                    effect5?.run(removeChildAction)
                    effect5?.zPosition = 1.0
                    effect5?.emissionAngle = CGFloat(Double.pi/180 * 80)
                    effect5?.xAcceleration = -400
                    addChild(effect5!)
                            
            let effect6 = SKEmitterNode(fileNamed: "Gold1.sks")
                effect6?.position.y = yPos
            effect6?.position.x = 宽*0.8
                effect6?.run(removeChildAction)
                effect6?.zPosition = 1.0
                addChild(effect6!)

                let effect7 = SKEmitterNode(fileNamed: "Gold1.sks")
                effect7?.position.y = yPos
                effect7?.position.x = 宽*0.8
                effect7?.run(removeChildAction)
                effect7?.zPosition = 1.0
                effect7?.emissionAngle = 0.698132 // Double.pi/180 * 40
                effect7?.xAcceleration = -550
                addChild(effect7!)
        
    }
    
    func 碰到毒烟后的粒子效果()
    {
        let yPos:CGFloat = -主角.size.height
        let removeChildAction = SKAction.sequence([SKAction.wait(forDuration: 2.0), SKAction.removeFromParent()])
              let effect1 = SKEmitterNode(fileNamed: "Smoke1.sks")
                    effect1?.position.y = yPos
                effect1?.position.x = 宽*0.5
                    effect1?.run(removeChildAction)
                    effect1?.zPosition = 1.0
                    addChild(effect1!)

                    let effect2 = SKEmitterNode(fileNamed: "Smoke1.sks")
                    effect2?.position.y = yPos
                    effect2?.position.x = 宽*0.5
                    effect2?.run(removeChildAction)
                    effect2?.zPosition = 1.0
                    effect2?.emissionAngle = 0.698132 // Double.pi/180 * 40
                    effect2?.xAcceleration = -550
                    addChild(effect2!)
                    
                    let effect3 = SKEmitterNode(fileNamed: "Smoke2.sks")
                    effect3?.position.y = yPos
                    effect3?.run(removeChildAction)
                    effect3?.zPosition = 0.0
                    addChild(effect3!)
                    
                    let effect4 = SKEmitterNode(fileNamed: "Smoke3.sks")
                    effect4?.position.y = yPos
                    effect4?.position.x = 宽*0.3
                    effect4?.run(removeChildAction)
                    effect4?.zPosition = 1.0
                    addChild(effect4!)
                    
                    let effect5 = SKEmitterNode(fileNamed: "Smoke3.sks")
                    effect5?.position.y = yPos
                    effect5?.position.x = 宽*0.3
                    effect5?.run(removeChildAction)
                    effect5?.zPosition = 1.0
                    effect5?.emissionAngle = CGFloat(Double.pi/180 * 80)
                    effect5?.xAcceleration = -400
                    addChild(effect5!)
        
        let effect6 = SKEmitterNode(fileNamed: "Smoke1.sks")
            effect6?.position.y = yPos
        effect6?.position.x = 宽*0.8
            effect6?.run(removeChildAction)
            effect6?.zPosition = 1.0
            addChild(effect6!)

            let effect7 = SKEmitterNode(fileNamed: "Smoke1.sks")
            effect7?.position.y = yPos
            effect7?.position.x = 宽*0.8
            effect7?.run(removeChildAction)
            effect7?.zPosition = 1.0
            effect7?.emissionAngle = 0.698132 // Double.pi/180 * 40
            effect7?.xAcceleration = -550
            addChild(effect7!)
                    
    }
    func 碰到火焰后的粒子效果()
    {
        let yPos:CGFloat = -主角.size.height
        let removeChildAction = SKAction.sequence([SKAction.wait(forDuration: 2.0), SKAction.removeFromParent()])
              let effect1 = SKEmitterNode(fileNamed: "Fire1.sks")
                    effect1?.position.y = yPos
                effect1?.position.x = 宽*0.5
                    effect1?.run(removeChildAction)
                    effect1?.zPosition = 1.0
                    addChild(effect1!)

                    let effect2 = SKEmitterNode(fileNamed: "Fire1.sks")
                    effect2?.position.y = yPos
                    effect2?.position.x = 宽*0.5
                    effect2?.run(removeChildAction)
                    effect2?.zPosition = 1.0
                    effect2?.emissionAngle = 0.698132 // Double.pi/180 * 40
                    effect2?.xAcceleration = -550
                    addChild(effect2!)
                    
                    let effect3 = SKEmitterNode(fileNamed: "Fire2.sks")
                    effect3?.position.y = yPos
                    effect3?.run(removeChildAction)
                    effect3?.zPosition = 0.0
                    addChild(effect3!)
                    
                    let effect4 = SKEmitterNode(fileNamed: "Fire3.sks")
                    effect4?.position.y = yPos
                    effect4?.position.x = 宽*0.3
                    effect4?.run(removeChildAction)
                    effect4?.zPosition = 1.0
                    addChild(effect4!)
                    
                    let effect5 = SKEmitterNode(fileNamed: "Fire3.sks")
                    effect5?.position.y = yPos
                    effect5?.position.x = 宽*0.3
                    effect5?.run(removeChildAction)
                    effect5?.zPosition = 1.0
                    effect5?.emissionAngle = CGFloat(Double.pi/180 * 80)
                    effect5?.xAcceleration = -400
                    addChild(effect5!)
                    let effect6 = SKEmitterNode(fileNamed: "Fire1.sks")
                        effect6?.position.y = yPos
                    effect6?.position.x = 宽*0.8
                        effect6?.run(removeChildAction)
                        effect6?.zPosition = 1.0
                        addChild(effect6!)

                        let effect7 = SKEmitterNode(fileNamed: "Fire1.sks")
                        effect7?.position.y = yPos
                        effect7?.position.x = 宽*0.8
                        effect7?.run(removeChildAction)
                        effect7?.zPosition = 1.0
                        effect7?.emissionAngle = 0.698132 // Double.pi/180 * 40
                        effect7?.xAcceleration = -550
                        addChild(effect7!)
    }
    
    func 碰到妖怪一后的粒子效果()
    {
        let yPos:CGFloat = -主角.size.height
        let removeChildAction = SKAction.sequence([SKAction.wait(forDuration: 2.0), SKAction.removeFromParent()])
              let effect1 = SKEmitterNode(fileNamed: "Monster1_1.sks")
                    effect1?.position.y = yPos
                effect1?.position.x = 宽*0.5
                    effect1?.run(removeChildAction)
                    effect1?.zPosition = 1.0
                    addChild(effect1!)

                    let effect2 = SKEmitterNode(fileNamed: "Monster1_1.sks")
                    effect2?.position.y = yPos
                    effect2?.position.x = 宽*0.5
                    effect2?.run(removeChildAction)
                    effect2?.zPosition = 1.0
                    effect2?.emissionAngle = 0.698132 // Double.pi/180 * 40
                    effect2?.xAcceleration = -550
                    addChild(effect2!)
                    
                    let effect3 = SKEmitterNode(fileNamed: "Monster1_2.sks")
                    effect3?.position.y = yPos
                    effect3?.run(removeChildAction)
                    effect3?.zPosition = 0.0
                    addChild(effect3!)
                    
                    let effect4 = SKEmitterNode(fileNamed: "Monster1_3.sks")
                    effect4?.position.y = yPos
                    effect4?.position.x = 宽*0.3
                    effect4?.run(removeChildAction)
                    effect4?.zPosition = 1.0
                    addChild(effect4!)
                    
                    let effect5 = SKEmitterNode(fileNamed: "Monster1_3.sks")
                    effect5?.position.y = yPos
                    effect5?.position.x = 宽*0.3
                    effect5?.run(removeChildAction)
                    effect5?.zPosition = 1.0
                    effect5?.emissionAngle = CGFloat(Double.pi/180 * 80)
                    effect5?.xAcceleration = -400
                    addChild(effect5!)
        let effect6 = SKEmitterNode(fileNamed: "Monster1_1.sks")
            effect6?.position.y = yPos
        effect6?.position.x = 宽*0.8
            effect6?.run(removeChildAction)
            effect6?.zPosition = 1.0
            addChild(effect6!)

            let effect7 = SKEmitterNode(fileNamed: "Monster1_1.sks")
            effect7?.position.y = yPos
            effect7?.position.x = 宽*0.8
            effect7?.run(removeChildAction)
            effect7?.zPosition = 1.0
            effect7?.emissionAngle = 0.698132 // Double.pi/180 * 40
            effect7?.xAcceleration = -550
            addChild(effect7!)
                    
    }
    func 碰到妖怪二后的粒子效果()
    {
        let yPos:CGFloat = -主角.size.height
        let removeChildAction = SKAction.sequence([SKAction.wait(forDuration: 2.0), SKAction.removeFromParent()])
              let effect1 = SKEmitterNode(fileNamed: "Monster2_1.sks")
                    effect1?.position.y = yPos
                effect1?.position.x = 宽*0.5
                    effect1?.run(removeChildAction)
                    effect1?.zPosition = 1.0
                    addChild(effect1!)

                    let effect2 = SKEmitterNode(fileNamed: "Monster2_1.sks")
                    effect2?.position.y = yPos
                    effect2?.position.x = 宽*0.5
                    effect2?.run(removeChildAction)
                    effect2?.zPosition = 1.0
                    effect2?.emissionAngle = 0.698132 // Double.pi/180 * 40
                    effect2?.xAcceleration = -550
                    addChild(effect2!)
                    
                    let effect3 = SKEmitterNode(fileNamed: "Monster2_2.sks")
                    effect3?.position.y = yPos
                    effect3?.run(removeChildAction)
                    effect3?.zPosition = 0.0
                    addChild(effect3!)
                    
                    let effect4 = SKEmitterNode(fileNamed: "Monster2_3.sks")
                    effect4?.position.y = yPos
                    effect4?.position.x = 宽*0.3
                    effect4?.run(removeChildAction)
                    effect4?.zPosition = 1.0
                    addChild(effect4!)
                    
                    let effect5 = SKEmitterNode(fileNamed: "Monster2_3.sks")
                    effect5?.position.y = yPos
                    effect5?.position.x = 宽*0.3
                    effect5?.run(removeChildAction)
                    effect5?.zPosition = 1.0
                    effect5?.emissionAngle = CGFloat(Double.pi/180 * 80)
                    effect5?.xAcceleration = -400
                    addChild(effect5!)
                    let effect6 = SKEmitterNode(fileNamed: "Monster2_1.sks")
                               effect6?.position.y = yPos
                           effect6?.position.x = 宽*0.8
                               effect6?.run(removeChildAction)
                               effect6?.zPosition = 1.0
                               addChild(effect6!)

                               let effect7 = SKEmitterNode(fileNamed: "Monster2_1.sks")
                               effect7?.position.y = yPos
                               effect7?.position.x = 宽*0.8
                               effect7?.run(removeChildAction)
                               effect7?.zPosition = 1.0
                               effect7?.emissionAngle = 0.698132 // Double.pi/180 * 40
                               effect7?.xAcceleration = -550
                               addChild(effect7!)
    }
    func 碰到妖怪三后的粒子效果()
    {
        let yPos:CGFloat = -主角.size.height
        let removeChildAction = SKAction.sequence([SKAction.wait(forDuration: 2.0), SKAction.removeFromParent()])
              let effect1 = SKEmitterNode(fileNamed: "Monster3_1.sks")
                    effect1?.position.y = yPos
                effect1?.position.x = 宽*0.5
                    effect1?.run(removeChildAction)
                    effect1?.zPosition = 1.0
                    addChild(effect1!)

                    let effect2 = SKEmitterNode(fileNamed: "Monster3_1.sks")
                    effect2?.position.y = yPos
                    effect2?.position.x = 宽*0.5
                    effect2?.run(removeChildAction)
                    effect2?.zPosition = 1.0
                    effect2?.emissionAngle = 0.698132 // Double.pi/180 * 40
                    effect2?.xAcceleration = -550
                    addChild(effect2!)
                    
                    let effect3 = SKEmitterNode(fileNamed: "Monster3_2.sks")
                    effect3?.position.y = yPos
                    effect3?.run(removeChildAction)
                    effect3?.zPosition = 0.0
                    addChild(effect3!)
                    
                    let effect4 = SKEmitterNode(fileNamed: "Monster3_3.sks")
                    effect4?.position.y = yPos
                    effect4?.position.x = 宽*0.3
                    effect4?.run(removeChildAction)
                    effect4?.zPosition = 1.0
                    addChild(effect4!)
                    
                    let effect5 = SKEmitterNode(fileNamed: "Monster3_3.sks")
                    effect5?.position.y = yPos
                    effect5?.position.x = 宽*0.3
                    effect5?.run(removeChildAction)
                    effect5?.zPosition = 1.0
                    effect5?.emissionAngle = CGFloat(Double.pi/180 * 80)
                    effect5?.xAcceleration = -400
                    addChild(effect5!)
                    let effect6 = SKEmitterNode(fileNamed: "Monster3_1.sks")
                               effect6?.position.y = yPos
                           effect6?.position.x = 宽*0.8
                               effect6?.run(removeChildAction)
                               effect6?.zPosition = 1.0
                               addChild(effect6!)

                               let effect7 = SKEmitterNode(fileNamed: "Monster3_1.sks")
                               effect7?.position.y = yPos
                               effect7?.position.x = 宽*0.8
                               effect7?.run(removeChildAction)
                               effect7?.zPosition = 1.0
                               effect7?.emissionAngle = 0.698132 // Double.pi/180 * 40
                               effect7?.xAcceleration = -550
                               addChild(effect7!)
    }
    func 碰到妖怪四后的粒子效果()
    {
        let yPos:CGFloat = -主角.size.height
        let removeChildAction = SKAction.sequence([SKAction.wait(forDuration: 2.0), SKAction.removeFromParent()])
              let effect1 = SKEmitterNode(fileNamed: "Monster4_1.sks")
                    effect1?.position.y = yPos
                effect1?.position.x = 宽*0.5
                    effect1?.run(removeChildAction)
                    effect1?.zPosition = 1.0
                    addChild(effect1!)

                    let effect2 = SKEmitterNode(fileNamed: "Monster4_1.sks")
                    effect2?.position.y = yPos
                    effect2?.position.x = 宽*0.5
                    effect2?.run(removeChildAction)
                    effect2?.zPosition = 1.0
                    effect2?.emissionAngle = 0.698132 // Double.pi/180 * 40
                    effect2?.xAcceleration = -550
                    addChild(effect2!)
                    
                    let effect3 = SKEmitterNode(fileNamed: "Monster4_2.sks")
                    effect3?.position.y = yPos
                    effect3?.run(removeChildAction)
                    effect3?.zPosition = 0.0
                    addChild(effect3!)
                    
                    let effect4 = SKEmitterNode(fileNamed: "Monster4_3.sks")
                    effect4?.position.y = yPos
                    effect4?.position.x = 宽*0.3
                    effect4?.run(removeChildAction)
                    effect4?.zPosition = 1.0
                    addChild(effect4!)
                    
                    let effect5 = SKEmitterNode(fileNamed: "Monster4_3.sks")
                    effect5?.position.y = yPos
                    effect5?.position.x = 宽*0.3
                    effect5?.run(removeChildAction)
                    effect5?.zPosition = 1.0
                    effect5?.emissionAngle = CGFloat(Double.pi/180 * 80)
                    effect5?.xAcceleration = -400
                    addChild(effect5!)
                let effect6 = SKEmitterNode(fileNamed: "Monster4_1.sks")
                   effect6?.position.y = yPos
               effect6?.position.x = 宽*0.8
                   effect6?.run(removeChildAction)
                   effect6?.zPosition = 1.0
                   addChild(effect6!)

                   let effect7 = SKEmitterNode(fileNamed: "Monster4_1.sks")
                   effect7?.position.y = yPos
                   effect7?.position.x = 宽*0.8
                   effect7?.run(removeChildAction)
                   effect7?.zPosition = 1.0
                   effect7?.emissionAngle = 0.698132 // Double.pi/180 * 40
                   effect7?.xAcceleration = -550
                   addChild(effect7!)
                    
    }
    
    func 停止生成一切节点() // 移除所有的节点 和 所有的节点的 动作
    {
        removeAction(forKey: "添加金币") //停止添加金币的动作
        removeAction(forKey: "添加火焰") //停止添加火焰的动作
        removeAction(forKey: "添加毒烟") //停止添加毒烟的动作
        removeAction(forKey: "添加妖怪一") //停止添加妖怪的动作
        removeAction(forKey: "添加妖怪二")//停止添加妖怪的动作
        removeAction(forKey: "添加妖怪三")//停止添加妖怪的动作
        removeAction(forKey: "添加妖怪四")//停止添加妖怪的动作
        
        世界单位.enumerateChildNodes(withName: "金币", using: {
            所有节点, _ in 所有节点.removeAllActions()
        }) // 停止金币节点的一切Action
        
        世界单位.enumerateChildNodes(withName: "毒烟", using: {
            所有节点, _ in 所有节点.removeAllActions()
        }) // 停止金币节点的一切Action
        
        世界单位.enumerateChildNodes(withName: "火焰", using: {
            所有节点, _ in 所有节点.removeAllActions()
        }) // 停止金币节点的一切Action
        
        世界单位.enumerateChildNodes(withName: "妖怪1", using: {
            所有节点, _ in 所有节点.removeAllActions()
        }) // 停止金币节点的一切Action
         世界单位.enumerateChildNodes(withName: "妖怪1", using: {
            所有节点, _ in 所有节点.removeAllActions()
        }) // 停止金币节点的一切Action
         世界单位.enumerateChildNodes(withName: "妖怪2", using: {
            所有节点, _ in 所有节点.removeAllActions()
        }) // 停止金币节点的一切Action
         世界单位.enumerateChildNodes(withName: "妖怪3", using: {
            所有节点, _ in 所有节点.removeAllActions()
        }) // 停止金币节点的一切Action
         世界单位.enumerateChildNodes(withName: "妖怪4", using: {
            所有节点, _ in 所有节点.removeAllActions()
        }) // 停止金币节点的一切Action



    
    }
}
