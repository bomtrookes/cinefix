import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["query", "results"]

  async search() {
    const response = await fetch(`/movies/search?query=${this.queryTarget.value}`, { headers: { accept: "application/javascript" } })
    const html = await response.text()
    this.resultsTarget.innerHTML = html
  }
}
