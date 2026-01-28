//
//  CalendarContentView.swift
//  Trace
//
//  Created by Bryce Albertazzi on 1/28/26.
//

import SwiftUI

struct CalendarContentView: View {
    @ObservedObject var dataManager: JournalDataManager
    @State private var selectedDate = Date()
    @State private var selectedImageForViewing: UIImage?

    var entriesForSelectedDate: [JournalEntry] {
        let calendar = Calendar.current
        return dataManager.entries.filter { entry in
            calendar.isDate(entry.date, inSameDayAs: selectedDate)
        }
    }

    var mediaForSelectedDate: [MediaItem] {
        let calendar = Calendar.current
        return dataManager.mediaItems.filter { item in
            calendar.isDate(item.date, inSameDayAs: selectedDate)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            DatePicker(
                "",
                selection: $selectedDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.white)
                    .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
            )
            .padding(.horizontal)
            .padding(.top, 16)
            .tint(Color.traceBlue)

            VStack(alignment: .leading, spacing: 16) {
                Text(selectedDate, style: .date)
                    .font(.headline)
                    .foregroundColor(Color.traceHeading)
                    .padding(.horizontal, 24)
                    .padding(.top, 20)

                if entriesForSelectedDate.isEmpty && mediaForSelectedDate.isEmpty {
                    Text("No entries or photos for this day")
                        .foregroundColor(.gray)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 40)
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            if !mediaForSelectedDate.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Photos")
                                        .font(.headline)
                                        .foregroundColor(Color.traceHeading)
                                        .padding(.horizontal, 24)

                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 12) {
                                            ForEach(mediaForSelectedDate.sorted(by: { $0.date > $1.date })) { item in
                                                if let imageURL = dataManager.getPhotosDirectory()?.appendingPathComponent(item.fileName),
                                                   let uiImage = UIImage(contentsOfFile: imageURL.path) {
                                                    Image(uiImage: uiImage)
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 100, height: 100)
                                                        .clipped()
                                                        .cornerRadius(12)
                                                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                                                        .onTapGesture {
                                                            selectedImageForViewing = uiImage
                                                        }
                                                        .contextMenu {
                                                            Button(role: .destructive) {
                                                                withAnimation {
                                                                    dataManager.deleteMediaItem(item)
                                                                }
                                                            } label: {
                                                                Label("Delete", systemImage: "trash")
                                                            }
                                                        }
                                                }
                                            }
                                        }
                                        .padding(.horizontal, 24)
                                    }
                                }
                            }

                            if !entriesForSelectedDate.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Entries")
                                        .font(.headline)
                                        .foregroundColor(Color.traceHeading)
                                        .padding(.horizontal, 24)

                                    VStack(spacing: 12) {
                                        ForEach(entriesForSelectedDate.sorted(by: { $0.date > $1.date })) { entry in
                                            VStack(alignment: .leading, spacing: 8) {
                                                Text(entry.text)
                                                    .font(.body)

                                                Text(entry.date, style: .time)
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding()
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(.white)
                                                    .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 2)
                                            )
                                            .padding(.horizontal, 24)
                                            .contextMenu {
                                                Button(role: .destructive) {
                                                    withAnimation {
                                                        dataManager.deleteEntry(entry)
                                                    }
                                                } label: {
                                                    Label("Delete", systemImage: "trash")
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }

            Spacer()
        }
        .fullScreenCover(item: Binding(
            get: { selectedImageForViewing.map { ImageWrapper(image: $0) } },
            set: { selectedImageForViewing = $0?.image }
        )) { wrapper in
            PhotoViewerView(image: wrapper.image)
        }
    }
}

#Preview {
    CalendarContentView(dataManager: JournalDataManager())
}
