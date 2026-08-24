import { Controller } from "@hotwired/stimulus"

// Removes messages from the DOM the moment their delete-timer runs out.
export default class extends Controller {
  connect() {
    this.tick = this.tick.bind(this)
    this.timer = setInterval(this.tick, 1000)
  }

  disconnect() {
    clearInterval(this.timer)
  }

  tick() {
    const now = Date.now()
    this.element.querySelectorAll("[data-countdown-expires-at]").forEach((node) => {
      const expiresAt = node.dataset.countdownExpiresAt
      if (!expiresAt) return
      if (new Date(expiresAt).getTime() <= now) {
        node.remove()
        this.element.dispatchEvent(new CustomEvent("countdown:expired", { bubbles: true }))
      }
    })
  }
}
