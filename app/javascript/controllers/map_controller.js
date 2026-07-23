import { Controller } from "@hotwired/stimulus"
import L from "leaflet"

const COLORS = {
  teal:   "#0EA5A0",
  purple: "#8B5CF6",
  orange: "#F59E0B",
  green:  "#10B981"
}

export default class extends Controller {
  static values = { nurses: Array }

  connect() {
    this.map = L.map(this.element)
    this.element.mapInstance = this.map

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '© OpenStreetMap contributors'
    }).addTo(this.map)

    const markers = []

    this.nursesValue.forEach((nurse) => {
      if (nurse.lat && nurse.lng) {
        const color = COLORS[nurse.color] || COLORS.teal

        const icon = L.divIcon({
          className: "custom-map-badge",
          html: `
            <div style="display:flex; align-items:center; gap:6px; background:${color}; color:white; padding:4px 10px; border-radius:20px; font-family:'Inter',sans-serif; font-size:11px; font-weight:700; white-space:nowrap; box-shadow:0 2px 6px rgba(0,0,0,0.25);">
              <span style="background:white; color:${color}; border-radius:50%; width:18px; height:18px; display:flex; align-items:center; justify-content:center; font-size:9px;">${nurse.initials}</span>
              ${nurse.name} · ★ ${nurse.rating}
            </div>
          `,
          iconSize: null
        })

        const marker = L.marker([nurse.lat, nurse.lng], { icon }).addTo(this.map)

        marker.bindPopup(`
          <div style="font-family:'Inter',sans-serif; min-width:180px;">
            <div style="display:flex; align-items:center; gap:8px; margin-bottom:6px;">
              <span style="background:${color}; color:white; border-radius:8px; width:32px; height:32px; display:flex; align-items:center; justify-content:center; font-weight:700; font-size:13px;">${nurse.initials}</span>
              <b style="font-size:14px;">${nurse.name}</b>
            </div>
            <p style="margin:2px 0; font-size:12px; color:#6B7280;">📍 ${nurse.commune}</p>
            <p style="margin:2px 0; font-size:12px; color:#16A34A;">✓ Disponible aujourd'hui</p>
            <p style="margin:2px 0; font-size:12px; color:#F59E0B;">★ ${nurse.rating}</p>
          </div>
        `)

        markers.push(marker)
      }
    })

    if (markers.length > 0) {
      const group = new L.featureGroup(markers)
      this.map.fitBounds(group.getBounds().pad(0.2))
    } else {
      this.map.setView([48.8566, 2.3522], 6)
    }
  }

  disconnect() {
    this.map.remove()
  }
}
