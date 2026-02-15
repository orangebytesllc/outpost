import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog"]

  connect() {
    this.closeOnEscape = this.closeOnEscape.bind(this)
  }

  open() {
    this.dialogTarget.showModal()
    document.addEventListener("keydown", this.closeOnEscape)
  }

  close() {
    this.dialogTarget.close()
    document.removeEventListener("keydown", this.closeOnEscape)
  }

  closeOnBackdropClick(event) {
    if (event.target === this.dialogTarget) {
      this.close()
    }
  }

  closeOnEscape(event) {
    if (event.key === "Escape") {
      this.close()
    }
  }

  disconnect() {
    document.removeEventListener("keydown", this.closeOnEscape)
  }
}
