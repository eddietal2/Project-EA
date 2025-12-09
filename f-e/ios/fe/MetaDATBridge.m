// MetaDATBridge.m
// Objective-C module shim that registers the Swift `MetaDATBridge` with React Native.

#import <Foundation/Foundation.h>
#if __has_include(<React/RCTBridgeModule.h>)
#import <React/RCTBridgeModule.h>
#elif __has_include(<React/RCTBridge/RCTBridgeModule.h>)
#import <React/RCTBridge/RCTBridgeModule.h>
#elif __has_include(<ReactCore/RCTBridgeModule.h>)
#import <ReactCore/RCTBridgeModule.h>
#else
#import "RCTBridgeModule.h"
#endif

#if __has_include(<React/RCTEventEmitter.h>)
#import <React/RCTEventEmitter.h>
#elif __has_include(<React/RCTBridge/RCTEventEmitter.h>)
#import <React/RCTBridge/RCTEventEmitter.h>
#elif __has_include(<ReactCore/RCTEventEmitter.h>)
#import <ReactCore/RCTEventEmitter.h>
#else
#import "RCTEventEmitter.h"
#endif

#import "MetaDATBridge+Types.h"

// React Native expects a bridging file to expose Swift methods to Obj-C via macros
RCT_EXTERN_MODULE(MetaDATBridge, RCTEventEmitter)

// Exposed methods. These must match method names in the Swift implementation.
RCT_EXTERN_METHOD(initializeDAT:(NSDictionary *)options
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(startAudioStream:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(stopAudioStream:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(isStreaming:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)

// Note: method declarations use RCT_EXTERN_METHOD macros
