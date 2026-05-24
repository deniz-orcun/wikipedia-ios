import SwiftUI

struct LocationRow: View {
    let viewData: LocationViewData
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewData.displayName)
                        .font(.headline)
                    Text(viewData.coordinateText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(viewData.displayName)
        .accessibilityValue("Latitude \(viewData.latitude), longitude \(viewData.longitude)")
        .accessibilityHint("Opens this location in the Wikipedia app")
        .accessibilityAddTraits(.isButton)
    }
}
