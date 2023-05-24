import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "modal" ]

  connect() {
    console.log("Modal connected")
  }
  open() {
    this.modalTarget.classList.remove('hidden')
    document.querySelector('body').style.overflow = 'hidden'
  }
  close() {
    this.modalTarget.classList.add('hidden')
    document.querySelector('body').style.overflow = 'unset'
  }
}
