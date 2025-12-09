import { NativeEventEmitter, NativeModules } from 'react-native';

const { MetaDATBridge } = NativeModules;

const emitter = new NativeEventEmitter(MetaDATBridge);

export default {
  initializeDAT: (options: Record<string, any>) => {
    if (!MetaDATBridge || !MetaDATBridge.initializeDAT) return Promise.reject(new Error('MetaDATBridge native module unavailable'));
    return MetaDATBridge.initializeDAT(options);
  },
  startAudioStream: () => {
    if (!MetaDATBridge || !MetaDATBridge.startAudioStream) return Promise.reject(new Error('MetaDATBridge native module unavailable'));
    return MetaDATBridge.startAudioStream();
  },
  stopAudioStream: () => {
    if (!MetaDATBridge || !MetaDATBridge.stopAudioStream) return Promise.reject(new Error('MetaDATBridge native module unavailable'));
    return MetaDATBridge.stopAudioStream();
  },
  isStreaming: () => {
    if (!MetaDATBridge || !MetaDATBridge.isStreaming) return Promise.reject(new Error('MetaDATBridge native module unavailable'));
    return MetaDATBridge.isStreaming();
  },
  addAudioChunkListener: (cb: (payload: { data: string; timestamp: number }) => void) => emitter.addListener('onAudioChunk', cb),
  removeAudioChunkListener: (subscription: any) => subscription.remove && subscription.remove(),
};
