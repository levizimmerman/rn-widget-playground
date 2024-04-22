import React from 'react';
import {
  NativeModules,
  Button,
  SafeAreaView,
  Text,
  TextInput,
  ToastAndroid,
  Platform,
} from 'react-native';
import SharedGroupPreferences from 'react-native-shared-group-preferences';
import RNWidgetCenter from 'react-native-widget-center';

const group = 'group.streak';

const SharedStorage = NativeModules.SharedStorage;

const App: React.FC = () => {
  const [text, setText] = React.useState('');
  const widgetData = {
    text,
  };

  const handleSubmit = async () => {
    if (Platform.OS === 'ios') {
      try {
        await SharedGroupPreferences.setItem('widgetKey', widgetData, group);
        RNWidgetCenter.reloadTimelines('StreakWidget');
      } catch (error) {
        console.error(error);
      }
    }
    if (Platform.OS === 'android') {
      const value = `${text} days`;
      SharedStorage.set(JSON.stringify({text: value}));
      ToastAndroid.show('Widget value updated', ToastAndroid.SHORT);
    }
  };

  React.useEffect(() => {
    SharedGroupPreferences.getItem('widgetKey', group).then(data => {
      try {
        const parsed = JSON.parse(data);
        setText(parsed.text);
      } catch (error) {
        console.error(error);
      }
    });
  }, []);

  return (
    <SafeAreaView>
      <Text>Change Widget Value</Text>
      <TextInput
        onChangeText={setText}
        value={text}
        placeholder="Enter the text to display"
      />
      <Button title="Submit" onPress={handleSubmit} />
    </SafeAreaView>
  );
};

export default App;
