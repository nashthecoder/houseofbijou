import { Controller } from "@hotwired/stimulus"

// Decoy "Tile match" game. Genuinely playable; also houses the hidden
// unlock trigger (triple-tap handled by the calculator controller).
export default class extends Controller {
  static targets = ["board", "tile", "moves"]

  connect() {
    this.symbols = this.tileTargets.map((tile) => tile.dataset.symbol)
    this.first = null
    this.locked = false
    this.moves = 0
  }

  flip(event) {
    if (this.locked) return
    const tile = event.currentTarget
    if (tile.classList.contains("is-matched") || tile === this.first) return

    tile.classList.add("is-flipped")

    if (!this.first) {
      this.first = tile
      return
    }

    this.moves += 1
    this.movesTarget.textContent = `Moves: ${this.moves}`

    if (this.first.dataset.symbol === tile.dataset.symbol) {
      this.first.classList.add("is-matched")
      tile.classList.add("is-matched")
      this.first = null
      if (this.tileTargets.every((t) => t.classList.contains("is-matched"))) {
        setTimeout(() => this.restart(), 900)
      }
    } else {
      this.locked = true
      const firstCard = this.first
      this.first = null
      setTimeout(() => {
        firstCard.classList.remove("is-flipped")
        tile.classList.remove("is-flipped")
        this.locked = false
      }, 700)
    }
  }

  restart() {
    const pool = [...this.symbols].sort(() => Math.random() - 0.5)
    this.tileTargets.forEach((tile, index) => {
      tile.dataset.symbol = pool[index]
      tile.querySelector(".tg-face").textContent = pool[index]
      tile.classList.remove("is-flipped", "is-matched")
      tile.setAttribute("aria-label", `Hidden tile ${index + 1}`)
    })
    this.moves = 0
    this.movesTarget.textContent = "Moves: 0"
    this.first = null
    this.locked = false
  }
}
