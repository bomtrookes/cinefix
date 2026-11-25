import { Controller } from "@hotwired/stimulus"

// Person page: switch between jobs, sort the posters, expand the bio
export default class extends Controller {
  static targets = ["job", "grid", "sort", "bio", "bioToggle"]

  connect() {
    // Only offer "Read more" when the bio is actually cut off
    if (this.hasBioTarget && this.bioTarget.scrollHeight <= this.bioTarget.clientHeight + 2) {
      this.bioToggleTarget.hidden = true
    }
  }

  pick(event) {
    const job = event.currentTarget.dataset.job
    this.jobTargets.forEach((button) => button.setAttribute("aria-pressed", button.dataset.job === job))
    this.gridTargets.forEach((grid) => { grid.hidden = grid.dataset.job !== job })
  }

  sort(event) {
    const key = event.currentTarget.dataset.sort
    this.sortTargets.forEach((button) => button.setAttribute("aria-pressed", button.dataset.sort === key))
    this.gridTargets.forEach((grid) => {
      const cards = Array.from(grid.children)
      cards.sort((a, b) => parseFloat(b.dataset[key]) - parseFloat(a.dataset[key]))
      grid.append(...cards)
    })
  }

  toggleBio() {
    const open = this.bioTarget.classList.toggle("is-open")
    this.bioToggleTarget.setAttribute("aria-expanded", open)
    this.bioToggleTarget.textContent = open ? "Show less" : "Read more"
  }
}
