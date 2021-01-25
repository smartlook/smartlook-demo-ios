//
//  TownsDetailView.swift
//  Smartlook Demo
//
//  Created by Václav Halík on 04.01.2021.
//  Copyright © 2021 Smartlook. All rights reserved.
//

import SwiftUI

struct TownsDetailView: View {
    @State var town: Town? = TownsData.all.first {
        didSet {
            isLoading = true
        }
    }
    @State private var showingDetail = false
    @State private var isLoading = true

    var body: some View {
        ZStack {
            WebView(url: town?.url, isLoading: $isLoading)
                .edgesIgnoringSafeArea(.bottom)

            if isLoading {
                ProgressView("Loading ...")
            }
        }
        .navigationTitle(town?.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button(
            action: {
                showingDetail.toggle()
            }, label: {
                Text("Map").fontWeight(.regular)
            }).sheet(isPresented: $showingDetail, content: {
                TownsMapView(town: town, showing: $showingDetail)
            })
        )
    }
}

struct TownsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TownsDetailView()
    }
}
