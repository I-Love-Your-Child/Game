//
//  soundManager.swift
//  HuLuWaGo
//
//  Created by book on 2019/12/12.
//  Copyright © 2019 book rights reserved.
//


import Foundation

import SpriteKit
//引入多媒体框架
import AVFoundation

class SoundManager :SKNode{
    //申明一个播放器
    var bgMusicPlayer = AVAudioPlayer()
    //播放点击的动作音效
    let 拍打的音效 = SKAction.playSoundFileNamed("flapping.wav", waitForCompletion: false)
    let 叮的音效 = SKAction.playSoundFileNamed("ding.wav", waitForCompletion: false)
    let 碰撞的音效 = SKAction.playSoundFileNamed("falling.wav", waitForCompletion: false)
    let 摔倒的音效 = SKAction.playSoundFileNamed("whack.wav", waitForCompletion: false)
    let 撞击地面的音效 = SKAction.playSoundFileNamed("hitGround.wav", waitForCompletion: false)
    let 砰的音效 = SKAction.playSoundFileNamed("pop.wav", waitForCompletion: false)
    let 得分的音效 = SKAction.playSoundFileNamed("coin.wav", waitForCompletion: false)
    let 背景音乐 = SKAction.playSoundFileNamed("bgm.mp3", waitForCompletion: false)
    
    //播放背景音乐的音效
    func playBackGround(){
        print("开始播放背景音乐!")
        //获取bg.mp3文件地址
        let bgMusicURL =  Bundle.main.url(forResource: "bgm", withExtension: "mp3")!
        //根据背景音乐地址生成播放器
        try! bgMusicPlayer = AVAudioPlayer (contentsOf: bgMusicURL)
        //设置为循环播放(
        bgMusicPlayer.numberOfLoops = -1
        //准备播放音乐
        bgMusicPlayer.prepareToPlay()
        //播放音乐
        bgMusicPlayer.play()
    }
    
    //播放点击音效动作的方法
    func 播放拍打的音效(){
        self.run(拍打的音效)
    }
    
    func 播放叮的音效(){
        self.run(叮的音效)
    }
    func 播放碰撞的音效(){
        self.run(碰撞的音效)
    }
    
    func 播放摔倒的音效(){
        self.run(摔倒的音效)
    }
    
    func 播放撞击地面的音效(){
        self.run(撞击地面的音效)
    }
    
    func 播放砰的音效(){
        self.run(砰的音效)
    }
    
    func 播放得分的音效(){
        self.run(得分的音效)
    }
    
}
