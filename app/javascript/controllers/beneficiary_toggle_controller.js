import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["fields"]

  toggle(event) {
    this.fieldsTarget.classList.toggle("d-none", !event.target.checked)
  }
}
