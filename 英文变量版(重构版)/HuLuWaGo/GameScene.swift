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

enum Picture: CGFloat {
    case background  //背景
    case barrier //障碍物
    case prospect //前景
    case role //游戏角色
    case UI // UI
}

enum GameState{
    case  menu  //主菜单
    case InTheGame //正在进行游戏
    case presentScore //显示分数
    case GameOver // 游戏结束
}

var RoleMaxHP:Int = 200  //玩家最大HP值
var RoleHP:Int = 200   //玩家的HP值
      let RoleClass :UInt32 = 0x1 << 0  //主角类最小，是有好处的，可以再发生碰撞的时候找出碰撞双方哪一个是我们的主角。
    let BackgroundClass :UInt32 = 0x1 << 1 //地面m类
   let BulletClass :UInt32 = 0x1 << 2 //子弹类
 let GoldClass :UInt32 = 0x1 << 3 //金币类
   let FireClass :UInt32 = 0x1 << 4 //火焰类
  let SmokeClass :UInt32 = 0x1 << 5 //毒烟类
 let NoneCLass: UInt32 = 0x1 << 6  //none 类
 let MonsterClass: UInt32 = 0x1 << 7  // 妖怪类
 let Background:UInt32  = 0x1 << 8 //地面类
   
var MaximumRectangleWidth:CGFloat = 宽*0.4  //血条HP的长方形最大宽度
var RectangularWidth:CGFloat = 宽*0.4  //血条HP的长方形目前宽度
var Rectangular:CGRect! // 血条HP的长方形
var ArticleBlood:SKShapeNode! //血条HP节点

//背景地图群
var BackgroundMap: [SKTexture] = [SKTexture(imageNamed: "map1_1"),SKTexture(imageNamed: "map1_2"),SKTexture(imageNamed: "map1_3"),SKTexture(imageNamed: "map1_4"),SKTexture(imageNamed: "map1_5"),SKTexture(imageNamed: "map1_6")]
//金币数组群
 let GoldMap :[SKTexture] = [SKTexture(imageNamed: "gold_action1"),SKTexture(imageNamed: "gold_action2"),SKTexture(imageNamed: "gold_action3"),SKTexture(imageNamed: "gold_action4"),SKTexture(imageNamed: "gold_action5"),SKTexture(imageNamed: "gold_action6"),SKTexture(imageNamed: "gold_main")]
//火焰数组群
let FireMap :[SKTexture] = [SKTexture(imageNamed: "fire1"),SKTexture(imageNamed: "fire2"),SKTexture(imageNamed: "fire3"),SKTexture(imageNamed: "fire4"),SKTexture(imageNamed: "fire5"),SKTexture(imageNamed: "fire6"),SKTexture(imageNamed: "fire7"),SKTexture(imageNamed: "fire8"),SKTexture(imageNamed: "fire9"),SKTexture(imageNamed: "fire10"),SKTexture(imageNamed: "fire11"),SKTexture(imageNamed: "fire12"),SKTexture(imageNamed: "fire13")]
//毒烟数组群
let SmokeMap :[SKTexture] = [SKTexture(imageNamed: "smoke1"),SKTexture(imageNamed: "smoke2"),SKTexture(imageNamed: "smoke3"),SKTexture(imageNamed: "smoke4"),SKTexture(imageNamed: "smoke5"),SKTexture(imageNamed: "smoke6")]

//妖怪1数组
let MonsterOneMap:[SKTexture] = [SKTexture(imageNamed: "monster1_1"),
SKTexture(imageNamed: "monster1_2"),SKTexture(imageNamed: "monster1_3"),
SKTexture(imageNamed: "monster1_4"),SKTexture(imageNamed: "monster1_5"),
SKTexture(imageNamed: "monster1_6"),SKTexture(imageNamed: "monster1_7")]
//妖怪二数组
let MonsterTwoMap:[SKTexture] = [SKTexture(imageNamed: "monster2_1"),
SKTexture(imageNamed: "monster2_2"),SKTexture(imageNamed: "monster2_3"),
SKTexture(imageNamed: "monster2_4"),SKTexture(imageNamed: "monster2_5"),
SKTexture(imageNamed: "monster2_6")]

//妖怪三数组
let MonsterThreeMap:[SKTexture] = [SKTexture(imageNamed: "monster3_1"),
SKTexture(imageNamed: "monster3_2"),SKTexture(imageNamed: "monster3_3"),
SKTexture(imageNamed: "monster3_4"),SKTexture(imageNamed: "monster3_5"),
SKTexture(imageNamed: "monster3_6"),SKTexture(imageNamed: "monster3_7")]

//妖怪四数组
let MonsterFourMap:[SKTexture] = [SKTexture(imageNamed: "monster4_1"),
SKTexture(imageNamed: "monster4_2"),SKTexture(imageNamed: "monster4_3"),
SKTexture(imageNamed: "monster4_4"),SKTexture(imageNamed: "monster4_5"),
SKTexture(imageNamed: "monster4_6"),SKTexture(imageNamed: "monster4_7")]



//这里添加一个枚举来表示不同的状态。 同时给GameScene添加一个z游戏状态的变量
var SpeedOfSmoke:CGFloat = 1   //毒烟移动速度
var SpeenOfGold:CGFloat = 2   //金币移动速度
var SpeedOfFire:CGFloat = 3   //火焰移动速度
var SpeedOfMonsterOne:CGFloat = 1   //妖怪一移动速度
var SpeedOfMonsterTwo:CGFloat = 2   //妖怪二移动速度
var SpeedOfMonsterThree:CGFloat = 3   //妖怪三移动速度
var SpeedOfMonsterFour:CGFloat = 4   //妖怪四移动速度

var TimeOfGold:Double = 2  //添加金币间隔时间
var TimeOfFire:Double = 3  //添加火焰间隔时间
var TimeOfSmoke:Double = 9  //添加毒烟间隔时间
var TimeOfMonsterOne:Double = 9 //添加妖怪一间隔时间
var TimeOfMonsterTwo:Double = 4 //添加妖怪二间隔时间
var TimeOfMonsterThree:Double = 5 //添加妖怪三间隔时间
var TimeOfMonsterFour:Double = 6  //添加妖怪四间隔时间

var DamageOfFire:Int = 20  //火焰伤害
var DamageOfSmoke:Int = 5   //毒烟伤害
var DamageOfMonsterOne:Int = 10  //妖怪一伤害
var DamageOfMonsterTwo:Int = 20  //妖怪二伤害
var DamageOfMonsterThree:Int = 30  //妖怪三伤害
var DamageOfMonsterFour:Int = 40   //妖怪四伤害


class GameScene: SKScene, SKPhysicsContactDelegate
{
   /**
     屏幕长 和 h高
     */
    var RoleTexture :SKTexture!  //传递给SSKSpriteNode  主角纹理
    var TopPictureTexture :SKTexture!  //传递给SSKSpriteNode  顶部纹理
    var MiddlePictureTexture :SKTexture!  //传递给SSKSpriteNode  中部纹理
    var BottomPictureTexture :SKTexture!  //传递给SSKSpriteNode  底部纹理
    var BeiYongTexture :SKTexture!  //传递给SSKSpriteNode  备用纹理
    var GoldTexture :SKTexture!  //传递给SSKSpriteNode  金币纹理
    var SmokeTexture :SKTexture!  //传递给SSKSpriteNode  毒烟纹理
    
