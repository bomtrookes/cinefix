import { Controller } from "@hotwired/stimulus"

// Shows the rest of a list (full cast, full crew) and back again
export default class extends Controller {
  static targets = ["button"]
  static values = { more: String, less: String }

  toggle() {
    const open = this.element.classList.toggle("is-open")
    this.buttonTarget.setAttribute("aria-expanded", open)
    this.buttonTarget.textContent = open ? this.lessValue : this.moreValue
  }
}
