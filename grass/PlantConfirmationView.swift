//
//  PlantConfirmationView.swift
//  grass
//
//  Created by T Krobot on 5/11/22.
//

import SwiftUI

struct PlantConfirmationView: View {
    
    @Binding var plants: Plant
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack{
                Rectangle()
                    .fill(Color("Swamp Green"))
                    .edgesIgnoringSafeArea(.top)
                    
                HStack(alignment: .top){
                    VStack(alignment: .leading){
                        Spacer()
                        Text(plants.scientificName)
                            .italic()
                            .foregroundColor(Color(.white))
                            .font(.title2)
                        Text(plants.name)
                            .bold()
                            .foregroundColor(Color(.white))
                            .font(.title)
                            .padding(.bottom)
                    }
                    .padding(.leading)
                    Spacer()
                }
            }
            .frame(height:150)
            Spacer()

            HStack(alignment: .top){
                VStack{
                    Image(systemName: "drop.fill")
                        .scaledToFill()
                        .foregroundColor(.blue)
                    Text("Water every")
                    Text("\(plants.wateringFrequency)")
                        .font(.title)
                    Text("days")
                }
                Divider()
                    .frame(width: 4.0, height: 100)
                    .overlay(Color("Swamp Green"))
                VStack{
                    Image(systemName: "bolt.fill")
                        .scaledToFill()
                        .foregroundColor(.orange)
                    Text("Fertilise every")
                    Text("\(plants.fertilisationFrequency)")
                        .font(.title)
                    Text("days")
                }
                Divider()
                    .frame(width: 4.0, height: 100)
                    .overlay(Color("Swamp Green"))
                VStack{
                    Image(systemName: "thermometer.sun.fill")
                        .scaledToFill()
                        .foregroundColor(.orange)
                    
                    Text("Keep between")
                    
                    Text("\(plants.temperatureRangeBegin)- \(plants.temperatureRangeEnd)°C")
                        .font(.title)
                }
            }
            .padding(.top, 40)
            
            VStack(){
                Text("Add this Plant?")
                        .font(.title)
                Text("Grass will automatically remind you")
                        .scaledToFit()
                Text("when its time to care for your plant")
                        .scaledToFit()
                        .padding(.bottom)
                Button("Yes") {
                    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 137.0)
                .foregroundColor(.white)
                .background(Color("Swamp Green"))
                .cornerRadius(22.0)
                .shadow(radius: 20)
                Button("Change Plant Type") {
                    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 79.75)
                .foregroundColor(.white)
                .background(Color("Swamp Green"))
                .cornerRadius(22.0)
                .shadow(radius: 20)
                Spacer()
            }
            .background()
            .padding(.all)
            .padding(.top, 30)
            .ignoresSafeArea()
        }
    }
}

struct PlantConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        PlantConfirmationView(plants: .constant(Plant(name: "Lorem Ipsum",scientificName: "Lorem Ipsum", wateringFrequency: 0, wateringGuide: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",fertilisationFrequency: 0,fertilisationGuide: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",temperatureRangeBegin: 0,temperatureRangeEnd: 0)))
    }
}

