import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["one", "two", "three", "oneTab", "twoTab", "threeTab"]

  connect() {
    console.log("Tabs Controller Connected")
    this.threeTarget.classList.add("hidden");
    this.twoTarget.classList.add("hidden");
  }
  showOne() {
    console.log("showOne")
    this.oneTarget.classList.remove("hidden");
    this.oneTabTarget.classList.add("selected");

    this.twoTarget.classList.add("hidden");
    this.twoTabTarget.classList.remove("selected");
    this.threeTarget.classList.add("hidden");
    this.threeTabTarget.classList.remove("selected");
  }
  showTwo() {
    console.log("showTwo")
    this.twoTarget.classList.remove("hidden");
    this.twoTabTarget.classList.add("selected");

    this.oneTarget.classList.add("hidden");
    this.threeTarget.classList.add("hidden");
    this.oneTabTarget.classList.remove("selected");
    this.threeTabTarget.classList.remove("selected");
  }
  showThree() {
    console.log("showThree")
    this.threeTarget.classList.remove("hidden");
    this.threeTabTarget.classList.add("selected");

    this.oneTarget.classList.add("hidden");
    this.twoTarget.classList.add("hidden");
    this.oneTabTarget.classList.remove("selected");
    this.twoTabTarget.classList.remove("selected");
  }
}