    var TopPicture :SKSpriteNode!  //顶部图片
       var MiddlePicture :SKSpriteNode!  //中部图片
       var BottomPicture :SKSpriteNode!  //底部图片
       var BeiYongPicture :SKSpriteNode! // 实践发现三张图片不够用啊！！ 会造成移动生成一个中间空缺！！必须用备用图片去填补！！！
       var GoldPicture: SKSpriteNode!  //金币图片
       
       
       
       var BottomPictureIndex : Int = 0;  // 用坐标来标定左中右的SpriteNode ，使他能够通过 下标来循环变化背景图片。
       var MiddlePictureIndex : Int = 1;  // 用坐标来标定左中右的SpriteNode ，使他能够通过 下标来循环变化背景图片。
       var TopPictureIndex : Int = 2;  // 用坐标来标定左中右的SpriteNode ，使他能够通过 下标来循环变化背景图片。
       var BeiYongPictureIndex : Int = 3  // 用坐标来标定左中右的SpriteNode ，使他能够通过 下标来循环变化背景图片。
    
    
    var ScoreOfGOld:Int = 0   //金币得分
    var ANode :SKSpriteNode!  //节点
    var TheButtunOfStartGame:SKSpriteNode!  //开始游戏按钮
  
    

   

    

    let KFontName = "AmericanTypewriter-Bold"  //k字体名字
    var ScoreLabel:SKLabelNode!   //得分标签
    var HPLabel:SKLabelNode!   //HP标签
    var HPLabelOne:SKLabelNode!  //HP标签1
    var HPValueLabel:SKLabelNode!  //HP值标签
    var NowScore = 0   //当前分数
    var TheShelfOfHP:SKShapeNode!  //血条架子
    lazy var sound = SoundManager()//播放音效的类的实例
    
