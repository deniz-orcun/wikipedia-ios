import SwiftUI

struct LocationsListView: View {
    let viewModel: LocationsViewModel

    var body: some View {
        content
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        viewModel.didTapAdd()
                    } label: {
                        Label("Add custom location", systemImage: "plus")
                    }
                    .accessibilityLabel("Add custom location")
                    .accessibilityHint("Enter your own coordinates to open in Wikipedia")
                }
            }
            .task { await viewModel.load() }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("Loading locations…")
                .accessibilityLabel("Loading locations")

        case .loaded(let viewData):
            list(viewData)

        case .failed(let message):
            ContentUnavailableView {
                Label("Couldn't load locations", systemImage: "exclamationmark.triangle")
            } description: {
                Text(message)
            } actions: {
                Button("Retry") { Task { await viewModel.load() } }
                    .buttonStyle(.borderedProminent)
            }
        }
    }

    private func list(_ viewData: [LocationViewData]) -> some View {
        List {
            if viewData.isEmpty {
                Text("No locations were returned.")
                    .foregroundStyle(.secondary)
            } else {
                Section("Locations") {
                    ForEach(viewData) { item in
                        LocationRow(viewData: item) { viewModel.didSelect(item) }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .refreshable { await viewModel.load() }
    }
}
