import { Application } from "@hotwired/stimulus"

import VonageController from "./vonage_controller"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

Stimulus.register("vonage", VonageController)

export { application }
