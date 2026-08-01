import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["option", "submit", "availabilityInput", "modalDatetime"]

  select(event) {
    const button = event.currentTarget
    this.optionTargets.forEach((option) => {
      option.classList.remove("selected")
    })
    button.classList.add("selected")
    if (this.hasSubmitTarget) this.submitTarget.disabled = false
    if (this.hasAvailabilityInputTarget) this.availabilityInputTarget.value = button.dataset.availabilityId
    if (this.hasModalDatetimeTarget) this.modalDatetimeTarget.textContent = button.dataset.slotLabel
  }
}
