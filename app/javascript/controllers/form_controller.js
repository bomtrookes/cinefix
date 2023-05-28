import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "slider" ]

  connect() {
    console.log("Form controller connected.")
    this.sliderTargets.forEach((slider) => {
      slider.labels[0].firstElementChild.innerText = slider.value
    })
  }

  update() {
    this.sliderTargets.forEach((slider) => {
      slider.labels[0].firstElementChild.innerText = slider.value
    })
  }
}
