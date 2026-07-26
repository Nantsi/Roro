// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import * as bootstrap from "bootstrap"

function updateUploadTime() {
    const element = document.getElementById("upload-time");

    if (!element) return;

    const uploadedAt = new Date(element.dataset.uploadedAt);

    const now = new Date();

    const seconds = Math.floor((now - uploadedAt) / 1000);

    if (seconds < 60) {
        element.textContent = `Missing Roro for ${seconds} seconds `;
    } else if (seconds < 3600) {
        element.textContent = `Missing Roro for ${Math.floor(seconds / 60)} minutes ${Math.floor(seconds % 60)} seconds`;
    } else if (seconds < 86400) {
        element.textContent = `Missing Roro for ${Math.floor(seconds / 3600)} hours ${Math.floor((seconds % 3600) / 60)} minutes ${Math.floor(seconds % 60)} seconds`;
    } else {
        element.textContent = `Missing Roro for ${Math.floor(seconds / 86400)} days ${Math.floor((seconds % 86400) / 3600)} hours ${Math.floor((seconds % 3600) / 60)} minutes ${Math.floor(seconds % 60)} seconds`;
    }
}

updateUploadTime();

setInterval(updateUploadTime, 1000);

const element = document.getElementById("upload-date");

if (element) {
    const date = new Date(element.dataset.uploadedAt);

    element.textContent = "Uploaded: " + date.toLocaleString();
}