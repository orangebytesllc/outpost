import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String }

  toggle(event) {
    const checked = event.target.checked

    fetch(this.urlValue, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
      },
      body: JSON.stringify({ admin: checked })
    })
  }
}
