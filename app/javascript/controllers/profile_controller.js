import { Controller } from "@hotwired/stimulus"

// Profile page: genre chips filter both the highlights strip and the
// ratings list; the tabs pick Top 5 / Recent / Lowest 5; the sort buttons
// reorder the list. Everything is already on the page, so no requests.
export default class extends Controller {
  static targets = ["genre", "tab", "sort", "card", "strip", "stripTitle", "stripEmpty", "row", "list", "count"]
  static values = { owner: String }

  connect() {
    this.genre = "All"
    this.tab = "top"
    this.sort = "score"
  }

  pickGenre(event) {
    this.genre = event.currentTarget.dataset.genre
    this.press(this.genreTargets, event.currentTarget, "aria-pressed")
    this.renderStrip()
    this.renderList()
  }

  pickTab(event) {
    this.tab = event.currentTarget.dataset.tab
    this.press(this.tabTargets, event.currentTarget, "aria-selected")
    this.renderStrip()
  }

  pickSort(event) {
    this.sort = event.currentTarget.dataset.sort
    this.press(this.sortTargets, event.currentTarget, "aria-pressed")
    this.renderList()
  }

  // ---------- private ----------

  press(buttons, chosen, attribute) {
    buttons.forEach((button) => button.setAttribute(attribute, button === chosen ? "true" : "false"))
  }

  inGenre(el) {
    return this.genre === "All" || (el.dataset.genres || "").split("|").includes(this.genre)
  }

  byScore(a, b) {
    return parseFloat(b.dataset.score) - parseFloat(a.dataset.score) || b.dataset.date - a.dataset.date
  }

  byDate(a, b) {
    return b.dataset.date - a.dataset.date
  }

  renderStrip() {
    const pool = this.cardTargets.filter((card) => this.inGenre(card))
    let picked
    if (this.tab === "recent") picked = pool.sort(this.byDate)
    else if (this.tab === "low") picked = pool.sort((a, b) => this.byScore(b, a))
    else picked = pool.sort((a, b) => this.byScore(a, b))
    picked = picked.slice(0, 5)

    this.cardTargets.forEach((card) => { card.hidden = !picked.includes(card) })
    picked.forEach((card, index) => {
      card.querySelector("[data-label]").textContent = this.tab === "recent" ? card.dataset.when : `#${index + 1}`
      this.stripTarget.appendChild(card)
    })
    this.stripEmptyTarget.hidden = picked.length > 0
    this.stripTarget.scrollLeft = 0

    const genre = this.genre === "All" ? "" : `${this.genre.toLowerCase()} `
    const titles = {
      top: `${this.ownerValue} top 5 ${genre}films`,
      recent: `Recently rated ${genre}films`,
      low: `${this.ownerValue} lowest-rated ${genre}films`
    }
    this.stripTitleTarget.textContent = titles[this.tab]
  }

  renderList() {
    const rows = this.rowTargets
    rows.forEach((row) => { row.hidden = !this.inGenre(row) })

    if (this.sort === "date") rows.sort(this.byDate)
    else if (this.sort === "title") rows.sort((a, b) => a.dataset.title.localeCompare(b.dataset.title))
    else rows.sort((a, b) => this.byScore(a, b))
    rows.forEach((row) => this.listTarget.appendChild(row))

    this.countTarget.textContent = rows.filter((row) => !row.hidden).length
  }
}
