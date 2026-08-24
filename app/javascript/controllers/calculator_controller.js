import { Controller } from "@hotwired/stimulus"
import { attemptUnlock, dissolveThenVisit } from "controllers/unlock"

export default class extends Controller {
  static targets = ["display", "pad"]

  connect() {
    this.expression = ""
    this.taps = 0
    this.code = ""
  }

  press(event) {
    const key = event.currentTarget.dataset.key
    const display = this.displayTarget

    if (key === "clear") {
      this.expression = ""
      display.value = "0"
      return
    }
    if (key === "sign") {
      display.value = String(Number(display.value) * -1)
      this.expression = display.value
      return
    }
    if (key === "percent") {
      display.value = String(Number(display.value) / 100)
      this.expression = display.value
      return
    }
    if (key === "=") {
      this.equals()
      return
    }

    this.expression = (display.value === "0" || display.value === "Error") ? key : this.expression + key
    display.value = this.expression.replace(/\*/g, "×").replace(/\//g, "÷")
  }

  async equals() {
    const raw = this.expression

    if (/^\d{3,}$/.test(raw)) {
      const destination = await attemptUnlock(raw)
      if (destination) {
        dissolveThenVisit(destination)
        return
      }
    }

    this.displayTarget.value = this.evaluate(raw)
    this.expression = this.displayTarget.value
  }

  // Secret gesture: three taps on the temperature reveal the PIN pad.
  tapTemperature() {
    this.taps += 1
    clearTimeout(this.tapTimer)
    this.tapTimer = setTimeout(() => { this.taps = 0 }, 900)
    if (this.taps >= 3) {
      this.taps = 0
      this.padTarget.classList.remove("screen-hidden")
    }
  }

  digit(event) {
    if (this.code.length >= 4) return
    this.code += event.currentTarget.dataset.digit
    this.renderDots()
    if (this.code.length === 4) this.submitCode()
  }

  clearCode() {
    this.code = ""
    this.renderDots()
  }

  async submitCode() {
    const destination = await attemptUnlock(this.code)
    if (destination) {
      dissolveThenVisit(destination)
    } else {
      this.padTarget.classList.add("shake")
      setTimeout(() => this.padTarget.classList.remove("shake"), 350)
      this.clearCode()
    }
  }

  renderDots() {
    this.padTarget.querySelectorAll("[data-dot]").forEach((dot, index) => {
      dot.classList.toggle("bg-slate-700", index < this.code.length)
      dot.classList.toggle("bg-slate-300", index >= this.code.length)
    })
  }

  evaluate(raw) {
    const source = (raw ?? "").replace(/[^0-9+\-*/.]/g, "")
    if (!source) return "Error"

    let tokens = source.match(/(?:\d+\.?\d*)|[+\-*/]/g) ?? []

    tokens = tokens.reduce((merged, token, index) => {
      const previous = merged[merged.length - 1]
      const unary = token === "-" && (previous === undefined || /[+*/-]/.test(previous))
      if (unary) {
        merged.push(token + (tokens[index + 1] ?? ""))
        tokens[index + 1] = ""
      } else if (token !== "") {
        merged.push(token)
      }
      return merged
    }, [])

    const numbers = []
    const operators = []
    const PRECEDENCE = { "+": 1, "-": 1, "*": 2, "/": 2 }
    const apply = (op, b, a) =>
      op === "+" ? a + b :
      op === "-" ? a - b :
      op === "*" ? a * b :
      b === 0 ? NaN : a / b

    for (const token of tokens) {
      if (/^[+\-*/]$/.test(token)) {
        while (
          operators.length &&
          PRECEDENCE[operators[operators.length - 1]] >= PRECEDENCE[token]
        ) {
          numbers.push(apply(operators.pop(), numbers.pop(), numbers.pop()))
        }
        operators.push(token)
      } else {
        numbers.push(parseFloat(token))
      }
    }
    while (operators.length) {
      numbers.push(apply(operators.pop(), numbers.pop(), numbers.pop()))
    }

    const result = numbers[0]
    return Number.isFinite(result) ? String(+result.toFixed(8)) : "Error"
  }
}
