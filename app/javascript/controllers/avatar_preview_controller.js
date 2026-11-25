import { Controller } from "@hotwired/stimulus"

// Shows the chosen photo straight away, before the form is saved.
export default class extends Controller {
  static targets = ["image", "input", "name"]

  pick() {
    const file = this.inputTarget.files[0]
    if (!file) return

    const img = document.createElement("img")
    img.src = URL.createObjectURL(file)
    img.alt = ""
    img.className = this.imageTarget.className.replace("settings-initials", "").trim()
    img.dataset.avatarPreviewTarget = "image"
    this.imageTarget.replaceWith(img)
    if (this.hasNameTarget) this.nameTarget.textContent = file.name
  }
}
