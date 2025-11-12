import SwiftUI

// A lightweight fallback implementation of a "liquid glass" style.
// Provides a subtle background blur with a translucent overlay and rounded corners.
// This matches the API used in the project: .liquidGlass(cornerRadius:opacity:)

private struct LiquidGlassModifier: ViewModifier {
    let cornerRadius: CGFloat
    let opacity: CGFloat

    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content
            .background(
                // Use material when available; fallback to blur + translucent fill
                Group {
                    if #available(iOS 15.0, macOS 12.0, *) {
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .fill(.ultraThinMaterial)
                            .opacity(Double(max(0, min(1, opacity + 0.05))))
                    } else {
                        // Fallback: simple blur-like translucent overlay
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .fill((colorScheme == .dark ? Color.white : Color.black).opacity(opacity * 0.1))
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                // Subtle stroke to enhance the glass edge
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
            )
    }
}

public extension View {
    /// Applies a subtle glass-like effect behind the view.
    /// - Parameters:
    ///   - cornerRadius: The corner radius to apply to the glass background.
    ///   - opacity: A value from 0...1 that controls the translucency intensity.
    /// - Returns: A view with a glass-like background effect.
    func liquidGlass(cornerRadius: CGFloat = 12, opacity: CGFloat = 0.08) -> some View {
        modifier(LiquidGlassModifier(cornerRadius: cornerRadius, opacity: opacity))
    }
}