    var TheNowGameState: GameState = . menu //一开始默认是在主菜单的
    
    
    let WorldScene = SKNode()  //世界单位 世界上相当于 scene
    let RolePicture = SKSpriteNode(imageNamed: "Bird5")  //主角节点
    var LastUpdateTime:TimeInterval = 0  //上一次更新时间
    var NowTime:TimeInterval = 0 //现在的时间
    
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
        addChild(WorldScene) // 添加 scene 场景的意思
        TurnToMenu()   //切换到主菜单接麦你
       
    }
    func MoveSmoke()  //移动毒烟节点
       {
           for SmokeNode in self.children where SmokeNode.name == "毒烟" //对所有是"毒烟"名字的节点进行遍历，改变他们的坐标，实现移动
                          
                   {
                    //因为我们要用到火焰的size，但是SKNode没有size属性，所以我们要把它转成SKSpriteNode
                      if let SmokeNodePicture = SmokeNode as? SKSpriteNode
                      {
                       //气体移动速度不会太快
                          SmokeNodePicture.position = CGPoint(x: SmokeNodePicture.position.x - SpeedOfSmoke, y: SmokeNodePicture.position.y)
                          //如果毒烟都移除了屏幕外面的话，我们就必须把它移除
                          if SmokeNodePicture.position.x < -SmokeNodePicture.size.width
                          {
                             SmokeNodePicture.removeAllActions();
                              SmokeNodePicture.removeFromParent() //就干掉这个毒烟
                          }
                      }
                  }
       }
        func RepatAddSmokeNode() //重复添加毒烟节点
            {
             let WaitingSmokeAction = SKAction.wait(forDuration: TimeOfSmoke, withRange: 1.0  )
              //创建一个等待的action,等待时间的平均值为3.5秒，变化范围为1秒
             //
             //        let 等待动作 = SKAction.wait(forDuration: 3.5, withRange: 1.0  )
             
             //        //创建一个产随机毒烟的action ， 这个 action 实际就是调用 一下 我们上面新添加的 那个
                     let ProductSmokeAction = SKAction.run {
                         self.AddSmoke()
                     }
             //        //让场景开始重复循环执行"等待" -> "创建" -> "等待" -> "创建"。。。。。
             //
                            //并且给这个循环的动作设置了一个叫做"createPipe"的key来标识它
             run(SKAction.repeatForever(SKAction.sequence([WaitingSmokeAction,ProductSmokeAction])),withKey: "添加毒烟")
             //    }
             
            }
        
        func AddMonsterOne() //添加妖怪一节点
        {
            let MonsterOneTexture = SKTexture(imageNamed: "monster1_1") //获取纹理
            let MonsterOnePicture = SKSpriteNode(texture: MonsterOneTexture, size: CGSize(width: 宽 * 0.1, height: 高 * 0.2)) //产生妖怪节点
            MonsterOnePicture.name = "妖怪1" //给节点命名
            MonsterOnePicture.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -(宽 * 0.05), y: -(高 * 0.1), width: 宽 * 0.1, height: 高 * 0.2)) //设置物理题
            MonsterOnePicture.physicsBody?.categoryBitMask = MonsterClass //对节点分类
            MonsterOnePicture.physicsBody?.collisionBitMask = 0; //碰撞之后不要发生相互弹开的效果
            MonsterOnePicture.physicsBody?.contactTestBitMask = RoleClass  //设置碰撞检测的类
            MonsterOnePicture.physicsBody?.isDynamic = true //是否受物理外力的影响
            MonsterOnePicture.zPosition = Picture.barrier.rawValue  // 图层分层
            var 参数 = arc4random() % ( 9 - 1) + 1  //随机参数
           MonsterOnePicture.position = CGPoint(x: 宽 * 1.5, y: 高 * 0.1 * CGFloat(Int(arc4random() % 9) + 1) )//随机生成 坐标
           let MonsterOneActionZi = SKAction.animate(with: MonsterOneMap, timePerFrame: 0.05) //妖怪动起来的动作
           MonsterOnePicture.run(SKAction.repeatForever(MonsterOneActionZi), withKey: "妖怪一自旋转")//妖怪重复执行动作
           addChild(MonsterOnePicture)
        }
    
        func MoveMonsterOne() //移动妖怪一
        {
            for MonsterOneNode in self.children where MonsterOneNode.name == "妖怪1" //对所有妖怪节点进行遍历
            {
               if let MonsterOneSprite = MonsterOneNode as? SKSpriteNode
               {
                   MonsterOneSprite.position = CGPoint(x: MonsterOneSprite.position.x - SpeedOfMonsterOne, y: MonsterOneSprite.position.y) //改变坐标从而实现移动
                   if MonsterOneSprite.position.x < -MonsterOneSprite.size.width
                   {
                    MonsterOneSprite.removeAllActions()
                    MonsterOneSprite.removeFromParent() //就干掉这个妖怪
                   }
               }
           }
        }
        
    func RepeateAddMonsterOne() //重复添加妖怪一
    {
     let 等待妖怪一动作 = SKAction.wait(forDuration: TimeOfMonsterOne, withRange: 1.0  )
     let 产生妖怪一动作 = SKAction.run {
         self.AddMonsterOne()
     }
        //执行重复添加的动作
     run(SKAction.repeatForever(SKAction.sequence([等待妖怪一动作,产生妖怪一动作])),withKey: "添加妖怪一")
    }
    
    func 添加妖怪二() //添加妖怪二
        {
            let MonsterTwoTexture = SKTexture(imageNamed: "monster1_1")
            let MonsterTwoPicture = SKSpriteNode(texture: MonsterTwoTexture, size: CGSize(width: 宽 * 0.1, height: 高 * 0.2))
            MonsterTwoPicture.name = "妖怪2"
            MonsterTwoPicture.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -(宽 * 0.05), y: -(高 * 0.1), width: 宽 * 0.1, height: 高 * 0.2))
            MonsterTwoPicture.physicsBody?.categoryBitMask = MonsterClass
            MonsterTwoPicture.physicsBody?.collisionBitMask = 0;
            MonsterTwoPicture.physicsBody?.contactTestBitMask = RoleClass
            MonsterTwoPicture.physicsBody?.isDynamic = true
            MonsterTwoPicture.zPosition = Picture.barrier.rawValue
            var 参数 = arc4random() % ( 9 - 1) + 1
           MonsterTwoPicture.position = CGPoint(x: 宽 * 1.5, y: 高 * 0.1 * CGFloat(Int(arc4random() % 9) + 1) )
           let MonsterTwoActionZi = SKAction.animate(with: MonsterTwoMap, timePerFrame: 0.05)
           MonsterTwoPicture.run(SKAction.repeatForever(MonsterTwoActionZi), withKey: "妖怪二自旋转")
           addChild(MonsterTwoPicture)
        }
    
        func MoveMonsterTwo() //移动妖怪二
        {
            for MonsterTwoNode in self.children where MonsterTwoNode.name == "妖怪2"
            {
               if let MonsterTwoSprite = MonsterTwoNode as? SKSpriteNode
               {
                   MonsterTwoSprite.position = CGPoint(x: MonsterTwoSprite.position.x - SpeedOfMonsterTwo, y: MonsterTwoSprite.position.y)
                   if MonsterTwoSprite.position.x < -MonsterTwoSprite.size.width
                   {
                    MonsterTwoSprite.removeAllActions()
                    MonsterTwoSprite.removeFromParent() //就干掉这个妖怪
                   }
               }
           }
        }
        
    func RepeateAddMonsterTwo() //重复添加妖怪二
    {
     let WaitAddMonsterTwoAction = SKAction.wait(forDuration: TimeOfMonsterTwo, withRange: 1.0  )
     let ProductMonsterAction = SKAction.run {
         self.添加妖怪二()
     }
     run(SKAction.repeatForever(SKAction.sequence([WaitAddMonsterTwoAction,ProductMonsterAction])),withKey: "添加妖怪二")
    }
    func AddMonsterThree()  //添加妖怪三
          {
              let MonsterThreeTexture = SKTexture(imageNamed: "monster1_1")
              let MonsterThreePicture = SKSpriteNode(texture: MonsterThreeTexture, size: CGSize(width: 宽 * 0.1, height: 高 * 0.2))
              MonsterThreePicture.name = "妖怪3"
              MonsterThreePicture.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -(宽 * 0.05), y: -(高 * 0.1), width: 宽 * 0.1, height: 高 * 0.2))
              MonsterThreePicture.physicsBody?.categoryBitMask = MonsterClass
              MonsterThreePicture.physicsBody?.collisionBitMask = 0;
              MonsterThreePicture.physicsBody?.contactTestBitMask = RoleClass
              MonsterThreePicture.physicsBody?.isDynamic = true
              MonsterThreePicture.zPosition = Picture.barrier.rawValue
              var 参数 = arc4random() % ( 9 - 1) + 1
             MonsterThreePicture.position = CGPoint(x: 宽 * 1.5, y: 高 * 0.1 * CGFloat(Int(arc4random() % 9) + 1) )
             let MonsterThreeActionZi = SKAction.animate(with: MonsterThreeMap, timePerFrame: 0.05)
             MonsterThreePicture.run(SKAction.repeatForever(MonsterThreeActionZi), withKey: "妖怪三自旋转")
             addChild(MonsterThreePicture)
          }
      
          func MoveMonsterThree() //移动妖怪三
          {
              for MonsterThreeNode in self.children where MonsterThreeNode.name == "妖怪3"
              {
                 if let MonsterThreeSprite = MonsterThreeNode as? SKSpriteNode
                 {
                     MonsterThreeSprite.position = CGPoint(x: MonsterThreeSprite.position.x - SpeedOfMonsterThree, y: MonsterThreeSprite.position.y)
                     if MonsterThreeSprite.position.x < -MonsterThreeSprite.size.width
                     {
                      MonsterThreeSprite.removeAllActions()
                      MonsterThreeSprite.removeFromParent() //就干掉这个妖怪
                     }
                 }
             }
          }
          
      func RepeateAddMonsterThree() //重复添加妖怪三
      {
       let WaitMonsterThreeAction = SKAction.wait(forDuration: TimeOfMonsterThree, withRange: 1.0  )
       let ProductMonsterThreeAction = SKAction.run {
           self.AddMonsterThree()
       }
       run(SKAction.repeatForever(SKAction.sequence([WaitMonsterThreeAction,ProductMonsterThreeAction])),withKey: "添加妖怪三")
      }
    func AddMOnsterFur() //添加妖怪四
          {
              let MonSterFourTextture = SKTexture(imageNamed: "monster1_1")
              let MonsterFourPicture = SKSpriteNode(texture: MonSterFourTextture, size: CGSize(width: 宽 * 0.1, height: 高 * 0.2))
              MonsterFourPicture.name = "妖怪4"
              MonsterFourPicture.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -(宽 * 0.05), y: -(高 * 0.1), width: 宽 * 0.1, height: 高 * 0.2))
              MonsterFourPicture.physicsBody?.categoryBitMask = MonsterClass
              MonsterFourPicture.physicsBody?.collisionBitMask = 0;
              MonsterFourPicture.physicsBody?.contactTestBitMask = RoleClass
              MonsterFourPicture.physicsBody?.isDynamic = true
              MonsterFourPicture.zPosition = Picture.barrier.rawValue
              var 参数 = arc4random() % ( 9 - 1) + 1
             MonsterFourPicture.position = CGPoint(x: 宽 * 1.5, y: 高 * 0.1 * CGFloat(Int(arc4random() % 9) + 1) )
             let MonsterFourActionZi = SKAction.animate(with: MonsterFourMap, timePerFrame: 0.05)
             MonsterFourPicture.run(SKAction.repeatForever(MonsterFourActionZi), withKey: "妖怪四自旋转")
             addChild(MonsterFourPicture)
          }
      
          func MoveMonsterFour() //移动妖怪四
          {
              for MonsterFOurNode in self.children where MonsterFOurNode.name == "妖怪4"
              {
                 if let MonsterFourSprite = MonsterFOurNode as? SKSpriteNode
                 {
                     MonsterFourSprite.position = CGPoint(x: MonsterFourSprite.position.x - SpeedOfMonsterFour, y: MonsterFourSprite.position.y)
                     if MonsterFourSprite.position.x < -MonsterFourSprite.size.width
                     {
                      MonsterFourSprite.removeAllActions()
                      MonsterFourSprite.removeFromParent() //就干掉这个妖怪
                     }
                 }
             }
          }
          
      func RepeatAddMonsterFOur() //重复添加妖怪四
      {
       let 等待妖怪四动作 = SKAction.wait(forDuration: TimeOfMonsterFour, withRange: 1.0  )
       let 产生妖怪四动作 = SKAction.run {
           self.AddMOnsterFur()
       }
       run(SKAction.repeatForever(SKAction.sequence([等待妖怪四动作,产生妖怪四动作])),withKey: "添加妖怪四")
      }
    
    
        func AddFire() //添加火焰
        {
            let FireTexture = SKTexture(imageNamed: "fire5")
            let FirePicture = SKSpriteNode(texture: FireTexture, size: CGSize(width: FireTexture.size().width, height: FireTexture.size().height))
            FirePicture.name = "火焰"
            
            FirePicture.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -(宽 * 0.05), y: -(高 * 0.1), width: 宽 * 0.1, height: 高 * 0.2))
            FirePicture.physicsBody?.categoryBitMask = FireClass
            FirePicture.physicsBody?.collisionBitMask = 0;
            FirePicture.physicsBody?.contactTestBitMask = RoleClass
            FirePicture.physicsBody?.isDynamic = true
            FirePicture.zPosition = Picture.barrier.rawValue
            
            
            var 参数 = arc4random() % ( 9 - 1) + 1
            FirePicture.position = CGPoint(x: 宽 * 1.5, y: 高 * 0.1 * CGFloat(Int(arc4random() % 9) + 1) )
            let FireActionZi = SKAction.animate(with: FireMap, timePerFrame: 0.05)
            FirePicture.run(SKAction.repeatForever(FireActionZi), withKey: "火焰自旋转")
            addChild(FirePicture)
        }
        
        func MoveFire() //移动火焰
        {
            for 火焰节点 in self.children where 火焰节点.name == "火焰"
                           
                    {
                     //因为我们要用到火焰的size，但是SKNode没有size属性，所以我们要把它转成SKSpriteNode
                       if let 火焰精灵 = 火焰节点 as? SKSpriteNode
                       {
                           火焰精灵.position = CGPoint(x: 火焰精灵.position.x - SpeedOfFire, y: 火焰精灵.position.y)
                           //如果金币都移除了屏幕外面的话，我们就必须把它移除
                           if 火焰精灵.position.x < -火焰精灵.size.width
                           {
                            火焰精灵.removeAllActions()
                               火焰精灵.removeFromParent() //就干掉这个火焰
                           }
                       }
                   }
        }
        
        func RepeatAddFire() //重复移动火焰
          {
           let WaitFireAction = SKAction.wait(forDuration: TimeOfFire, withRange: 1.0  )
            //创建一个等待的action,等待时间的平均值为3.5秒，变化范围为1秒
           //
           //        let 等待动作 = SKAction.wait(forDuration: 3.5, withRange: 1.0  )
           
           //        //创建一个产随机毒烟的action ， 这个 action 实际就是调用 一下 我们上面新添加的 那个
                   let ProductFireAction = SKAction.run {
                       self.AddFire()
                   }
           //        //让场景开始重复循环执行"等待" -> "创建" -> "等待" -> "创建"。。。。。
           //
                          //并且给这个循环的动作设置了一个叫做"createPipe"的key来标识它
           run(SKAction.repeatForever(SKAction.sequence([WaitFireAction,ProductFireAction])),withKey: "添加火焰")
           //    }
           
          }
        
       func AddGold() //添加金币
        {
            
            let GoldTexture = SKTexture(imageNamed: "gold_main")
            let GoldPicture = SKSpriteNode(texture: GoldTexture, size: CGSize(width: 宽 * 0.1, height: 高 * 0.2))
            GoldPicture.name = "金币"
            
//            金币.physicsBody = SKPhysicsBody(texture: 金币.texture!, size: 金币.size)
    //        金币.physicsBody?.isDynamic = false;
            GoldPicture.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -(宽 * 0.05), y: -(高 * 0.1), width: 宽 * 0.1, height: 高 * 0.2))
