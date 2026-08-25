import SwiftUI

struct GlassBackground: View {
    var body: some View {
        ZStack { Color(uiColor: .systemGroupedBackground); Circle().fill(.teal.opacity(0.18)).frame(width: 360).blur(radius: 55).offset(x: 120, y: -280); Circle().fill(.indigo.opacity(0.14)).frame(width: 310).blur(radius: 55).offset(x: -145, y: 260) }.ignoresSafeArea()
    }
}

extension View {
    func glassCard() -> some View { self.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous)).overlay { RoundedRectangle(cornerRadius: 22, style: .continuous).stroke(.white.opacity(0.35), lineWidth: 1) } }
}
