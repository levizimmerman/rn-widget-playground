import SharedGroupPreferences from 'react-native-shared-group-preferences';
import RNWidgetCenter from 'react-native-widget-center';

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
    try {
      await SharedGroupPreferences.setItem(
        this.config.key,
        data,
        this.config.group,
      );
      RNWidgetCenter.reloadTimelines(this.config.kind);
    } catch (error) {
      console.error(error);
    }
  }

  async getData(): Promise<DataType | null> {
    const data = await SharedGroupPreferences.getItem(
      this.config.key,
      this.config.group,
    );
    try {
      const parsed = JSON.parse(data);
      return parsed;
    } catch (error) {
      console.error(error);
    }
    return null;
  }
}

export default WidgetStorage;
