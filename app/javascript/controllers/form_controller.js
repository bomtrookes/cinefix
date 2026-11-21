import { Controller } from "@hotwired/stimulus"

// Rating form: live slider values and total, N/A toggles, and Feature/Documentary labels
export default class extends Controller {
  static targets = ["row", "slider", "value", "na", "label", "hint", "avg", "sum", "max"]
  static values = { maxNa: { type: Number, default: 3 } }

  connect() {
    this.update()
  }

  update() {
    let sum = 0
    let scored = 0
    this.sliderTargets.forEach((slider, i) => {
      if (slider.disabled) {
        this.valueTargets[i].textContent = "–"
        return
      }
      this.valueTargets[i].textContent = slider.value
      sum += Number(slider.value)
      scored += 1
    })

    this.sumTarget.textContent = sum
    this.maxTarget.textContent = scored * 10
    // Same maths as Rating#total_score: average of scored categories, one decimal place
    this.avgTarget.textContent = scored ? Math.round((sum / scored) * 10) / 10 : 0

    const naCount = this.sliderTargets.length - scored
    this.naTargets.forEach((button, i) => {
      const isNa = this.sliderTargets[i].disabled
      button.disabled = !isNa && naCount >= this.maxNaValue
    })
  }

  toggleNa(event) {
    const button = event.currentTarget
    const i = this.naTargets.indexOf(button)
    const slider = this.sliderTargets[i]
    slider.disabled = !slider.disabled
    button.setAttribute("aria-pressed", slider.disabled)
    this.rowTargets[i].classList.toggle("is-na", slider.disabled)
    this.update()
  }

  switchType(event) {
    const type = event.target.value
    this.rowTargets.forEach((row, i) => {
      this.labelTargets[i].textContent = row.dataset[`${type}Label`]
      this.hintTargets[i].textContent = row.dataset[`${type}Hint`]
    })
  }
}
