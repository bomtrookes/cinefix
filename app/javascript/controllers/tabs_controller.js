import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["cast", "crew", "genres"]

  connect() {
    console.log("Tabs Controller Connected")
    this.castTarget.classList.add("hidden");
    this.crewTarget.classList.add("hidden");
  }
  showCast() {
    console.log("showCast")
    this.castTarget.classList.remove("hidden");
    this.crewTarget.classList.add("hidden");
    this.genresTarget.classList.add("hidden");
  }
  showCrew() {
    console.log("showCrew")
    this.crewTarget.classList.remove("hidden");
    this.castTarget.classList.add("hidden");
    this.genresTarget.classList.add("hidden");
  }
  showGenres() {
    console.log("showGenres")
    this.genresTarget.classList.remove("hidden");
    this.castTarget.classList.add("hidden");
    this.crewTarget.classList.add("hidden");
  }
}
