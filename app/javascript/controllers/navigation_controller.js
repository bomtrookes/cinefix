import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navigation"
export default class extends Controller {
  static targets = ["menuButton"]
  connect() {
    console.log("Navbar controller connected.")
  }

  toggleMenu() {
    const navbarMenu = document.querySelector("nav")
    navbarMenu.classList.toggle("is-active")
  }
}
