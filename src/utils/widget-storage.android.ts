import {NativeModules, ToastAndroid} from 'react-native';

const SharedStorage = NativeModules.SharedStorage;

type Config = {
  kind: string;
  group: string;
  key: string;
};

class WidgetStorage<DataType = Record<string, any>> {
  config: Config;

  constructor(config: Config) {
    this.config = config;
  }

  async saveData(data: DataType) {
    SharedStorage.set(JSON.stringify(data));
    ToastAndroid.show('Widget value updated', ToastAndroid.SHORT);
  }

  async getData(): Promise<DataType | null> {
    const data = await SharedStorage.get();

    try {
      const parsed = JSON.parse(data);
      return parsed;
    } catch (error) {
      console.error(error);
      return null;
    }
  }
}

export default WidgetStorage;
