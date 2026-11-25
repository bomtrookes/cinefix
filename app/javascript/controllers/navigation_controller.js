import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navigation"
// Full-screen mobile menu: opens from the hamburger, closes on the X, Escape or navigating away.
export default class extends Controller {
  static targets = ["menu", "button"]

  connect() {
    this.close = this.close.bind(this)
    document.addEventListener("turbo:before-cache", this.close)
  }

  disconnect() {
    document.removeEventListener("turbo:before-cache", this.close)
    document.body.classList.remove("menu-open")
  }

  open() {
    this.menuTarget.classList.add("is-open")
    this.menuTarget.setAttribute("aria-hidden", "false")
    this.buttonTarget.setAttribute("aria-expanded", "true")
    document.body.classList.add("menu-open")
    this.menuTarget.querySelector(".site-menu-close")?.focus()
  }

  close() {
    if (!this.hasMenuTarget || !this.menuTarget.classList.contains("is-open")) return
    this.menuTarget.classList.remove("is-open")
    this.menuTarget.setAttribute("aria-hidden", "true")
    this.buttonTarget.setAttribute("aria-expanded", "false")
    document.body.classList.remove("menu-open")
    this.buttonTarget.focus()
  }

  // Kept so any old data-action="navigation#toggleMenu" still works.
  toggleMenu() {
    this.menuTarget.classList.contains("is-open") ? this.close() : this.open()
  }
}
