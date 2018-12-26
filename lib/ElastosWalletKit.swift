//
//  ElastosWallet.swift
//  lib
//
//  Created by mengxk on 2018/11/3.
//  Copyright © 2018 Elastos. All rights reserved.
//

import Foundation

open class ElastosWalletKit  {
  private init() {}
  
  
  public static func GetSinglePublicKey(seed: Data?, seedLen: Int) -> String? {
    guard seed != nil else { return nil }
    let seedPtr = Data.ToUnsafeMutablePointer(data: seed)

    let pubKeyPtr = getSinglePublicKey(seedPtr, Int32(seedLen))
    let pubKey = String.FromUnsafeMutablePointer(data: pubKeyPtr)
    freeBuf(pubKeyPtr)
    
    return pubKey
  }
  
  public static func GetSinglePrivateKey(seed: Data?, seedLen: Int) -> String? {
    guard seed != nil else { return nil }
    let seedPtr = Data.ToUnsafeMutablePointer(data: seed)

    let privKeyPtr = getSinglePrivateKey(seedPtr, Int32(seedLen))
    let privKey = String.FromUnsafeMutablePointer(data: privKeyPtr)
    freeBuf(privKeyPtr)
    
    return privKey
  }
  
  public static func GetMasterPublicKey(seed: Data?, seedLen: Int,
                                        coinType: Int32) -> Data? {
    guard seed != nil else { return nil }
    let seedPtr = Data.ToUnsafeMutablePointer(data: seed)

    let masterPubKeyPtr = getMasterPublicKey(seedPtr, Int32(seedLen), coinType)
    let masterPubKey = Data.FromUnsafeMutablePointer(data: masterPubKeyPtr,
                                                     size: MemoryLayout<MasterPublicKey>.size)
    freeBuf(masterPubKeyPtr)
    
    return masterPubKey
  }
  
  public static func GetAddress(publicKey: String?) -> String? {
    guard publicKey != nil else { return nil }
    let pubKeyPtr = String.ToUnsafeMutablePointer(data: publicKey)
    
    let addressPtr = getAddress(pubKeyPtr)
    let address = String.FromUnsafeMutablePointer(data: addressPtr)
    freeBuf(addressPtr)
    
    return address
  }

  public static func GenerateMnemonic(language: String, words: String?) -> String? {
    let languagePtr = String.ToUnsafeMutablePointer(data: language)
    let wordsPtr = String.ToUnsafeMutablePointer(data: words)
    
    let mnemonicPtr = generateMnemonic(languagePtr, wordsPtr)
    let mnemonic = String.FromUnsafeMutablePointer(data: mnemonicPtr)
    freeBuf(mnemonicPtr)
    
    return mnemonic
  }

  public static func GetSeedFromMnemonic(seed: inout Data,
                                         mnemonic: String?,
                                         language: String, words: String?,
                                         mnemonicPassword: String) -> Int {
    guard mnemonic != nil else { return -1 }
    
    let mnemonicPtr = String.ToUnsafeMutablePointer(data: mnemonic)
    let languagePtr = String.ToUnsafeMutablePointer(data: language)
    let wordsPtr = String.ToUnsafeMutablePointer(data: words)
    let mnemonicPasswordPtr = String.ToUnsafeMutablePointer(data: mnemonicPassword)
    
    var seedPtr: UnsafeMutableRawPointer? = nil
    let seedLen = getSeedFromMnemonic(&seedPtr, mnemonicPtr, languagePtr, wordsPtr, mnemonicPasswordPtr)
    guard seedLen > 0 && seedPtr != nil else {
      return Int(seedLen)
    }
    
    let seedData = Data.FromUnsafeMutablePointer(data: seedPtr, size: Int(seedLen))
    freeBuf(seedPtr)
    
    let seedStr = seedData?.base64EncodedString()
    print( "======================" + seedStr! )
    
    seed.removeAll()
    seed.append(seedData!)
    
    return Int(seedLen)
  }

  
  public static func GetPublicKeyFromPrivateKey(privateKey: String?) -> String? {
    guard privateKey != nil else { return nil }
    
    let privKeyPtr = String.ToUnsafeMutablePointer(data: privateKey)
    
    let pubKeyPtr = getPublicKeyFromPrivateKey(privKeyPtr)
    
    let pubKey = String.FromUnsafeMutablePointer(data: pubKeyPtr)
    
    return pubKey
  }
  
  public static func Sign(privateKey: String?, data: Data, len: Int, signedData: inout Data) -> Int {
    guard privateKey != nil else { return -1 }
    
    let privateKeyPtr = String.ToUnsafeMutablePointer(data: privateKey)
    let dataPtr = Data.ToUnsafeMutablePointer(data: data)
    
    var signedDataPtr: UnsafeMutableRawPointer? = nil
    let signedDataLen = sign(privateKeyPtr, dataPtr, Int32(len), &signedDataPtr)
    guard signedDataLen > 0 && signedDataPtr != nil else {
      return Int(signedDataLen)
    }
    
    let signedDataData = Data.FromUnsafeMutablePointer(data: signedDataPtr!, size: Int(signedDataLen))
    freeBuf(signedDataPtr)
    
    signedData.removeAll()
    signedData.append(signedDataData!)
    
    return Int(signedDataLen)
  }
    
  
  
  
  
  public static func GetMasterPrivateKey(mmemonic: String, language: String,
                                  path: String, password: String) -> String? {
//    let mmemonicPtr = String.ToUnsafeMutablePointer(data: mmemonic)
//    let languagePtr = String.ToUnsafeMutablePointer(data: language)
//    let pathPtr = String.ToUnsafeMutablePointer(data: path)
//    let passwordPtr = String.ToUnsafeMutablePointer(data: password)
    
   // let privKeyPtr = getMasterPrivateKey(mmemonicPtr, languagePtr,
     //                                    pathPtr, passwordPtr)
    
    //let privKey = String.FromUnsafeMutablePointer(data: privKeyPtr)
    
    return nil
  }
  
  public static func GenerateRawTransaction(transaction: String) -> String? {
    let transactionPtr = String.ToUnsafeMutablePointer(data: transaction)
    
    let rawTxPtr = generateRawTransaction(transactionPtr)
    
    let rawTx = String.FromUnsafeMutablePointer(data: rawTxPtr)
    
    return rawTx
  }

}