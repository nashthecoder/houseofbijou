import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  changed() {
    this.element.requestSubmit()
  }
}
