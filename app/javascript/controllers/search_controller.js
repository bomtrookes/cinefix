import { Controller } from "@hotwired/stimulus"

// Live search: submits the form into the results frame shortly after typing stops
export default class extends Controller {
  static targets = ["form", "input", "clear"]

  connect() {
    this.toggleClear()
  }

  disconnect() {
    clearTimeout(this.timer)
  }

  type() {
    this.toggleClear()
    clearTimeout(this.timer)
    this.timer = setTimeout(() => this.submit(), 300)
  }

  clear() {
    this.inputTarget.value = ""
    this.toggleClear()
    this.submit()
    this.inputTarget.focus()
  }

  submit() {
    const query = this.inputTarget.value.trim()
    if (query === this.lastQuery) return
    this.lastQuery = query
    this.formTarget.requestSubmit()
  }

  toggleClear() {
    this.clearTarget.hidden = this.inputTarget.value.length === 0
  }
}
