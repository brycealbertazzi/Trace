//
//  EntriesContentView.swift
//  Trace
//
//  Created by Bryce Albertazzi on 1/28/26.
//

import SwiftUI

struct EntriesContentView: View {
    @ObservedObject var dataManager: JournalDataManager
    @State private var showingNewEntry = false
    @State private var newEntryText = ""

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(Array(dataManager.entries.sorted(by: { $0.date > $1.date }).enumerated()), id: \.element.id) { index, entry in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(entry.text)
                                    .font(.body)
                                    .foregroundColor(.primary)

                                Text(entry.date, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.white)
                                    .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
                            )
                            .padding(.horizontal)
                            .transition(.asymmetric(
                                insertion: .scale.combined(with: .opacity),
                                removal: .opacity
                            ))
                            .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(Double(index) * 0.05), value: dataManager.entries.count)
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
                    .padding(.top, 16)
                    .padding(.bottom, 100)
                }
            }

            // Floating action button
            VStack {
                Spacer()

                HStack {
                    Spacer()

                    Button(action: {
                        showingNewEntry = true
                    }) {
                        Image(systemName: "plus")
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
                    .scaleEffect(showingNewEntry ? 0.9 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: showingNewEntry)
                    .padding(.trailing, 20)
                    .padding(.bottom, 30)
                }
            }
        }
        .sheet(isPresented: $showingNewEntry) {
            NavigationView {
                ZStack {
                    LinearGradient(
                        colors: [Color.traceBackground1, Color.traceBackground2],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()

                    VStack {
                        TextEditor(text: $newEntryText)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.white)
                                    .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
                            )
                            .padding()
                            .scrollContentBackground(.hidden)
                    }
                }
                .navigationTitle("New Entry")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            newEntryText = ""
                            showingNewEntry = false
                        }
                        .foregroundColor(Color.traceHeading)
                    }

                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            if !newEntryText.isEmpty {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    let newEntry = JournalEntry(text: newEntryText, date: Date())
                                    dataManager.addEntry(newEntry)
                                }
                                newEntryText = ""
                                showingNewEntry = false
                            }
                        }
                        .foregroundColor(Color.traceHeading)
                        .fontWeight(.semibold)
                    }
                }
            }
        }
    }
}

#Preview {
    EntriesContentView(dataManager: JournalDataManager())
}