//            print(宽 * 0.1)
//            print(高 * 0.2)
            GoldPicture.physicsBody?.categoryBitMask = GoldClass
            GoldPicture.physicsBody?.collisionBitMask = 0;
            GoldPicture.physicsBody?.contactTestBitMask = RoleClass
            GoldPicture.physicsBody?.isDynamic = true
            GoldPicture.zPosition = Picture.barrier.rawValue
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
            GoldPicture.position = CGPoint(x: 宽 * 1.4, y: 高 * 0.1 * CGFloat(Int(arc4random() % 9) + 1) )
            
              let 金币自旋转 = SKAction.animate(with: GoldMap, timePerFrame: 0.05)
            //        主角.run(SKAction.repeatForever(飞一下), withKey: "飞")
            GoldPicture.run(SKAction.repeatForever(金币自旋转), withKey: "金币自旋转")
            
            print("添加一个金币")
            addChild(GoldPicture)

        }
        
        func MoveGOld() //移动金币
        {
             for 金币节点 in self.children where 金币节点.name == "金币"
                    
             {
              //因为我们要用到金币的size，但是SKNode没有size属性，所以我们要把它转成SKSpriteNode
                if let 金币精灵 = 金币节点 as? SKSpriteNode
                {
                    金币精灵.position = CGPoint(x: 金币精灵.position.x - SpeenOfGold, y: 金币精灵.position.y)
                    //如果金币都移除了屏幕外面的话，我们就必须把它移除
                    if 金币精灵.position.x < -金币精灵.size.width
                    {
                        金币精灵.removeAllActions()
                        金币精灵.removeFromParent() //就干掉这个金币
                    }
                }
            }
           
        }
        
       
        
       func RepeatAddGOld() //重复添加金币
       {
        let WaiteActionA = SKAction.wait(forDuration: TimeOfGold, withRange: 1.0  )
         //创建一个等待的action,等待时间的平均值为3.5秒，变化范围为1秒
        //
        //        let 等待动作 = SKAction.wait(forDuration: 3.5, withRange: 1.0  )
        
        //        //创建一个产随机金币的action ， 这个 action 实际就是调用 一下 我们上面新添加的 那个
                let ProductGoldAction = SKAction.run {
                    self.AddGold()
                }
        //        //让场景开始重复循环执行"等待" -> "创建" -> "等待" -> "创建"。。。。。
        //
                       //并且给这个循环的动作设置了一个叫做"createPipe"的key来标识它
        run(SKAction.repeatForever(SKAction.sequence([WaiteActionA,ProductGoldAction])),withKey: "添加金币")
        //    }
        
       }
    func AddSmoke() //添加毒烟
       {
           let SMokeTexture = SKTexture(imageNamed: "smoke1")
         let SmokePicture = SKSpriteNode(texture: SMokeTexture, size: CGSize(width: SMokeTexture.size().width, height: SMokeTexture.size().height))
         SmokePicture.name = "毒烟"
        SmokePicture.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: SmokePicture.size.width, height: SmokePicture.size.height))
        SmokePicture.physicsBody?.categoryBitMask = SmokeClass
        SmokePicture.physicsBody?.collisionBitMask = 0;
        SmokePicture.physicsBody?.contactTestBitMask = RoleClass
        SmokePicture.physicsBody?.isDynamic = true
        SmokePicture.zPosition = Picture.barrier.rawValue
        
         var 参数 = arc4random() % ( 9 - 1) + 1
         SmokePicture.position = CGPoint(x: 宽 * 1.6, y: 高 * 0.1 * CGFloat(Int(arc4random() % 9) + 1) )
         let SmokeActionZi = SKAction.animate(with: SmokeMap, timePerFrame: 0.05)
         SmokePicture.run(SKAction.repeatForever(SmokeActionZi), withKey: "毒烟自旋转")
         addChild(SmokePicture)
       }
    
      func MovePicture() //移动毒烟
      {
       BottomPicture.position = CGPoint(x: BottomPicture.position.x - 1, y: 0) //背景开始不停滴向左移动
       MiddlePicture.position = CGPoint(x: MiddlePicture.position.x - 1, y: 0)
       TopPicture.position = CGPoint(x: TopPicture.position.x - 1, y: 0)
       BeiYongPicture.position = CGPoint(x: BeiYongPicture.position.x - 1 , y: 0)
       //如果底部图片移动除了屏幕b外面：
       if BottomPicture.position.x < -BottomPicture.size.width
       {
           BottomPicture.texture = BackgroundMap[(BeiYongPictureIndex+1)%6] // 通过画图思考计算 ： 底部需要的是 备用的下一张图片
           BottomPictureIndex = (BeiYongPictureIndex + 1)%6
           BottomPicture.position = CGPoint(x: 宽, y: 0)
       }
       
       if MiddlePicture.position.x < -MiddlePicture.size.width // 通过画图思考计算 ： 中部需要s的是 底部的下一张图片
       {
           MiddlePicture.texture = BackgroundMap[(BottomPictureIndex+1)%6]
           MiddlePictureIndex = (BottomPictureIndex + 1) % 6
           MiddlePicture.position = CGPoint(x: 宽, y: 0)
       }
       
       if TopPicture.position.x < -TopPicture.size.width // 通过画图思考计算 ： 顶部需要s的是 中部的下一张图片
       {
           TopPicture.texture = BackgroundMap[(MiddlePictureIndex + 1)%6]
           TopPictureIndex = (MiddlePictureIndex + 1) % 6
           TopPicture.position = CGPoint(x: 宽, y: 0)
       }
       
       if BeiYongPicture.position.x < -BeiYongPicture.size.width //通过画图思考计算 ：
       {
           BeiYongPicture.texture = BackgroundMap[(TopPictureIndex + 1)%6]
           BeiYongPictureIndex = (TopPictureIndex + 1)%6
           BeiYongPicture.position = CGPoint(x: 宽, y: 0)
       }
       
      }
    
    //MARK:设置的相关方法
    
    func SetMenu() //设置主菜单
    {
        
        //logo
        let logo1 = SKTexture(imageNamed: "Logo1")
        let logo = SKSpriteNode(texture: logo1, size: CGSize(width: 宽 * 0.3, height: 高 * 0.5))
//        let logo = SKSpriteNode(imageNamed: "Logo11")
        logo.position = CGPoint(x: 宽 * 0.55, y: 高 * 0.8)
        logo.name = "主菜单"
        logo.zPosition = Picture.UI.rawValue
        WorldScene.addChild(logo)
        
           let logo22 = SKTexture(imageNamed: "Logo2")
        let logo2 = SKSpriteNode(texture: logo22, size: CGSize(width: 宽 * 0.3, height: 高 * 0.5))
//        let logo = SKSpriteNode(imageNamed: "Logo11")
        logo2.position = CGPoint(x: 宽 * 0.8, y: 高 * 0.5)
        logo2.name = "主菜单"
        logo2.zPosition = Picture.UI.rawValue
        WorldScene.addChild(logo2)
        
        
        let logo33 = SKTexture(imageNamed: "Logo3")
        let logo3 = SKSpriteNode(texture: logo33, size: CGSize(width: 宽 * 0.3, height: 高 * 0.5))
//        let logo = SKSpriteNode(imageNamed: "Logo11")
        logo3.position = CGPoint(x: 宽 * 0.3, y: 高 * 0.5)
        logo3.name = "主菜单"
        logo3.zPosition = Picture.UI.rawValue
        WorldScene.addChild(logo3)
        
        //开始游戏按钮
        
        let TheButtonOfStartGameTexture = SKTexture(imageNamed: "startGame")
         TheButtunOfStartGame = SKSpriteNode(texture: TheButtonOfStartGameTexture, size: CGSize(width: 宽*0.2, height: 高*0.1))
        TheButtunOfStartGame.position = CGPoint(x: 宽 * 0.55, y: 高 * 0.1)
        TheButtunOfStartGame.zPosition = 1;
        TheButtunOfStartGame.name = "主菜单"
        TheButtunOfStartGame.zPosition = Picture.UI.rawValue
        WorldScene.addChild(TheButtunOfStartGame)
        

        
        //学习按钮的动画
        
        let BiggerAction = SKAction.scale(by: 1.1, duration: 0.75)
        BiggerAction.timingMode = .easeInEaseOut

        let SmallerAction = SKAction.scale(by: 0.9, duration: 0.75)
        SmallerAction.timingMode = .easeInEaseOut
//        //动画组
        logo.run(SKAction.repeatForever(SKAction.sequence([
            BiggerAction, SmallerAction
            ])))
        logo2.run(SKAction.repeatForever(SKAction.sequence([
        BiggerAction, SmallerAction
        ])))
        logo3.run(SKAction.repeatForever(SKAction.sequence([
               BiggerAction, SmallerAction
               ])))
        TheButtunOfStartGame.run(SKAction.repeatForever(SKAction.sequence([
        BiggerAction, SmallerAction
        ])))
        
    }
    
        
    func SetBackground() //设置背景
    {
//        let 背景 = SKSpriteNode( imageNamed: "Background2")
//        背景.anchorPoint = CGPoint(x: 0.5, y: 1.0)
//        背景.position = CGPoint(x: size.width/2, y: size.height)
//        背景.zPosition = 图层.背景.rawValue
//        世界单位.addChild(背景)
            
        BottomPicture = SKSpriteNode(texture:BackgroundMap[BottomPictureIndex], size: CGSize(width: 宽 * 1.0/3.0 + CGFloat(1), height: 高))//我们一块背景布由三块部分组成
        MiddlePicture = SKSpriteNode(texture: BackgroundMap[MiddlePictureIndex], size: CGSize(width: 宽 * 1.0/3.0 + CGFloat(1) , height: 高))
        TopPicture = SKSpriteNode(texture: BackgroundMap[TopPictureIndex], size: CGSize(width: 宽 * 1.0/3.0 + CGFloat(1), height: 高))
        
        BottomPicture.anchorPoint = CGPoint(x: 0, y: 0)//设置锚点
        //背景图片就不设置physicsBody了
        BottomPicture.position = CGPoint(x: 0, y: 0)//数学二维坐标
        MiddlePicture.anchorPoint = CGPoint(x: 0, y: 0)//设置锚点
        MiddlePicture.position = CGPoint(x: BottomPicture.size.width, y: 0);
        TopPicture.anchorPoint = CGPoint(x: 0, y: 0)
        TopPicture.position = CGPoint(x: BottomPicture.size.width + MiddlePicture.size.width, y: 0)//数学的二维坐标形式
        BeiYongPicture = SKSpriteNode(texture: BackgroundMap[BeiYongPictureIndex], size: CGSize(width: 宽 * 1.0/3.0, height: 高))
        BeiYongPicture.anchorPoint = CGPoint(x: 0, y: 0)
        BeiYongPicture.position = CGPoint(x: BottomPicture.size.width + MiddlePicture.size.width + TopPicture.size.width, y: 0 )//隐藏起来，备用!!
        
        /**
         图片精灵必须设置 zPosition，不然所有元素黏在一起，容易相互覆盖！！
            之前没有设置这个zPosition，导致图片相互重叠，背景覆盖了所有元素，导致所有金币 和主角都看不见！
         */
        BottomPicture.zPosition = Picture.background.rawValue;
        MiddlePicture.zPosition = Picture.background.rawValue;
        TopPicture.zPosition = Picture.background.rawValue;
        BeiYongPicture.zPosition = Picture.background.rawValue;
        print("设置背景成功")
        /** 这个时候我们创立了三块背景地图  */
        //现在把三块图片add 到主屏幕上
        addChild(BottomPicture)
        addChild(MiddlePicture)
        addChild(TopPicture)
        addChild(BeiYongPicture)
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
        self.physicsBody?.categoryBitMask = Background
        self.physicsBody?.contactTestBitMask = RoleClass
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
    }
    
    func SetRole() //设置主角
    {
//        主角.position = CGPoint(x: size.width * 0.2, y: 游戏区域高度 * 0.4 + 游戏区域起始点)
        RolePicture.position = CGPoint(x: 宽 * 0.1 , y: 高 * 0.5)
        RolePicture.zPosition = Picture.role.rawValue
        
        //这个是 多边形 画物理体！！
        let offsetX = RolePicture.size.width * RolePicture.anchorPoint.x
        let offsetY = RolePicture.size.height * RolePicture.anchorPoint.y
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
        
        RolePicture.physicsBody = SKPhysicsBody(polygonFrom: path)
        
        RolePicture.physicsBody = SKPhysicsBody(polygonFrom: path)
        RolePicture.physicsBody?.categoryBitMask = RoleClass
        RolePicture.physicsBody?.collisionBitMask = 0
        RolePicture.physicsBody?.contactTestBitMask = GoldClass | FireClass | MonsterClass | SmokeClass
        
        WorldScene.addChild(RolePicture)
    }
    
    
  
    func TheScoreOfGoldPuls() //金币得分加一
    {
        ScoreOfGOld = ScoreOfGOld + 1;
    }
    
    func UpdateGOldScore() //更新金币得分
    {
        ScoreLabel.text = String(ScoreOfGOld)
    }
    
    func setScoreLabel() //设置得分标签
    {
        ScoreLabel = SKLabelNode(fontNamed: KFontName)
        // 设置字体颜色
        ScoreLabel.fontColor = SKColor(red: 255.0/255.0, green: 246.0/255.0, blue: 84.0/255.0, alpha: 1.0)
        ScoreLabel.position = CGPoint(x: 宽 * 0.12, y: 高 * 0.99 )
//        得分标签.position = CGPoint(x: size.width/2, y: size.height - k顶部留白)
        //设置为顶部对齐
        ScoreLabel.verticalAlignmentMode = .top
        ScoreLabel.text = String(ScoreOfGOld)
        ScoreLabel.zPosition = Picture.UI.rawValue
        WorldScene.addChild(ScoreLabel)
        
        let GoldTextureTMP = SKTexture(imageNamed: "gold_main")
                    let TMPGoldPicture = SKSpriteNode(texture: GoldTextureTMP, size: CGSize(width: 宽 * 0.05, height: 高 * 0.1))
                    TMPGoldPicture.name = "金币标签"
                    TMPGoldPicture.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: TMPGoldPicture.size.width, height: TMPGoldPicture.size.height))
                 
                    TMPGoldPicture.zPosition = Picture.barrier.rawValue
        TMPGoldPicture.position = CGPoint(x: 宽 * 0.05, y: 高 * 0.95)
        let 金币自旋转 = SKAction.animate(with: GoldMap, timePerFrame: 0.05)
                    TMPGoldPicture.run(SKAction.repeatForever(金币自旋转), withKey: "金币自旋转")
                    
