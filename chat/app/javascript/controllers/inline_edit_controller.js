import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["display", "form", "input"]
  static values = { url: String }

  edit() {
    this.displayTarget.classList.add("hidden")
    this.formTarget.classList.remove("hidden")
    this.inputTarget.focus()
    this.inputTarget.setSelectionRange(this.inputTarget.value.length, this.inputTarget.value.length)
  }

  cancel() {
    this.formTarget.classList.add("hidden")
    this.displayTarget.classList.remove("hidden")
  }

  cancelOnEscape(event) {
    if (event.key === "Escape") {
      this.cancel()
    }
  }

  async submit(event) {
    event.preventDefault()
    
    const body = this.inputTarget.value.trim()
    if (!body) return

    try {
      const response = await fetch(this.urlValue, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
          "Accept": "text/vnd.turbo-stream.html"
        },
        body: JSON.stringify({ message: { body } })
      })

      if (response.ok) {
        const html = await response.text()
        Turbo.renderStreamMessage(html)
      }
    } catch (error) {
      console.error("Failed to update message:", error)
    }
  }
}
