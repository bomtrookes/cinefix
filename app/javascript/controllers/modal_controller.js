import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Modal connected")
  }
  open() {
    this.element.classList.remove('hidden')
  }
  close() {
    this.element.classList.add('hidden')
  }
}