//                    print("添加一个金币")
                    addChild(TMPGoldPicture)
        
        Rectangular = CGRect(x: 0, y: 0, width: RectangularWidth, height: 高 * 0.1)
        
        ArticleBlood = SKShapeNode(rect: Rectangular, cornerRadius: 5)
        ArticleBlood.position.x = 宽 * 0.55
        ArticleBlood.position.y = 高 * 0.9
        ArticleBlood.fillColor = .red
        ArticleBlood.zPosition = 1;
        ArticleBlood.glowWidth = 1.5
        ArticleBlood.strokeColor = .blue
        ArticleBlood.name = "HP"
        ArticleBlood.lineWidth = 1.5
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
        WorldScene.addChild(ArticleBlood)
        
//        HP标签 = SKLabelNode()
        HPLabel = SKLabelNode(fontNamed: KFontName)
//         设置字体颜色
        HPLabel.fontColor = SKColor(red: 255.0/255.0, green: 246.0/255.0, blue: 84.0/255.0, alpha: 1.0)
        HPLabel.position = CGPoint(x: 宽 * 0.5, y: 高 * 0.99 )
//        得分标签.position = CGPoint(x: size.width/2, y: size.height - k顶部留白)
        //设置为顶部对齐
        HPLabel.verticalAlignmentMode = .top
        HPLabel.text = "HP"
        HPLabel.zPosition = Picture.UI.rawValue
        WorldScene.addChild(HPLabel)
        
         HPLabelOne = SKLabelNode(fontNamed: KFontName)
        HPLabelOne.fontColor = SKColor(red: 255.0/255.0, green: 246.0/255.0, blue: 84.0/255.0, alpha: 1.0)
        HPLabelOne.position = CGPoint(x: 宽 * 0.3, y: 高 * 0.93 )
        HPLabelOne.text = "HP值："
        HPLabelOne.zPosition = Picture.UI.rawValue
        WorldScene.addChild(HPLabelOne)
        
        HPValueLabel = SKLabelNode(fontNamed: KFontName)
        HPValueLabel.fontColor = SKColor(red: 243.0/255.0, green: 35.0/255.0, blue: 45.0/255.0, alpha: 1.0)
        HPValueLabel.position = CGPoint(x: 宽 * 0.4, y: 高 * 0.93 )
        HPValueLabel.text = String(RoleHP)
        HPValueLabel.zPosition = Picture.UI.rawValue
        WorldScene.addChild(HPValueLabel)

        
        
        
    }
    
    func SetScoreBoard() //设置记分板
    {
        if ScoreOfGOld > 最高分()
        {
            SetHighestScore(HighestScore: ScoreOfGOld)
        }
        
        let ScoreBoard = SKSpriteNode(imageNamed: "ScoreCard")
        ScoreBoard.position = CGPoint(x: size.width/2, y: size.height/2)
        ScoreBoard.zPosition = Picture.UI.rawValue
        WorldScene.addChild(ScoreBoard)
        
        let NowScoreLabel = SKLabelNode(fontNamed: KFontName)
        NowScoreLabel.fontColor = SKColor(red: 255.0/255.0, green: 46.0/255.0, blue: 84.0/255.0, alpha: 1.0)
        NowScoreLabel.position = CGPoint(x: -ScoreBoard.size.width/4, y: -ScoreBoard.size.height/3)
        NowScoreLabel.text = "\(ScoreOfGOld)"
        NowScoreLabel.zPosition = Picture.UI.rawValue
        ScoreBoard.addChild(NowScoreLabel)
        
        let HishestScoreLabel = SKLabelNode(fontNamed: KFontName)
        HishestScoreLabel.fontColor = SKColor(red: 243.0/255.0, green: 35.0/255.0, blue: 45.0/255.0, alpha: 1.0)
        HishestScoreLabel.position = CGPoint(x: ScoreBoard.size.width/4, y: -ScoreBoard.size.height/3)
        HishestScoreLabel.text = "\(最高分())"
        HishestScoreLabel.zPosition = Picture.UI.rawValue
        ScoreBoard.addChild(HishestScoreLabel)
        
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
        guard let Click = touches.first else
        {
            return
        }
        
        let ClickPosition = Click.location(in: self)
        
        switch TheNowGameState
        {
        case . menu:  //因为一开始是游戏状态，所以手机点击屏幕首先触发的就是这个
            //如果点按的地方是开始游戏按钮所在的区域
            
            //下面是debug过程，目的是为了找出按钮的坐标区域！！
            print("点击的坐标: \(ClickPosition.x) : \(ClickPosition.y)")
            print("按钮坐标 \(TheButtunOfStartGame.position.x) : \(TheButtunOfStartGame.position.y)")
            print("\(宽*0.2) \(高*0.1)")
            print("\(宽 * 0.55) \(高 * 0.1)")
//            开始游戏按钮 = SKSpriteNode(texture: 开始游戏按钮纹理, size: CGSize(width: 宽*0.2, height: 高*0.1))
//                开始游戏按钮.position = CGPoint(x: 宽 * 0.55, y: 高 * 0.1)
            if ClickPosition.x > (TheButtunOfStartGame.position.x - 0.5 * TheButtunOfStartGame.size.width) && ClickPosition.x < (TheButtunOfStartGame.position.x - 0.5 * TheButtunOfStartGame.size.width) + TheButtunOfStartGame.size.width
                && ClickPosition.y > (TheButtunOfStartGame.position.y - 0.5 * TheButtunOfStartGame.size.height) && ClickPosition.y < (TheButtunOfStartGame.position.y - 0.5 * TheButtunOfStartGame.size.height) + TheButtunOfStartGame.size.height
            {
                TurnToGameState()
            }
            
            break
        case .InTheGame:
            
            break
        case .presentScore:
//            停止生成一切节点()
            StartNewGame()
//            切换到新游戏()
            break
        case .GameOver:
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
                self.RolePicture.zRotation = RotatingNode(目的地: self.RolePicture.position, ChuKongDIan: locationPoint)
        //        self.zombieNode.zRotation = zombieRotate(nodePoint: self.zombieNode.position, touchPoint: locationPoint)
                //将移动移动到当前的点
                MoveNode(Node: RolePicture, Destination: locationPoint)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
    }
    
    //MARK:更新
    //下面是每一帧画面就执行一次下面的函数
    override func update(_ Time: TimeInterval)
    {
        

        if LastUpdateTime > 0{
            NowTime = Time - LastUpdateTime
        }
        else
        {
            NowTime = 0
        }
        LastUpdateTime = Time
        
        switch TheNowGameState
        {
        case . menu:
            break
       
        case .InTheGame: //只有正在游戏状态这些节点才能被移动
            MoveSmoke()
            MoveGOld()
            MoveFire()
            MovePicture()
            
            MoveMonsterOne()
            MoveMonsterTwo()
            MoveMonsterThree()
            MoveMonsterFour()
            
            CheckIfgameOver()
            break
       
        case .presentScore: //这个游戏状态不归update管
            break
        case .GameOver: //这个游戏状态不归update管
            break
        }
        
        
    }
    
 
    func  CheckIfgameOver() //是否游戏结束检查
    {
        if RoleHP == 0
        {
            TheNowGameState = .presentScore
            RolePicture.removeAllActions()
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
            SetScoreBoard()
        }
    }

    

    
    //MARK:游戏状态
       
   func TurnToMenu() //切换到主菜单
   {
       TheNowGameState = . menu  //当前正在主菜单中
       SetBackground()
      
       SetMenu()
   }

 
    
   
    
  
    
    func  TurnToGameState() //切换到游戏状态，添加正式的游戏场景
    
    {
        
        TheNowGameState = .InTheGame
        WorldScene.enumerateChildNodes(withName: "主菜单", using: { MatchingNode, _ in
        MatchingNode.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.05),
                                            SKAction.removeFromParent()
            ]))}) // 删除主菜单的所有节点
       
       SetRole()
       setScoreLabel()
       RepeatAddGOld()
       RepeatAddFire()
       RepatAddSmokeNode()
       RepeateAddMonsterOne()
       RepeateAddMonsterTwo()
       RepeateAddMonsterThree()
       RepeatAddMonsterFOur()
    
        
    }
    
    func StartNewGame() //开始新游戏
    {
        sound.播放砰的音效()
        TheNowGameState = . menu
        RoleHP = RoleMaxHP
//        let 新的游戏场景 = GameScene.init(size: CGSize(width: 宽, height: 高))
        let NewGameScene = GameScene.init(size: size)
        let SwitchingEffects = SKTransition.fade(with: SKColor.black, duration: 0.05)
        view?.presentScene(NewGameScene, transition: SwitchingEffects) //new 出 新的 游戏场景
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
    
    
    func MoveNode(Node: SKSpriteNode , Destination:CGPoint) //移动节点函数
       {
           let MoveAction =  SKAction.move(to: Destination, duration: 1)
           Node.run(MoveAction)
       }
       
       func RotatingNode(目的地: CGPoint, ChuKongDIan: CGPoint ) -> CGFloat //旋转节点函数
       {
           //获取到当前点击的点的坐标之后, 计算两者之间的距离
           let dx = ChuKongDIan.x - 目的地.x
           let dy = ChuKongDIan.y - 目的地.y
           
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
      
    
    func TuranToPresentScore() //切换到显示分数状态
    {
        TheNowGameState = .presentScore
        RolePicture.removeAllActions()
//        停止重生障碍()
        SetScoreBoard()
    }
    
    func TuranToNewGame() //切换到新游戏
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
    
    func SetHighestScore(HighestScore: Int)
    {
        UserDefaults.standard.set(HighestScore, forKey: "最高分")
        UserDefaults.standard.synchronize()
    }
    
    
    //MARK: 物理引擎
    func UpdateHPScore() //更新HP值显示
    {
        if RoleHP < 0 {
            RoleHP = 0
            HPValueLabel.text = "0"
        }
        else
        {
        HPValueLabel.text = String(RoleHP)
        UpdateHPtiao()
        }
    }
    
    func UpdateHPtiao() //调节血条
    {
        var 比例 = Double(RoleHP) / Double(RoleMaxHP)
        ArticleBlood.removeFromParent()
        Rectangular = CGRect(x: 0, y: 0, width: MaximumRectangleWidth * CGFloat(比例), height: 高 * 0.1)
        ArticleBlood = SKShapeNode(rect: Rectangular, cornerRadius: 5)
        ArticleBlood.position.x = 宽 * 0.55
        ArticleBlood.position.y = 高 * 0.9
        ArticleBlood.fillColor = .red
        ArticleBlood.zPosition = 1;
        ArticleBlood.glowWidth = 1.5
        ArticleBlood.strokeColor = .blue
        ArticleBlood.name = "HP"
        ArticleBlood.lineWidth = 1.5
        WorldScene.addChild(ArticleBlood)
        
        
    }
    
    //这个函数是系统碰撞的检测函数，就是说一旦发生了两个物体的碰撞就会触发下面这个函数
    func didBegin(_ PZshuangfang: SKPhysicsContact)
    {
        print("进入碰撞检测")
        //如果是l两个相同类的对象碰撞，直接return
        if(PZshuangfang.bodyA.categoryBitMask == PZshuangfang.bodyB.categoryBitMask)
         {
             return
         }
          var BodyA : SKPhysicsBody
          var BodyB : SKPhysicsBody
          if PZshuangfang.bodyA.categoryBitMask < PZshuangfang.bodyB.categoryBitMask
          {
              BodyA = PZshuangfang.bodyA
              BodyB = PZshuangfang.bodyB
          }
          else
          {
              BodyA = PZshuangfang.bodyB
              BodyB = PZshuangfang.bodyA
          }
         //由于我们开头的设置，碰撞大的，绝对是金币（就目前来说）
        //因为游戏角色类最小！！
        //        物体B.node?.removeAllActions()
        if(BodyB.node?.name == "金币")
              {
                  sound.播放得分的音效()
                  TheScoreOfGoldPuls()
                  UpdateGOldScore()
                  碰到金币后的粒子效果()
              }
        else if(BodyB.node?.name == "火焰")
        {
            print("碰到火焰")
            sound.播放碰撞的音效()

            碰到火焰后的粒子效果()
            RoleHP  =  RoleHP - DamageOfFire;
            UpdateHPScore()

        }
        else if (BodyB.node?.name == "毒烟")
        {
             sound.播放碰撞的音效()

            print("碰到了毒烟")
            碰到毒烟后的粒子效果()
            RoleHP  =  RoleHP - DamageOfSmoke;
            UpdateHPScore()
        }
        else if(BodyB.node?.name == "妖怪1")
        {
            print("碰到了妖怪1")
             sound.播放碰撞的音效()

            碰到妖怪一后的粒子效果()
            RoleHP  =  RoleHP - DamageOfMonsterOne;
            UpdateHPScore()


        }
        else if(BodyB.node?.name == "妖怪2")
       {
      sound.播放碰撞的音效()

           print("碰到了妖怪2")
        碰到妖怪二后的粒子效果()
        RoleHP  =  RoleHP - DamageOfMonsterTwo;
        UpdateHPScore()


       }
        else if(BodyB.node?.name == "妖怪3")
       {
         sound.播放碰撞的音效()

           print("碰到了妖怪3")
        碰到妖怪三后的粒子效果()
        RoleHP  =  RoleHP - DamageOfMonsterThree;
        UpdateHPScore()


       }
        else if(BodyB.node?.name == "妖怪4")
       {
         sound.播放碰撞的音效()

            print("碰到了妖怪4")
            碰到妖怪四后的粒子效果()
            RoleHP  =  RoleHP - DamageOfMonsterFour;
        UpdateHPScore()


       }
        BodyB.node?.removeFromParent(); // 装上了那么金币肯定要收起来啦
      
        
        
    }
    
    // MARK:其他
    /**
     下面是一些碰撞发生的粒子散射的效果，增加动画的观赏性质
     */
    func 碰到金币后的粒子效果()
    {
        let yPos:CGFloat = -RolePicture.size.height
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
        let yPos:CGFloat = -RolePicture.size.height
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
        let yPos:CGFloat = -RolePicture.size.height
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
        let yPos:CGFloat = -RolePicture.size.height
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
        let yPos:CGFloat = -RolePicture.size.height
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
        let yPos:CGFloat = -RolePicture.size.height
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
        let yPos:CGFloat = -RolePicture.size.height
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
        
        WorldScene.enumerateChildNodes(withName: "金币", using: {
            所有节点, _ in 所有节点.removeAllActions()
        }) // 停止金币节点的一切Action
        
        WorldScene.enumerateChildNodes(withName: "毒烟", using: {
            所有节点, _ in 所有节点.removeAllActions()
        }) // 停止金币节点的一切Action
        
        WorldScene.enumerateChildNodes(withName: "火焰", using: {
            所有节点, _ in 所有节点.removeAllActions()
        }) // 停止金币节点的一切Action
        
        WorldScene.enumerateChildNodes(withName: "妖怪1", using: {
            所有节点, _ in 所有节点.removeAllActions()
        }) // 停止金币节点的一切Action
         WorldScene.enumerateChildNodes(withName: "妖怪1", using: {
            所有节点, _ in 所有节点.removeAllActions()
        }) // 停止金币节点的一切Action
         WorldScene.enumerateChildNodes(withName: "妖怪2", using: {
            所有节点, _ in 所有节点.removeAllActions()
        }) // 停止金币节点的一切Action
         WorldScene.enumerateChildNodes(withName: "妖怪3", using: {
            所有节点, _ in 所有节点.removeAllActions()
        }) // 停止金币节点的一切Action
         WorldScene.enumerateChildNodes(withName: "妖怪4", using: {
            所有节点, _ in 所有节点.removeAllActions()
        }) // 停止金币节点的一切Action



    
    }
}
