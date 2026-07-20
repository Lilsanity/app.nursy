import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["option", "submit", "availabilityInput", "modalDatetime"]

  select(event) {
    const button = event.currentTarget

    this.optionTargets.forEach((option) => {
      option.style.border = "2px solid #dee2e6"
      option.style.color = "#495057"
      option.style.background = "white"
    })

    button.style.border = "2px solid #00a896"
    button.style.color = "#00a896"
    button.style.background = "#e0f8f1"

    if (this.hasSubmitTarget) this.submitTarget.disabled = false
    if (this.hasAvailabilityInputTarget) this.availabilityInputTarget.value = button.dataset.availabilityId
    if (this.hasModalDatetimeTarget) this.modalDatetimeTarget.textContent = button.dataset.slotLabel
  }
}
