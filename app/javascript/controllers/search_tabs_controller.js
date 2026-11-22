import { Controller } from "@hotwired/stimulus"

// Switches search results between All and a single kind (films, people, users)
export default class extends Controller {
  static targets = ["tab"]

  pick(event) {
    const kind = event.currentTarget.dataset.kind
    this.element.dataset.mode = kind
    this.tabTargets.forEach((tab) => {
      tab.setAttribute("aria-selected", tab.dataset.kind === kind)
    })
    if (event.currentTarget.classList.contains("search-see-all")) {
      this.element.scrollIntoView({ behavior: "smooth", block: "start" })
    }
  }
}
