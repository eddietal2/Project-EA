// fe/fe-Bridging-Header.h
// Swift bridging header: include React Native headers conditionally so Swift
// sees the Obj-C symbols it needs for RCTBridgeModule / RCTEventEmitter

#ifdef __OBJC__
#import <Foundation/Foundation.h>

// Prefer modular import if present
#if __has_include(<React/React.h>)
@import React;
#endif

// RCTBridgeModule
#if __has_include(<React/RCTBridgeModule.h>)
#import <React/RCTBridgeModule.h>
#elif __has_include(<RCTBridgeModule.h>)
#import "RCTBridgeModule.h"
#endif

// RCTEventEmitter
#if __has_include(<React/RCTEventEmitter.h>)
#import <React/RCTEventEmitter.h>
#elif __has_include(<RCTEventEmitter.h>)
#import "RCTEventEmitter.h"
#endif

// RCTLog (optional)
#if __has_include(<React/RCTLog.h>)
#import <React/RCTLog.h>
#elif __has_include(<RCTLog.h>)
#import "RCTLog.h"
#endif

// Fallback Promise typedefs
#ifndef RCTPromiseResolveBlock
typedef void (^RCTPromiseResolveBlock)(id _Nullable result);
#endif

#ifndef RCTPromiseRejectBlock
typedef void (^RCTPromiseRejectBlock)(NSString * _Nullable code, NSString * _Nullable message, NSError * _Nullable error);
#endif

// Optional local Meta DAT bridge types
#if __has_include("MetaDATBridge+Types.h")
#import "MetaDATBridge+Types.h"
#endif

#endif // __OBJC__

