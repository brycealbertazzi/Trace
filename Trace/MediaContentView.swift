//
//  MediaContentView.swift
//  Trace
//
//  Created by Bryce Albertazzi on 1/28/26.
//

import SwiftUI
import PhotosUI

struct MediaContentView: View {
    @ObservedObject var dataManager: JournalDataManager
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedDate = Date()
    @State private var showingDatePicker = false
    @State private var selectedImageForViewing: UIImage?

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                if dataManager.mediaItems.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "photo.on.rectangle")
                            .font(.system(size: 60))
                            .foregroundColor(Color(red: 0.5, green: 0.6, blue: 0.8))
                            .symbolEffect(.pulse)

                        Text("No photos yet")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.4, green: 0.5, blue: 0.7))

                        Text("Tap the camera button to add photos")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, 60)
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 16) {
                            ForEach(Array(dataManager.mediaItems.sorted(by: { $0.date > $1.date }).enumerated()), id: \.element.id) { index, item in
                                if let imageURL = dataManager.getPhotosDirectory()?.appendingPathComponent(item.fileName),
                                   let uiImage = UIImage(contentsOfFile: imageURL.path) {
                                    VStack(spacing: 6) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipped()
                                            .cornerRadius(12)
                                            .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 2)

                                        Text(item.date, style: .date)
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                    }
                                    .transition(.scale.combined(with: .opacity))
                                    .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(Double(index) * 0.03), value: dataManager.mediaItems.count)
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
                        .padding()
                        .padding(.top, 16)
                        .padding(.bottom, 100)
                    }
                }
            }

            // Floating camera button
            VStack {
                Spacer()

                HStack {
                    Spacer()

                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(
                                LinearGradient(
                                    colors: [Color.traceLightBlue, Color.traceBlue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(Circle())
                            .shadow(color: Color.traceBlue.opacity(0.4), radius: 8, x: 0, y: 4)
                    }
                    .onChange(of: selectedItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let image = UIImage(data: data) {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    saveImage(image)
                                }
                            }
                        }
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 30)
                }
            }
        }
        .sheet(isPresented: $showingDatePicker) {
            NavigationView {
                ZStack {
                    LinearGradient(
                        colors: [Color.traceBackground1, Color.traceBackground2],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()

                    VStack {
                        DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date])
                            .datePickerStyle(.graphical)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.white)
                                    .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
                            )
                            .padding()
                            .tint(Color.traceBlue)

                        Spacer()
                    }
                }
                .navigationTitle("Choose Date")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            showingDatePicker = false
                        }
                        .foregroundColor(Color.traceHeading)
                        .fontWeight(.semibold)
                    }
                }
            }
        }
        .fullScreenCover(item: Binding(
            get: { selectedImageForViewing.map { ImageWrapper(image: $0) } },
            set: { selectedImageForViewing = $0?.image }
        )) { wrapper in
            PhotoViewerView(image: wrapper.image)
        }
    }

    private func saveImage(_ image: UIImage) {
        guard let photosDir = dataManager.getPhotosDirectory(),
              let imageData = image.jpegData(compressionQuality: 0.8) else { return }

        let fileName = "\(UUID().uuidString).jpg"
        let fileURL = photosDir.appendingPathComponent(fileName)

        do {
            try imageData.write(to: fileURL)
            let mediaItem = MediaItem(fileName: fileName, date: Date())
            dataManager.addMediaItem(mediaItem)
        } catch {
            print("Error saving image: \(error)")
        }
    }
}

#Preview {
    MediaContentView(dataManager: JournalDataManager())
}
