import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.timer = setTimeout(() => this.element.remove(), 2800)
  }

  disconnect() {
    clearTimeout(this.timer)
  }
}
