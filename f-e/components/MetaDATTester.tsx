import React, { useEffect, useState } from 'react';
import { View, Button, Text } from 'react-native';
import MetaDAT from '@/lib/MetaDAT';

export default function MetaDATTester() {
  const [lastChunkTs, setLastChunkTs] = useState<number | null>(null);
  const [running, setRunning] = useState(false);

  useEffect(() => {
    let subscription: any = null;
    MetaDAT.initializeDAT({ demo: true }).catch(() => {});
    return () => {
      if (subscription) subscription.remove && subscription.remove();
    };
  }, []);

  const start = async () => {
    await MetaDAT.startAudioStream();
    setRunning(true);
    subscription = MetaDAT.addAudioChunkListener((payload) => {
      setLastChunkTs(payload.timestamp);
    });
  };

  const stop = async () => {
    await MetaDAT.stopAudioStream();
    setRunning(false);
  };

  let subscription: any = null;

  return (
    <View style={{ padding: 12 }}>
      <Text>Meta DAT Tester</Text>
      <Text>Running: {running ? 'Yes' : 'No'}</Text>
      <Text>Last Chunk: {lastChunkTs ?? '—'}</Text>
      <Button title="Start" onPress={() => start()} />
      <Button title="Stop" onPress={() => stop()} />
    </View>
  );
}
