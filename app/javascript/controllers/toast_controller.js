import { Controller } from "@hotwired/stimulus"

// Fades a flash toast out after a few seconds, then removes it
export default class extends Controller {
  connect() {
    setTimeout(() => this.element.classList.add("hide"), 3500)
    this.element.addEventListener("transitionend", () => this.element.remove())
  }
}
