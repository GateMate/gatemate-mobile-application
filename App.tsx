// /**
//  * Sample React Native App
//  * https://github.com/facebook/react-native
//  *
//  * @format
//  */

// import React from 'react';
// import { SafeAreaProvider } from 'react-native-safe-area-context';
// import { AppearanceProvider } from 'react-native-appearance';

// import { Main } from './src/main';
// import type {PropsWithChildren} from 'react';

// import {
// 	SafeAreaView,
// 	ScrollView,
// 	StatusBar,
// 	StyleSheet,
// 	Text,
// 	useColorScheme,
// 	View,
// 	Button,
// } from 'react-native';

// import {
// 	Colors,
// 	DebugInstructions,
// 	Header,
// 	LearnMoreLinks,
// 	ReloadInstructions,
// } from 'react-native/Libraries/NewAppScreen';

// type SectionProps = PropsWithChildren<{

// 	title: string;
// }>;

// function Section({children, title}: SectionProps): JSX.Element {
// 	const isDarkMode = useColorScheme() === 'dark';
// 	return (
// 		<View style={styles.sectionContainer}>
// 			<Text
// 				style={[
// 					styles.sectionTitle,
// 					{
// 						color: isDarkMode ? Colors.white : Colors.black,
// 					},
// 				]}>
// 				{title}
// 			</Text>
// 			<Text
// 				style={[
// 					styles.sectionDescription,
// 					{
// 						color: isDarkMode ? Colors.light : Colors.dark,
// 					},
// 				]}>
// 				{children}
// 			</Text>
// 		</View>
// 	);
// }

// // function HomeScreen({ navigation }) {
// //   return (
// //     <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
// //       <Button
// //         onPress={() => navigation.navigate('Notifications')}
// //         title="Go tell Jackson hi"
// //       />
// //     </View>
// //   );
// // }
// //
// // function NotificationsScreen({ navigation }) {
// //   return (
// //     <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
// //       <Button onPress={() => navigation.goBack()} title="Go tell Jackson bye" />
// //     </View>
// //   );
// // }
// //
// // const Drawer = createDrawerNavigator();

// function App(): JSX.Element {
// 	const isDarkMode = useColorScheme() === 'dark';

// 	const backgroundStyle = {
// 		backgroundColor: isDarkMode ? Colors.darker : Colors.lighter,
// 	};

// 	return (
// // 		<SafeAreaView style={backgroundStyle}>
// 		<SafeAreaProvider>
//               <AppearanceProvider>

//               </AppearanceProvider>
//             </SafeAreaProvider>
// // 		    <NavigationContainer>
// //               <Drawer.Navigator initialRouteName="Home">
// //                 <Drawer.Screen name="Home" component={HomeScreen} />
// //                 <Drawer.Screen name="Notifications" component={NotificationsScreen} />
// //               </Drawer.Navigator>
// //             </NavigationContainer>
// // 			<StatusBar
// // 				barStyle={isDarkMode ? 'light-content' : 'dark-content'}
// // 				backgroundColor={backgroundStyle.backgroundColor}
// // 			/>
// // 			<ScrollView
// // 				contentInsetAdjustmentBehavior="automatic"
// // 				style={backgroundStyle}>
// // 				<Header />
// // 				<View
// // 					style={{
// // 						backgroundColor: isDarkMode ? Colors.black : Colors.white,
// // 					}}>
// // 					<Section title="Step One">
// // 						Edit <Text style={styles.highlight}>App.tsx</Text> to change this
// // 						screen and then come back to see your edits.
// // 					</Section>
// // 					<Section title="See Your Changes">
// // 						<ReloadInstructions />
// // 					</Section>
// // 					<Section title="Debug">
// // 						<DebugInstructions />
// // 					</Section>
// // 					<Section title="Learn More">
// // 						Read the docs to discover what to do next:
// // 					</Section>
// // 					<LearnMoreLinks />
// // 				</View>
// // 			</ScrollView>
// // 		</SafeAreaView>
// 	);
// }

// const styles = StyleSheet.create({
// 	sectionContainer: {
// 		marginTop: 32,
// 		paddingHorizontal: 24,
// 	},
// 	sectionTitle: {
// 		fontSize: 24,
// 		fontWeight: '600',
// 	},
// 	sectionDescription: {
// 		marginTop: 8,
// 		fontSize: 18,
// 		fontWeight: '400',
// 	},
// 	highlight: {
// 		fontWeight: '700',
// 	},
// });

// export default App;
