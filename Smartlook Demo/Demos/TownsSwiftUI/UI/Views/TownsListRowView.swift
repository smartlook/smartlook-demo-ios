//
//  TownsListRowView.swift
//  Smartlook Demo
//
//  Created by Václav Halík on 30.12.2020.
//  Copyright © 2020 Smartlook. All rights reserved.
//

import SwiftUI

struct TownsListRowView: View {
    var town: Town

    var body: some View {
        HStack {
            Image(uiImage: town.flag ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 54, height: 36)
                .clipped()
                .border(Color(.systemGray4), width: 1)

            Text(town.name ?? "")

            Spacer()
        }
    }
}

struct TownsListRowView_Previews: PreviewProvider {
    static var previewTown = TownsData.all.first!

    static var previews: some View {
        TownsListRowView(town: previewTown)
    }
}
