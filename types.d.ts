declare module 'react-native-widget-center' {
  // Adjust this type to match the configuration of your widget
  type WidgetConfig = {
    kind: string;
    family: string;
  };
  export const reloadTimelines: (widgetName: string) => void;
  export const reloadAllTimelines: () => void;
  export const getCurrentConfigurations: () => Promise<WidgetConfig[]>;
}
