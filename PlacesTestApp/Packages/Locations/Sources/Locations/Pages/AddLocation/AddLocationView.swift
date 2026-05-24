import SwiftUI

struct AddLocationView: View {
    @Bindable var viewModel: AddLocationViewModel

    var body: some View {
        Form {
            Section("Name (optional)") {
                TextField("e.g. My favourite place", text: $viewModel.name)
                    .accessibilityLabel("Location name, optional")
            }

            Section("Coordinate") {
                TextField("Latitude (-90 to 90)", text: $viewModel.latitudeText)
                    .keyboardType(.numbersAndPunctuation)
                    .accessibilityLabel("Latitude")
                    .accessibilityHint("Enter a value between minus 90 and 90")

                TextField("Longitude (-180 to 180)", text: $viewModel.longitudeText)
                    .keyboardType(.numbersAndPunctuation)
                    .accessibilityLabel("Longitude")
                    .accessibilityHint("Enter a value between minus 180 and 180")
            }

            Section {
                Button {
                    Task { await viewModel.didTapSubmit() }
                } label: {
                    Text("Add to list")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!viewModel.isValid)
                .accessibilityHint("Adds the entered coordinate to the locations list")
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { viewModel.didTapCancel() }
            }
        }
    }
}
