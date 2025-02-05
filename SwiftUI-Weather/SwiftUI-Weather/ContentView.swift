//
//  ContentView.swift
//  SwiftUI-Weather
//
//  Created by Ahmed Kadri on 1/25/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isNight = false // source of truth data
    
    var days: [WeatherDayView] = [
        WeatherDayView(
            dayOfWeek: "TUE",
            imageName: "cloud.sun.fill",
            temperature: 74
        ),
        WeatherDayView(
            dayOfWeek: "WED",
            imageName: "sun.max.fill",
            temperature: 88
        ),
        WeatherDayView(
            dayOfWeek: "THU",
            imageName: "wind.snow",
            temperature: 55
        ),
        WeatherDayView(
            dayOfWeek: "FRI",
            imageName: "sunset.fill",
            temperature: 60
        ),
        WeatherDayView(
            dayOfWeek: "SAT",
            imageName: "snow",
            temperature: 25
        ),
    ]
    
    
    var body: some View {
        ZStack {
            BackgroundView(isNight: isNight)
            
            VStack {
                CityTextView(cityName: "Cupertino, CA")
                
                MainWeatherStatusView(imageName: isNight ? "moon.stars.fill" : "cloud.sun.fill", temperature: 78)
                
                HStack(spacing: 20) {
                    ForEach(days, id:\.self) { view in
                        view
                    }
                }
                Spacer()
                Button {
                    isNight.toggle()
                } label: {
                    WeatherButton(title: "Change Day Time",
                                  textColor: .white,
                                  backgroundColor: .mint)
                }
                Spacer()
            }
        }
//        .onAppear {
//            let button = WeatherButton(title: "Change Day Time",
//                          textColor: .white,
//                          backgroundColor: .mint)
//            print(type(of: button.body))
//        }
    }
}

#Preview {
    ContentView()
}

struct BackgroundView: View {
    
    var isNight: Bool // to inherit state from parent view & make it binding only when you'll change it
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [isNight ? .black : .blue, isNight ? .gray : .lightblue]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
//        ContainerRelativeShape()
//            .fill(isNight ? Color.black.gradient : Color.blue.gradient)
//            .ignoresSafeArea()
    }
}


struct CityTextView: View {
    var cityName: String
    
    var body: some View {
        Text(cityName)
            .font(.system(size: 32, weight: .medium, design: .default))
            .foregroundColor(.white)
            .padding()
    }
}

struct MainWeatherStatusView: View {
    
    var imageName: String
    var temperature: Int
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: imageName) // SF Symbol
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, height: 180)
            
            Text("\(temperature)°F")
                .font(.system(size: 70, weight: .medium, design: .default))
                .foregroundColor(.white)
        }
        .padding(.bottom, 40) // in the case of accounting for all screensizes you have
                              // to be more thorough
    }
}

struct WeatherDayView: View, Hashable {
    var dayOfWeek: String
    var imageName: String
    var temperature: Int
    
    var body: some View {
        VStack(spacing: 5) {
            Text(dayOfWeek)
                .font(.system(size: 20, weight: .medium, design: .default))
                .foregroundColor(.white)
            Image(systemName: imageName)
                .symbolRenderingMode(.multicolor)
                .resizable()
//                .foregroundColor(.white)
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
            Text("\(temperature)°")
                .font(.system(size: 28, weight: .medium, design: .default))
                .foregroundColor(.white)
        }
    }
}


