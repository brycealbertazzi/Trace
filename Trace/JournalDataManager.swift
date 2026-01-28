//
//  JournalDataManager.swift
//  Trace
//
//  Created by Bryce Albertazzi on 1/26/26.
//

import Foundation
import Combine

class JournalDataManager: ObservableObject {
    @Published var entries: [JournalEntry] = []
    @Published var mediaItems: [MediaItem] = []

    private let fileName = "journal_entries.json"
    private let mediaFileName = "media_items.json"

    init() {
        loadEntries()
        loadMediaItems()

        // Add sample entries if this is the first launch
        if entries.isEmpty {
            let sampleEntries = [
                JournalEntry(text: "Welcome to Trace! This is your first journal entry.", date: Date()),
                JournalEntry(text: "You can add new entries by tapping the plus button.", date: Date().addingTimeInterval(-3600))
            ]
            entries = sampleEntries
            saveEntries()
        }
    }

    private func getDocumentDirectory() -> URL? {
        if let ubiquityURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") {
            // iCloud is available
            try? FileManager.default.createDirectory(at: ubiquityURL, withIntermediateDirectories: true)
            return ubiquityURL
        } else {
            // Fallback to local storage if iCloud is not available
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        }
    }

    private func getFileURL() -> URL? {
        return getDocumentDirectory()?.appendingPathComponent(fileName)
    }

    func loadEntries() {
        guard let fileURL = getFileURL() else { return }

        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            entries = try decoder.decode([JournalEntry].self, from: data)
        } catch {
            print("No existing entries found or error loading: \(error)")
            // Start with empty array if file doesn't exist
            entries = []
        }
    }

    func saveEntries() {
        guard let fileURL = getFileURL() else { return }

        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(entries)
            try data.write(to: fileURL, options: [.atomic])
        } catch {
            print("Error saving entries: \(error)")
        }
    }

    func addEntry(_ entry: JournalEntry) {
        entries.append(entry)
        saveEntries()
    }

    func deleteEntry(_ entry: JournalEntry) {
        entries.removeAll { $0.id == entry.id }
        saveEntries()
    }

    // MARK: - Media Management

    func loadMediaItems() {
        guard let directory = getDocumentDirectory() else { return }
        let fileURL = directory.appendingPathComponent(mediaFileName)

        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            mediaItems = try decoder.decode([MediaItem].self, from: data)
        } catch {
            print("No existing media items found or error loading: \(error)")
            mediaItems = []
        }
    }

    func saveMediaItems() {
        guard let directory = getDocumentDirectory() else { return }
        let fileURL = directory.appendingPathComponent(mediaFileName)

        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(mediaItems)
            try data.write(to: fileURL, options: [.atomic])
        } catch {
            print("Error saving media items: \(error)")
        }
    }

    func addMediaItem(_ item: MediaItem) {
        mediaItems.append(item)
        saveMediaItems()
    }

    func deleteMediaItem(_ item: MediaItem) {
        // Delete the image file
        if let directory = getDocumentDirectory() {
            let imageURL = directory.appendingPathComponent("Photos").appendingPathComponent(item.fileName)
            try? FileManager.default.removeItem(at: imageURL)
        }

        // Remove from array
        mediaItems.removeAll { $0.id == item.id }
        saveMediaItems()
    }

    func getPhotosDirectory() -> URL? {
        guard let directory = getDocumentDirectory() else { return nil }
        let photosDir = directory.appendingPathComponent("Photos")
        try? FileManager.default.createDirectory(at: photosDir, withIntermediateDirectories: true)
        return photosDir
    }
}
