import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["link", "indicator"]

  connect() {
    this.activeLink = this.linkTargets.find((link) => link.classList.contains("active"))
    requestAnimationFrame(() => this.moveIndicator(this.activeLink))
  }

  highlight(event) {
    this.moveIndicator(event.currentTarget)
  }

  reset() {
    this.moveIndicator(this.activeLink)
  }

  moveIndicator(link) {
    if (!link) {
      this.indicatorTarget.style.opacity = 0
      return
    }

    this.indicatorTarget.style.left = `${link.offsetLeft}px`
    this.indicatorTarget.style.width = `${link.offsetWidth}px`
    this.indicatorTarget.style.opacity = 1
  }
}
