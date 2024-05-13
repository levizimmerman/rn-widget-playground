import {NativeModules, ToastAndroid} from 'react-native';

const SharedStorage = NativeModules.SharedStorage;

type Config = {
  kind: string;
  group: string;
  key: string;
};

class WidgetStorage<DataType> {
  config: Config;

  constructor(config: Config) {
    this.config = config;
  }

  async saveData(data: DataType) {
    SharedStorage.set(JSON.stringify(data));
    ToastAndroid.show('Widget value updated', ToastAndroid.SHORT);
  }

  async getData(): Promise<DataType> {
    return {} as DataType;
  }
}

export default WidgetStorage;
