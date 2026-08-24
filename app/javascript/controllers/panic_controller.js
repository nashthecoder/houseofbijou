import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["armed", "confirming", "latitude", "longitude", "locationStatus"]

  arm() {
    this.armedTarget.classList.add("screen-hidden")
    this.confirmingTarget.classList.remove("screen-hidden")
    this.captureLocation()
  }

  disarm() {
    this.confirmingTarget.classList.add("screen-hidden")
    this.armedTarget.classList.remove("screen-hidden")
  }

  // Best-effort GPS: fills hidden fields before "Send now" is pressed.
  // If the browser denies or times out, the alert still goes out without coordinates.
  captureLocation() {
    if (!("geolocation" in navigator)) {
      this.locationFailed()
      return
    }

    navigator.geolocation.getCurrentPosition(
      (position) => {
        this.latitudeTarget.value = position.coords.latitude.toFixed(6)
        this.longitudeTarget.value = position.coords.longitude.toFixed(6)
        if (this.hasLocationStatusTarget) {
          this.locationStatusTarget.textContent = `Location locked (±${Math.round(position.coords.accuracy)} m). It travels with your alert.`
        }
      },
      () => this.locationFailed(),
      { enableHighAccuracy: true, timeout: 8000, maximumAge: 30000 }
    )
  }

  locationFailed() {
    if (this.hasLocationStatusTarget) {
      this.locationStatusTarget.textContent = "Location unavailable — the alert still sends without it."
    }
  }
}
