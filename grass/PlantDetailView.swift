//
//  PlantDetailView.swift
//  grass
//
//  Created by hy loh on 14/11/22.
//
//we were forced to write this code
//
//pls no copy
//
//made by tu madere

import SwiftUI

struct PlantDetailView: View {
    
    @Binding var plants: Plant
    
    var body: some View {
        VStack {
            List{
                VStack{
                    Section(header: Text("Details")) {
                        HStack{
                            Image(systemName: "tag.fill")
                            Text("Plant Name")
                            Spacer()
                            Text(plants.name)
                                .foregroundColor(Color(.gray))
                                .multilineTextAlignment(.trailing)
                        }
                        Spacer()
                        
                        HStack{
                            Image(systemName: "testtube.2")
                                .foregroundColor(.purple)
                            Text("Scientific Name")
                            Spacer()
                            Text($plants.scientificName.wrappedValue)
                                .foregroundColor(Color(.gray))
                        }
                    }
                    
                    Spacer()
                    Section(header: Text("Care Instructions")) {
                        HStack{
                            Image(systemName: "thermometer.low")
                                .foregroundColor(.blue)
                            Text("Minimum Temperature")
                            Spacer()
                            Text("\(String(plants.temperatureRangeBegin))˚C")
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        HStack{
                            Image(systemName: "thermometer.high")
                                .foregroundColor(.red)
                            Text("Maximum Temperature")
                            Spacer()
                            Text("\(String(plants.temperatureRangeEnd))˚C")
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        
                        HStack{
                            Image(systemName: "drop.fill")
                                .foregroundColor(.cyan)
                            Text("Water every \(plants.wateringFrequency) days")
                                .bold()
                        }
                        HStack {
                            Text(plants.wateringGuide)
                        }
                        HStack {
                            Image(systemName: "leaf.fill")
                                .foregroundColor(.mint)
                            Text("Fertilise every \(plants.fertilisationFrequency) days")
                                .bold()
                        }
                        HStack {
                            Text(plants.fertilisationGuide)
                        }
                    }
                }
                .listRowSeparator(/*@START_MENU_TOKEN@*/.visible/*@END_MENU_TOKEN@*/)
            }
            .navigationTitle(plants.name)
        }
    }
}



struct PlantDetailView_Previews:
    PreviewProvider {
    static var previews: some View {
        PlantDetailView(plants: .constant(Plant(name: "Lorem Ipsum",scientificName: "Lorem Ipsum", wateringFrequency: 0, wateringGuide: "Water frequently.",fertilisationFrequency: 0,fertilisationGuide: "Fertilize frequently.",temperatureRangeBegin: 0,temperatureRangeEnd: 0)))
    }
}

