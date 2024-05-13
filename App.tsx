import React from 'react';
import {Button, SafeAreaView, TextInput, StyleSheet, View} from 'react-native';
import WidgetStorageClient from './src/utils/widget-storage';

const WidgetStorage = new WidgetStorageClient<{favoriteEmoji: string}>({
  kind: 'ExampleWidget',
  group: 'group.example',
  key: 'widgetKey',
});

const App: React.FC = () => {
  const [favoriteEmoji, setFavoriteEmoji] = React.useState('');
  const widgetData = {
    favoriteEmoji,
  };

  const handleSubmit = async () => {
    WidgetStorage.saveData(widgetData);
  };

  const removeEmoji = async () => {
    setFavoriteEmoji('');
    WidgetStorage.saveData({favoriteEmoji: ''});
  };

  React.useEffect(() => {
    (async () => {
      const data = await WidgetStorage.getData();
      setFavoriteEmoji(data?.favoriteEmoji ?? '');
    })();
  }, []);

  return (
    <SafeAreaView style={styles.container}>
      <TextInput
        onChangeText={setFavoriteEmoji}
        value={favoriteEmoji}
        placeholder="Pick your favorite emoji"
        style={styles.input}
      />
      <Button title="Save emoji" onPress={handleSubmit} />
      <View style={styles.spacer} />
      <Button title="Remove emoji" onPress={removeEmoji} color="red" />
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    alignItems: 'center',
    justifyContent: 'center',
  },
  input: {
    fontSize: 32,
    marginVertical: 16,
  },
  spacer: {
    marginVertical: 8,
  },
});

export default App;
