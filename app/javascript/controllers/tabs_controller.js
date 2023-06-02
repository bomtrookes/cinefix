import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["cast", "crew", "genres", "castTab", "crewTab", "genreTab"]

  connect() {
    console.log("Tabs Controller Connected")
    this.genresTarget.classList.add("hidden");
    this.crewTarget.classList.add("hidden");
  }
  showCast() {
    console.log("showCast")
    this.castTarget.classList.remove("hidden");
    this.castTabTarget.classList.add("selected");

    this.crewTarget.classList.add("hidden");
    this.crewTabTarget.classList.remove("selected");
    this.genresTarget.classList.add("hidden");
    this.genreTabTarget.classList.remove("selected");
  }
  showCrew() {
    console.log("showCrew")
    this.crewTarget.classList.remove("hidden");
    this.crewTabTarget.classList.add("selected");

    this.castTarget.classList.add("hidden");
    this.genresTarget.classList.add("hidden");
    this.castTabTarget.classList.remove("selected");
    this.genreTabTarget.classList.remove("selected");
  }
  showGenres() {
    console.log("showGenres")
    this.genresTarget.classList.remove("hidden");
    this.genreTabTarget.classList.add("selected");

    this.castTarget.classList.add("hidden");
    this.crewTarget.classList.add("hidden");
    this.castTabTarget.classList.remove("selected");
    this.crewTabTarget.classList.remove("selected");
  }
}
